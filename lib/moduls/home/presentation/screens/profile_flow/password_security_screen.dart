import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/constants/app_images.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/moduls/auth/presentation/controllers/auth_controller.dart';
import 'package:cembostyle/moduls/home/controllers/home_controller.dart';
import 'package:cembostyle/moduls/home/presentation/routes/home_routes.dart';

class PasswordSecurityScreen extends StatefulWidget {
  const PasswordSecurityScreen({super.key});

  @override
  State<PasswordSecurityScreen> createState() => _PasswordSecurityScreenState();
}

class _PasswordSecurityScreenState extends State<PasswordSecurityScreen> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _isValid {
    final current = _currentController.text.trim();
    final next = _newController.text.trim();
    final confirm = _confirmController.text.trim();
    return current.isNotEmpty &&
        next.length >= 6 &&
        confirm.isNotEmpty &&
        next == confirm;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: AppPalette.textPrimary,
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Password and security',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppPalette.textPrimary,
          ),
        ),
      ),
      body: Obx(() {
        final isSubmitting = controller.isLoading.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            children: [
              _PasswordField(
                controller: _currentController,
                hint: 'Current Password',
                obscureText: _hideCurrent,
                onToggle: () => setState(() => _hideCurrent = !_hideCurrent),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              _PasswordField(
                controller: _newController,
                hint: 'New Password',
                obscureText: _hideNew,
                onToggle: () => setState(() => _hideNew = !_hideNew),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              _PasswordField(
                controller: _confirmController,
                hint: 'Confirm Password',
                obscureText: _hideConfirm,
                onToggle: () => setState(() => _hideConfirm = !_hideConfirm),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: !_isValid || isSubmitting
                      ? null
                      : () async {
                          final success = await controller.changePassword(
                            currentPassword: _currentController.text.trim(),
                            newPassword: _newController.text.trim(),
                          );

                          if (!success || !mounted) {
                            return;
                          }

                          _currentController.clear();
                          _newController.clear();
                          _confirmController.clear();
                          setState(() {});
                          await _showSuccessDialog();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.purple,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD0D0D0),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _showSuccessDialog() async {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppImages.success,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Successful!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.purple,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your Password is Changed Successfully.\nNow You Can be redirected to the Home\npage in a few seconds..',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: AppPalette.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 22),
                const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: AppPalette.purple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    await Future<void>.delayed(const Duration(seconds: 2));

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    if (!mounted) {
      return;
    }

    final homeController = Get.find<HomeController>();
    homeController.setBottomNav(0);
    Get.offAllNamed(HomeRoutes.home);
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final VoidCallback onToggle;
  final ValueChanged<String> onChanged;

  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.obscureText,
    required this.onToggle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 12,
          color: AppPalette.textMuted,
        ),
        prefixIcon: const Icon(
          Icons.lock_rounded,
          size: 18,
          color: AppPalette.textSecondary,
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            size: 18,
            color: AppPalette.textSecondary,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppPalette.purple),
        ),
      ),
    );
  }
}
