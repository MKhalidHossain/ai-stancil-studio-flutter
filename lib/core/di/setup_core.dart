import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';

import '../base/base_controller.dart';
import '../network/api_client.dart';
import '../network/services/auth_storage_service.dart';

void setupCore() {
  DPrint.info("setupCore");
  Get.put(BaseController());
  Get.lazyPut(() => ApiClient(), fenix: true);
  Get.lazyPut(() => AuthStorageService());

  // Get.getOrPutLazy(() => AuthenticateCheckService(Get.find(), Get.find()));
}
