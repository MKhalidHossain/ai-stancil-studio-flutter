import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/constants/app_images.dart';
import 'package:cembostyle/core/network/services/auth_storage_service.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/moduls/auth/presentation/controllers/auth_controller.dart';
import 'package:cembostyle/moduls/auth/presentation/routes/auth_routes.dart';
import 'package:cembostyle/moduls/home/controllers/home_controller.dart';
import 'package:cembostyle/moduls/home/presentation/routes/home_routes.dart';
import 'package:cembostyle/moduls/stencil/controllers/stencil_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final authController = Get.find<AuthController>();
    final stencilController = Get.find<StencilController>();
    homeController.ensureLoaded();
    stencilController.ensureLoaded();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: homeController.refreshDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Obx(() {
            final profile = homeController.profile.value;
            final stencilCount = stencilController.recentActivities.length;

            return Column(
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
                const SizedBox(height: 18),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppPalette.purpleSoft,
                      backgroundImage: profile != null &&
                              profile.profileImageUrl.isNotEmpty
                          ? NetworkImage(profile.profileImageUrl)
                          : null,
                      child: profile == null || profile.profileImageUrl.isEmpty
                          ? Text(
                              profile?.initials ?? 'CS',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppPalette.purple,
                                fontSize: 12,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.name.isNotEmpty == true
                                ? profile!.name
                                : 'Cembostyle User',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            homeController.profileError.value.isNotEmpty
                                ? homeController.profileError.value
                                : 'Good morning!',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppPalette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _ProfileMenuTile(
                  icon: Icons.person_rounded,
                  label: 'My profile',
                  onTap: () => Get.toNamed(HomeRoutes.myProfile),
                ),
                const SizedBox(height: 8),
                _ProfileMenuTile(
                  icon: Icons.folder_copy_rounded,
                  label: 'My Stencils',
                  badge: stencilCount.toString().padLeft(2, '0'),
                  onTap: () => Get.toNamed(HomeRoutes.myStencils),
                ),
                const SizedBox(height: 8),
                _ProfileMenuTile(
                  icon: Icons.workspace_premium_rounded,
                  label: 'Pricing plan',
                  onTap: () => Get.toNamed(HomeRoutes.pricing),
                ),
                const SizedBox(height: 8),
                _ProfileMenuTile(
                  icon: Icons.lock_rounded,
                  label: 'Password and security',
                  onTap: () => Get.toNamed(HomeRoutes.passwordSecurity),
                ),
                const SizedBox(height: 8),
                _ProfileMenuTile(
                  icon: Icons.privacy_tip_rounded,
                  label: 'Privacy & Legal',
                  onTap: () => Get.toNamed(HomeRoutes.privacyLegal),
                ),
                const SizedBox(height: 8),
                _ProfileMenuTile(
                  icon: Icons.description_rounded,
                  label: 'Terms and services',
                  onTap: () => Get.toNamed(HomeRoutes.termsServices),
                ),
                const SizedBox(height: 8),
                _ProfileMenuTile(
                  icon: Icons.logout_rounded,
                  label: 'Log out',
                  iconColor: const Color(0xFFE53935),
                  labelColor: const Color(0xFFE53935),
                  onTap: () => _showLogoutDialog(authController),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

Future<void> _showLogoutDialog(AuthController authController) async {
  await Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.logOut,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            const Text(
              'Are you sure?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppPalette.purple,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Want to sign out from the application',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppPalette.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppPalette.purple,
                      side: const BorderSide(color: AppPalette.purple),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final success = await authController.logout();
                      if (!success) {
                        await Get.find<AuthStorageService>().clearAuthData();
                      }
                      Get.offAllNamed(AuthRoutes.login);
                    },
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text(
                      'Logout',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final Color iconColor;
  final Color labelColor;
  final VoidCallback onTap;

  const _ProfileMenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
    this.iconColor = AppPalette.purple,
    this.labelColor = AppPalette.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppPalette.cardBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: labelColor,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.purpleSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.purple,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
