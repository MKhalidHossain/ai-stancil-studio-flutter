import 'package:get/get.dart';

import '../screens/welcome_screen.dart';

class SplashController extends GetxController{
  @override
  void onInit(){
    super.onInit();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async{
    await Future.delayed(Duration(seconds: 2));
    Get.off(() => WelcomeScreen());
  }
}