import 'package:dartz/dartz.dart';
import '../../../../core/network/models/network_failure.dart';
import '../entities/auth_result.dart';

abstract class UseCase<Type, Params> {
  Future<Either<NetworkFailure, AuthResult<Type>>> call(Params params);
}

class NoParams {
  const NoParams();
}
