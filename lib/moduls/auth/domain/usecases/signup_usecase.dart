import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../entities/auth_result.dart';
import '../entities/auth_session_entity.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class SignupParams {
  final String name;
  final String email;
  final String password;

  const SignupParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignupUseCase implements UseCase<AuthSessionEntity, SignupParams> {
  final AuthRepository _repository;

  const SignupUseCase(this._repository);

  @override
  Future<Either<NetworkFailure, AuthResult<AuthSessionEntity>>> call(
    SignupParams params,
  ) {
    return _repository.signup(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}
