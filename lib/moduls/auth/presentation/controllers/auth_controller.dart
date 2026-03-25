import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../domain/entities/access_token_entity.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

class AuthController extends BaseController {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthController({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required RefreshTokenUseCase refreshTokenUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _signupUseCase = signupUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _refreshTokenUseCase = refreshTokenUseCase,
       _changePasswordUseCase = changePasswordUseCase,
       _logoutUseCase = logoutUseCase;

  final Rxn<UserEntity> currentUser = Rxn<UserEntity>();
  final RxString resetEmail = ''.obs;

  void setResetEmail(String email) {
    resetEmail.value = email;
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    return _runAuthSessionAction(
      () => _signupUseCase(
        SignupParams(name: name, email: email, password: password),
      ),
    );
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    return _runAuthSessionAction(
      () => _loginUseCase(LoginParams(email: email, password: password)),
    );
  }

  Future<bool> requestPasswordResetOtp({required String email}) async {
    setResetEmail(email);
    return _runMessageAction(
      () => _forgotPasswordUseCase(ForgotPasswordParams(email: email)),
    );
  }

  Future<bool> verifyOtp({required String otp}) async {
    final email = resetEmail.value.trim();
    if (email.isEmpty) {
      _setInlineError('Email is missing. Please request OTP again.');
      return false;
    }

    return _runMessageAction(
      () => _verifyOtpUseCase(VerifyOtpParams(email: email, otp: otp)),
    );
  }

  Future<bool> resetPassword({required String newPassword}) async {
    final email = resetEmail.value.trim();
    if (email.isEmpty) {
      _setInlineError('Email is missing. Please request OTP again.');
      return false;
    }

    return _runAccessTokenAction(
      () => _resetPasswordUseCase(
        ResetPasswordParams(email: email, newPassword: newPassword),
      ),
    );
  }

  Future<bool> refreshToken() async {
    return _runAccessTokenAction(
      () => _refreshTokenUseCase(const NoParams()),
      showSuccess: false,
    );
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return _runMessageAction(
      () => _changePasswordUseCase(
        ChangePasswordParams(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ),
    );
  }

  Future<bool> logout() async {
    return _runMessageAction(() => _logoutUseCase(const NoParams()));
  }

  Future<bool> _runAuthSessionAction(
    Future<Either<NetworkFailure, AuthResult<AuthSessionEntity>>> Function()
    action,
  ) async {
    return _runAction<AuthSessionEntity>(
      action,
      onSuccess: (session) {
        currentUser.value = session.user;
      },
    );
  }

  Future<bool> _runAccessTokenAction(
    Future<Either<NetworkFailure, AuthResult<AccessTokenEntity>>> Function()
    action, {
    bool showSuccess = true,
  }) async {
    return _runAction<AccessTokenEntity>(
      action,
      showSuccess: showSuccess,
    );
  }

  Future<bool> _runMessageAction(
    Future<Either<NetworkFailure, AuthResult<MessageEntity>>> Function()
    action,
  ) async {
    return _runAction<MessageEntity>(action);
  }

  Future<bool> _runAction<T>(
    Future<Either<NetworkFailure, AuthResult<T>>> Function() action, {
    void Function(T data)? onSuccess,
    bool showSuccess = true,
  }) async {
    clearError();
    setLoading(true);

    final result = await action();

    setLoading(false);

    return result.fold(
      (failure) {
        _setInlineError(failure.message);
        return false;
      },
      (success) {
        onSuccess?.call(success.data);
        if (showSuccess && success.message.isNotEmpty) {
          Get.snackbar('Success', success.message);
        }
        return true;
      },
    );
  }

  void _setInlineError(String message) {
    setError(message);
    if (message.isNotEmpty) {
      Get.snackbar('Error', message);
    }
  }
}
