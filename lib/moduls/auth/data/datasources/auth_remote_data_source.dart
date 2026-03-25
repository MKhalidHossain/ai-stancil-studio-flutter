import 'package:dartz/dartz.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../models/access_token_model.dart';
import '../models/auth_session_model.dart';
import '../models/message_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Either<NetworkFailure, NetworkSuccess<AuthSessionModel>>> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return _apiClient.post<AuthSessionModel>(
      endpoint: ApiConstants.auth.signup,
      data: {'name': name, 'email': email, 'password': password},
      fromJsonT: (json) =>
          AuthSessionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Either<NetworkFailure, NetworkSuccess<AuthSessionModel>>> login({
    required String email,
    required String password,
  }) {
    return _apiClient.post<AuthSessionModel>(
      endpoint: ApiConstants.auth.login,
      data: {'email': email, 'password': password},
      fromJsonT: (json) =>
          AuthSessionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Either<NetworkFailure, NetworkSuccess<AccessTokenModel>>> refreshToken({
    String? refreshToken,
  }) {
    final data = refreshToken == null ? null : {'refreshToken': refreshToken};
    return _apiClient.post<AccessTokenModel>(
      endpoint: ApiConstants.auth.refreshToken,
      data: data,
      fromJsonT: (json) =>
          AccessTokenModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Either<NetworkFailure, NetworkSuccess<MessageModel>>> forgotPassword({
    required String email,
  }) {
    return _apiClient.post<MessageModel>(
      endpoint: ApiConstants.auth.forgotPassword,
      data: {'email': email},
      fromJsonT: (json) => MessageModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Either<NetworkFailure, NetworkSuccess<MessageModel>>> verifyOtp({
    required String email,
    required String otp,
  }) {
    return _apiClient.post<MessageModel>(
      endpoint: ApiConstants.auth.verifyOtp,
      data: {'email': email, 'otp': otp},
      fromJsonT: (json) => MessageModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Either<NetworkFailure, NetworkSuccess<AccessTokenModel>>> resetPassword({
    required String email,
    required String newPassword,
  }) {
    return _apiClient.post<AccessTokenModel>(
      endpoint: ApiConstants.auth.resetPassword,
      data: {'email': email, 'newPassword': newPassword},
      fromJsonT: (json) =>
          AccessTokenModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Either<NetworkFailure, NetworkSuccess<MessageModel>>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _apiClient.post<MessageModel>(
      endpoint: ApiConstants.auth.changePassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
      fromJsonT: (json) => MessageModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Either<NetworkFailure, NetworkSuccess<MessageModel>>> logout() {
    return _apiClient.post<MessageModel>(
      endpoint: ApiConstants.auth.logout,
      data: {},
      fromJsonT: (json) => MessageModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
