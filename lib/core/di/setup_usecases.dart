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
  Get.lazyPut(() => LoginUseCase(Get.find()));
  Get.lazyPut(() => SignupUseCase(Get.find()));
  Get.lazyPut(() => ForgotPasswordUseCase(Get.find()));
  Get.lazyPut(() => VerifyOtpUseCase(Get.find()));
  Get.lazyPut(() => ResetPasswordUseCase(Get.find()));
  Get.lazyPut(() => RefreshTokenUseCase(Get.find()));
  Get.lazyPut(() => ChangePasswordUseCase(Get.find()));
  Get.lazyPut(() => LogoutUseCase(Get.find()));
}
