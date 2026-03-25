import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../entities/access_token_entity.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class RefreshTokenUseCase implements UseCase<AccessTokenEntity, NoParams> {
  final AuthRepository _repository;

  const RefreshTokenUseCase(this._repository);

  @override
  Future<Either<NetworkFailure, AuthResult<AccessTokenEntity>>> call(
    NoParams params,
  ) {
    return _repository.refreshToken();
  }
}
