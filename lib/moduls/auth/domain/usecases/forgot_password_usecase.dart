import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../entities/auth_result.dart';
import '../entities/message_entity.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class ForgotPasswordParams {
  final String email;

  const ForgotPasswordParams({required this.email});
}

class ForgotPasswordUseCase
    implements UseCase<MessageEntity, ForgotPasswordParams> {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<NetworkFailure, AuthResult<MessageEntity>>> call(
    ForgotPasswordParams params,
  ) {
    return _repository.forgotPassword(email: params.email);
  }
}
