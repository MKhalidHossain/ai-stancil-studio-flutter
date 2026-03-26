
import 'package:get/get.dart';

import '../../moduls/auth/data/datasources/auth_remote_data_source.dart';
import '../../moduls/auth/data/repositories/auth_repository_impl.dart';
import '../../moduls/auth/domain/repositories/auth_repository.dart';
import '../network/api_client.dart';
import '../network/services/auth_storage_service.dart';

void setupRepository() {
  Get.put<AuthRemoteDataSource>(
    AuthRemoteDataSource(apiClient: Get.find<ApiClient>()),
  );
  Get.put<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: Get.find<AuthRemoteDataSource>(),
      authStorageService: Get.find<AuthStorageService>(),
    ),
  );
}
