import 'package:cembostyle/core/common/constants/app_images.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/core/network/services/auth_storage_service.dart';
import 'package:cembostyle/core/network/utils/jwt_utils.dart';
import 'package:cembostyle/moduls/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/moduls/auth/presentation/routes/auth_routes.dart';
import 'package:cembostyle/moduls/home/presentation/routes/home_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthStorageService _authStorageService;
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authStorageService = Get.find<AuthStorageService>();
    _authRepository = Get.find<AuthRepository>();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final accessToken = await _authStorageService.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      _goToLogin();
      return;
    }

    final isExpired = JwtUtils.isTokenExpired(accessToken);
    if (!isExpired) {
      _goToHome();
      return;
    }

    final refreshToken = await _authStorageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _authStorageService.clearAuthData();
      if (!mounted) return;
      _goToLogin();
      return;
    }

    final refreshResult = await _authRepository.refreshToken();
    final refreshed = refreshResult.fold((_) => false, (success) {
      return success.data.accessToken.isNotEmpty;
    });

    if (!mounted) return;

    if (refreshed) {
      _goToHome();
    } else {
      await _authStorageService.clearAuthData();
      if (!mounted) return;
      _goToLogin();
    }
  }

  void _goToHome() {
    Get.offAllNamed(HomeRoutes.home);
  }

  void _goToLogin() {
    Get.offAllNamed(AuthRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      body: Center(
        child: Image.asset(AppImages.appLogo, width: 193, height: 167),
      ),
    );
  }
}
