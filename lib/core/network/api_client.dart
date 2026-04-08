// lib/core/network/api_client.dart

import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'constants/api_constants.dart';
import 'dio_error_handler.dart';
import 'models/base_response.dart';
import 'models/network_failure.dart';
import 'services/api_cache_service.dart';
import 'services/connectivity_service.dart';
import '/core/network/models/network_success.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'services/auth_storage_service.dart';

class ApiClient {
  late final Dio _dio;
  // late final CustomCacheInterceptor _cacheInterceptor;
  late final ConnectivityService _connectivityService;
  late final ApiCacheService _cacheService;

  bool _isRefreshing = false;
  final List<Completer<void>> _pendingRequests = [];

  // Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  // final SecureStoreServices _secureStoreServices = SecureStoreServices();
  final AuthStorageService _authStorageService = AuthStorageService();

  // factory ApiClient() {
  //   _instance ??= ApiClient._internal();
  //   _instance!._initialize();
  //   return _instance!;
  // }

  bool _isInitialized = false;
  late final Future<void> _ready;

  ApiClient._internal() {
    if (!_isInitialized) {
      _ready = _initialize();
      _isInitialized = true;
    }
  }

  Future<void> _initialize() async {
    // Initialize connectivity service with error handling
    try {
      _connectivityService = ConnectivityService.instance;
      await _connectivityService.initialize();
    } catch (e) {
      if (kDebugMode) DPrint.log("Using fallback connectivity: $e");
      // _connectivityService = _FallbackConnectivityService();
    }

    _cacheService = ApiCacheService();
    await _cacheService.initialize();

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseDomain,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 400,
      ),
    );
  }

  /// Check connectivity before making requests
  Future<Either<NetworkFailure, void>> _checkConnectivity() async {
    if (!_connectivityService.isConnected) {
      // Try to wait for connection briefly
      try {
        await _connectivityService.waitForConnection(
          timeout: const Duration(seconds: 2),
        );
      } catch (e) {
        return const Left(NoInternetFailure());
      }
    }
    return const Right(null);
  }

  /// Refresh token method
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _authStorageService.getRefreshToken();
      DPrint.info("Refreshing ...");

      if (refreshToken == null) {
        return false;
      }

      final response = await _dio.post(
        ApiConstants.auth.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json,
      );

      DPrint.log(
        "🔄 Refresh Token Response -> ${ApiConstants.auth.refreshToken} ${response.statusCode} ${response.data}",
      );

      if (baseResponse.success && baseResponse.data != null) {
        final data = baseResponse.data!;
        final newAccessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          await _authStorageService.storeAccessToken(
            accessToken: newAccessToken,
          );
        }
        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await _authStorageService.storeRefreshToken(
            refreshToken: newRefreshToken,
          );
        }

        return newAccessToken != null && newAccessToken.isNotEmpty;
      }

      // Navigate to login screen - you'll need to implement this based on your navigation
      await _logout();
      return false;
    } catch (e) {
      DPrint.log("Refresh token error: $e");
      await _logout();
      return false;
    }
  }

  Future<void> _logout() async {
    try {
      // Clear stored tokens
      await _authStorageService.clearAuthData();

      // Delay navigation slightly to ensure UI is ready
      await Future.delayed(Duration.zero);
      // Get.offAll(() => LoginScreen(), transition: Transition.leftToRight);
    } catch (e) {
      DPrint.error("Logout error: $e");
    }
  }

  /// Main request method using Either
  Future<Either<NetworkFailure, NetworkSuccess<T>>> _request<T>({
    required String method,
    required String endpoint,
    required T Function(dynamic) fromJsonT,
    dynamic data,
    FormData? fromData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool cache = false,
    Duration? cacheDuration,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _ready;
    final bool isGet = method.toUpperCase() == 'GET';
    final connectivityCheck = await _checkConnectivity();
    if (connectivityCheck.isLeft()) {
      if (isGet && cache) {
        final cachedData = await _cacheService.getCachedData(
          endpoint,
          requestData: queryParameters,
        );

        if (cachedData != null) {
          DPrint.info('Serving cached data for $endpoint (offline)');
          return Right(
            NetworkSuccess<T>(
              data: fromJsonT(cachedData),
              message: 'Served from cache (offline)',
              statusCode: 200,
            ),
          );
        }
      }
      return const Left(NoInternetFailure());
    }

    try {
      if (_isRefreshing) {
        final completer = Completer<void>();
        _pendingRequests.add(completer);
        await completer.future;
      }

      options = await _addAuthHeader(options);

      if (data != null) {
        DPrint.log("🛜 Api Endpoint -> $method ||=> $endpoint \n Data: $data");
      } else if (fromData != null) {
        DPrint.log(
          "🛜 Api Endpoint -> $method ||=> $endpoint \n FormData: $fromData",
        );
      } else {
        DPrint.warn("No Data");
      }

      final requestData = fromData ?? data;

      final response = await _dio.request(
        endpoint,
        data: requestData,
        queryParameters: queryParameters,
        options: options..method = method,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      DPrint.log(
        "☁️  BASE Response -> $method ||=> ${response.statusCode} ||=> Api: $endpoint \n Api: ${response.data}",
      );

      final baseResponse = BaseResponse<T>.fromJson(response.data, fromJsonT);

      // final data = (baseResponse.data as T);

      if (baseResponse.success) {
        final message = baseResponse.message;
        final statusCode = response.statusCode ?? 200;

        final successResult = NetworkSuccess<T>(
          data: baseResponse.data as T,
          message: message,
          statusCode: statusCode,
        );

        // 4. Cache the fresh response if it's a cached GET request
        if (isGet && cache) {
          final rawResponseData = response.data as Map<String, dynamic>?;
          final dataToCache = rawResponseData?['data'];

          if (dataToCache != null) {
            await _cacheService.cacheData(
              endpoint,
              data: dataToCache,
              requestData: queryParameters,
              cacheDuration: cacheDuration,
            );
            DPrint.info('Cached fresh response for $endpoint');
          }
        }

        return Right(successResult);
      }

      return Left(
        ServerFailure(
          message: baseResponse.combinedErrorMessage,
          statusCode: response.statusCode ?? 400,
        ),
      );
    } on DioException catch (error) {
      // DPrint.error("Api DioException : $error");
      if (error.response?.statusCode == 401 && !_isRefreshing) {
        _isRefreshing = true;
        try {
          if (await _refreshToken()) {
            return _request<T>(
              method: method,
              endpoint: endpoint,
              fromJsonT: fromJsonT,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              cache: cache,
              cacheDuration: cacheDuration,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            );
          }
        } finally {
          _isRefreshing = false;
          for (var completer in _pendingRequests) {
            completer.complete();
          }
          _pendingRequests.clear();
        }
      }
      return Left(_handleDioError(error));
    } catch (e) {
      DPrint.log("Unexpected error: $e");
      return const Left(
        UnknownFailure(message: "An unexpected error occurred"),
      );
    }
  }

  /// HTTP Methods using Either
  Future<Either<NetworkFailure, NetworkSuccess<T>>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJsonT,
    Options? options,
    CancelToken? cancelToken,
    bool cache = false,
    Duration? cacheDuration,
    ProgressCallback? onReceiveProgress,
  }) => _request(
    method: 'GET',
    endpoint: endpoint,
    fromJsonT: fromJsonT,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    cache: cache,
    cacheDuration: cacheDuration,
    onReceiveProgress: onReceiveProgress,
  );

  Future<Either<NetworkFailure, NetworkSuccess<T>>> post<T>({
    required String endpoint,
    dynamic data,
    required T Function(dynamic) fromJsonT,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    FormData? formData,
  }) => _request(
    method: 'POST',
    endpoint: endpoint,
    fromJsonT: fromJsonT,
    data: data,
    options: options,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    fromData: formData,
  );

  Future<Either<NetworkFailure, NetworkSuccess<T>>> patch<T>({
    required String endpoint,
    dynamic data,
    required T Function(dynamic) fromJsonT,
    Options? options,
    CancelToken? cancelToken,
    FormData? formData,
  }) => _request(
    method: 'PATCH',
    endpoint: endpoint,
    fromJsonT: fromJsonT,
    data: data,
    options: options,
    cancelToken: cancelToken,
    fromData: formData,
  );

  Future<Either<NetworkFailure, NetworkSuccess<T>>> put<T>({
    required String endpoint,
    dynamic data,
    required T Function(dynamic) fromJsonT,
    Options? options,
    CancelToken? cancelToken,
    FormData? formData,
  }) => _request(
    method: 'PUT',
    endpoint: endpoint,
    fromJsonT: fromJsonT,
    data: data,
    options: options,
    cancelToken: cancelToken,
    fromData: formData,
  );

  Future<Either<NetworkFailure, NetworkSuccess<T>>> delete<T>({
    required String endpoint,
    dynamic data,
    required T Function(dynamic) fromJsonT,
    Options? options,
    CancelToken? cancelToken,
    FormData? formData,
  }) => _request(
    method: 'DELETE',
    endpoint: endpoint,
    fromJsonT: fromJsonT,
    data: data,
    options: options,
    cancelToken: cancelToken,
    fromData: formData,
  );

  /// Helper Methods
  Future<Options> _addAuthHeader(Options? options) async {
    options ??= Options();

    final accessToken = await _authStorageService.getAccessToken();

    if (kDebugMode) DPrint.log("Current Access Token: $accessToken");

    if (accessToken != null) {
      options.headers ??= {};
      options.headers!['Authorization'] = 'Bearer $accessToken';
    }
    if (kDebugMode) DPrint.log("Authorization header : ${options.headers}");
    return options;
  }

  /// Updated error handling to return NetworkFailure instead of ApiResult
  NetworkFailure _handleDioError(DioException error) {
    // Check if we have a response with error details
    if (error.response != null) {
      if (kDebugMode) DPrint.log("** Dio Error: ${error.response!.data}");
      try {
        final responseData = error.response?.data;
        if (responseData is Map) {
          if (responseData.containsKey('errorSources')) {
            final baseResponse = BaseResponse<void>.fromJson(
              responseData as Map<String, dynamic>,
              (json) {},
            );

            // Check if it's validation errors
            if (baseResponse.errorSources != null &&
                baseResponse.errorSources!.isNotEmpty) {
              return ValidationFailure(
                message: baseResponse.combinedErrorMessage,
                errors: baseResponse.errorSources!
                    .map((e) => e.message)
                    .toList(),
                statusCode: error.response?.statusCode ?? 400,
              );
            }

            return ServerFailure(
              message: baseResponse.combinedErrorMessage,
              statusCode: error.response?.statusCode ?? 400,
            );
          }
          if (responseData.containsKey('message')) {
            return ServerFailure(
              message: responseData['message'] as String,
              statusCode: error.response?.statusCode ?? 400,
            );
          }
        }
      } catch (e) {
        DPrint.log("Error parsing error response: $e");
      }
    }

    // Handle specific error types
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          message: dioErrorToUserMessage(error),
          statusCode: error.response?.statusCode ?? 408,
        );

      case DioExceptionType.connectionError:
        return const ConnectionFailure(message: "No internet connection");

      default:
        if (error.response?.statusCode == 401) {
          return UnauthorizedFailure(
            message: dioErrorToUserMessage(error),
            statusCode: 401,
          );
        }

        return ServerFailure(
          message: dioErrorToUserMessage(error),
          statusCode: error.response?.statusCode ?? 0,
        );
    }
  }

  /// Get connectivity service instance
  ConnectivityService get connectivityService => _connectivityService;
}
