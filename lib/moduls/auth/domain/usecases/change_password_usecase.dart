import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../entities/auth_result.dart';
import '../entities/message_entity.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
}

class ChangePasswordUseCase
    implements UseCase<MessageEntity, ChangePasswordParams> {
  final AuthRepository _repository;

  const ChangePasswordUseCase(this._repository);

  @override
  Future<Either<NetworkFailure, AuthResult<MessageEntity>>> call(
    ChangePasswordParams params,
  ) {
    return _repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}
