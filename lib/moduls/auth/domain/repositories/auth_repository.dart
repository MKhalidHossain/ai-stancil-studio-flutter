import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../entities/access_token_entity.dart';
import '../entities/auth_result.dart';
import '../entities/auth_session_entity.dart';
import '../entities/message_entity.dart';

abstract class AuthRepository {
  Future<Either<NetworkFailure, AuthResult<AuthSessionEntity>>> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<NetworkFailure, AuthResult<AuthSessionEntity>>> login({
    required String email,
    required String password,
  });

  Future<Either<NetworkFailure, AuthResult<AccessTokenEntity>>> refreshToken();

  Future<Either<NetworkFailure, AuthResult<MessageEntity>>> forgotPassword({
    required String email,
  });

  Future<Either<NetworkFailure, AuthResult<MessageEntity>>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Either<NetworkFailure, AuthResult<AccessTokenEntity>>> resetPassword({
    required String email,
    required String newPassword,
  });

  Future<Either<NetworkFailure, AuthResult<MessageEntity>>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<NetworkFailure, AuthResult<MessageEntity>>> logout();
}
