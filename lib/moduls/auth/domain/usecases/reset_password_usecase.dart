import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../entities/access_token_entity.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class ResetPasswordParams {
  final String email;
  final String newPassword;

  const ResetPasswordParams({required this.email, required this.newPassword});
}

class ResetPasswordUseCase
    implements UseCase<AccessTokenEntity, ResetPasswordParams> {
  final AuthRepository _repository;

  const ResetPasswordUseCase(this._repository);

  @override
  Future<Either<NetworkFailure, AuthResult<AccessTokenEntity>>> call(
    ResetPasswordParams params,
  ) {
    return _repository.resetPassword(
      email: params.email,
      newPassword: params.newPassword,
    );
  }
}
