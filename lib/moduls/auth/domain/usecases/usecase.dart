import 'package:dartz/dartz.dart';
import '../../../../core/network/models/network_failure.dart';
import '../entities/auth_result.dart';

abstract class UseCase<ResultType, Params> {
  Future<Either<NetworkFailure, AuthResult<ResultType>>> call(Params params);
}

class NoParams {
  const NoParams();
}
