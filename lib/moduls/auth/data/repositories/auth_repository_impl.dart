import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../domain/entities/access_token_entity.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthStorageService _authStorageService;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthStorageService authStorageService,
  }) : _remoteDataSource = remoteDataSource,
       _authStorageService = authStorageService;

  @override
  Future<Either<NetworkFailure, AuthResult<AuthSessionEntity>>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.signup(
      name: name,
      email: email,
      password: password,
    );

    return await result.fold(
      (failure) async => Left(failure),
      (success) async {
        await _storeSession(success.data);
        return Right(
          AuthResult(data: success.data, message: success.message),
        );
      },
    );
  }

  @override
  Future<Either<NetworkFailure, AuthResult<AuthSessionEntity>>> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    return await result.fold(
      (failure) async => Left(failure),
      (success) async {
        await _storeSession(success.data);
        return Right(
          AuthResult(data: success.data, message: success.message),
        );
      },
    );
  }

  @override
  Future<Either<NetworkFailure, AuthResult<AccessTokenEntity>>> refreshToken() async {
    final refreshToken = await _authStorageService.getRefreshToken();
    final result = await _remoteDataSource.refreshToken(
      refreshToken: refreshToken,
    );

    return await result.fold(
      (failure) async => Left(failure),
      (success) async {
        await _authStorageService.storeAccessToken(
          accessToken: success.data.accessToken,
        );
        return Right(
          AuthResult(data: success.data, message: success.message),
        );
      },
    );
  }

  @override
  Future<Either<NetworkFailure, AuthResult<MessageEntity>>> forgotPassword({
    required String email,
  }) async {
    final result = await _remoteDataSource.forgotPassword(email: email);
    return result.fold(
      (failure) => Left(failure),
      (success) => Right(
        AuthResult(data: success.data, message: success.message),
      ),
    );
  }

  @override
  Future<Either<NetworkFailure, AuthResult<MessageEntity>>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final result = await _remoteDataSource.verifyOtp(email: email, otp: otp);
    return result.fold(
      (failure) => Left(failure),
      (success) => Right(
        AuthResult(data: success.data, message: success.message),
      ),
    );
  }

  @override
  Future<Either<NetworkFailure, AuthResult<AccessTokenEntity>>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final result = await _remoteDataSource.resetPassword(
      email: email,
      newPassword: newPassword,
    );

    return await result.fold(
      (failure) async => Left(failure),
      (success) async {
        await _authStorageService.storeAccessToken(
          accessToken: success.data.accessToken,
        );
        return Right(
          AuthResult(data: success.data, message: success.message),
        );
      },
    );
  }

  @override
  Future<Either<NetworkFailure, AuthResult<MessageEntity>>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    return result.fold(
      (failure) => Left(failure),
      (success) => Right(
        AuthResult(data: success.data, message: success.message),
      ),
    );
  }

  @override
  Future<Either<NetworkFailure, AuthResult<MessageEntity>>> logout() async {
    final result = await _remoteDataSource.logout();

    return await result.fold(
      (failure) async => Left(failure),
      (success) async {
        await _authStorageService.clearAuthData();
        return Right(
          AuthResult(data: success.data, message: success.message),
        );
      },
    );
  }

  Future<void> _storeSession(AuthSessionEntity session) async {
    await _authStorageService.storeAccessToken(accessToken: session.accessToken);
    if (session.refreshToken != null && session.refreshToken!.isNotEmpty) {
      await _authStorageService.storeRefreshToken(
        refreshToken: session.refreshToken!,
      );
    }
    if (session.user.id.isNotEmpty) {
      await _authStorageService.storeUserId(session.user.id);
    }
  }
}
