import 'package:get/get.dart';

import '../../moduls/auth/presentation/controllers/auth_controller.dart';
import '../../moduls/home/controllers/home_controller.dart';
import '../../moduls/stencil/controllers/stencil_controller.dart';

void setupControllers() {
  Get.put<AuthController>(
    AuthController(
      loginUseCase: Get.find(),
      signupUseCase: Get.find(),
      forgotPasswordUseCase: Get.find(),
      verifyOtpUseCase: Get.find(),
      resetPasswordUseCase: Get.find(),
      refreshTokenUseCase: Get.find(),
      changePasswordUseCase: Get.find(),
      logoutUseCase: Get.find(),
    ),
  );

  Get.put<HomeController>(HomeController());
  Get.put<StencilController>(StencilController());
}
