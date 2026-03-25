import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/moduls/home/controllers/home_controller.dart';
import 'package:cembostyle/core/theme/app_palette.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Container(
          height: 70,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppPalette.cardBorder, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Obx(() {
            return Row(
              children: [
                Expanded(
                  child: _BottomNavItem(
                    label: 'Home',
                    icon: Icons.home_outlined,
                    isSelected: controller.bottomNavIndex.value == 0,
                    onTap: () => controller.setBottomNav(0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _BottomNavItem(
                    label: 'Stencil',
                    icon: Icons.auto_awesome_outlined,
                    isSelected: controller.bottomNavIndex.value == 1,
                    onTap: () => controller.setBottomNav(1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _BottomNavItem(
                    label: 'Profile',
                    icon: Icons.person_outline,
                    isSelected: controller.bottomNavIndex.value == 2,
                    onTap: () => controller.setBottomNav(2),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppPalette.purple : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : AppPalette.textSecondary,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                height: 1,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppPalette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
