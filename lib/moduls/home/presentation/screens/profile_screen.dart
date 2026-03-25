import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/network/services/auth_storage_service.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/moduls/auth/presentation/routes/auth_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppPalette.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await AuthStorageService().clearAuthData();
                  Get.offAllNamed(AuthRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
