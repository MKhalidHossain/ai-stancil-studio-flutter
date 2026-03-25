import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../entities/auth_result.dart';
import '../entities/message_entity.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class VerifyOtpParams {
  final String email;
  final String otp;

  const VerifyOtpParams({required this.email, required this.otp});
}

class VerifyOtpUseCase implements UseCase<MessageEntity, VerifyOtpParams> {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  @override
  Future<Either<NetworkFailure, AuthResult<MessageEntity>>> call(
    VerifyOtpParams params,
  ) {
    return _repository.verifyOtp(email: params.email, otp: params.otp);
  }
}
