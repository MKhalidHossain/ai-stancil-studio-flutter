import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../entities/auth_result.dart';
import '../entities/message_entity.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class LogoutUseCase implements UseCase<MessageEntity, NoParams> {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  @override
  Future<Either<NetworkFailure, AuthResult<MessageEntity>>> call(
    NoParams params,
  ) {
    return _repository.logout();
  }
}
