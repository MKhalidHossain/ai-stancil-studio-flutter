import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../entities/auth_result.dart';
import '../entities/auth_session_entity.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class LoginUseCase implements UseCase<AuthSessionEntity, LoginParams> {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  @override
  Future<Either<NetworkFailure, AuthResult<AuthSessionEntity>>> call(
    LoginParams params,
  ) {
    return _repository.login(email: params.email, password: params.password);
  }
}
