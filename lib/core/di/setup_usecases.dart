import 'package:get/get.dart';

import '../../moduls/auth/domain/usecases/change_password_usecase.dart';
import '../../moduls/auth/domain/usecases/forgot_password_usecase.dart';
import '../../moduls/auth/domain/usecases/login_usecase.dart';
import '../../moduls/auth/domain/usecases/logout_usecase.dart';
import '../../moduls/auth/domain/usecases/refresh_token_usecase.dart';
import '../../moduls/auth/domain/usecases/reset_password_usecase.dart';
import '../../moduls/auth/domain/usecases/signup_usecase.dart';
import '../../moduls/auth/domain/usecases/verify_otp_usecase.dart';

void setupUsecases() {
  Get.put(LoginUseCase(Get.find()));
  Get.put(SignupUseCase(Get.find()));
  Get.put(ForgotPasswordUseCase(Get.find()));
  Get.put(VerifyOtpUseCase(Get.find()));
  Get.put(ResetPasswordUseCase(Get.find()));
  Get.put(RefreshTokenUseCase(Get.find()));
  Get.put(ChangePasswordUseCase(Get.find()));
  Get.put(LogoutUseCase(Get.find()));
}
