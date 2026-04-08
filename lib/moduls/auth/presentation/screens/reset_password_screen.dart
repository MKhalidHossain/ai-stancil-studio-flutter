import 'package:cembostyle/moduls/auth/presentation/widgets/auth_widgets.dart';
import 'package:cembostyle/core/common/constants/app_images.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/moduls/home/controllers/home_controller.dart';
import 'package:cembostyle/moduls/home/presentation/routes/home_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cembostyle/moduls/auth/presentation/controllers/auth_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isSubmitting = false;

  bool get _isValid {
    return _passwordController.text.trim().isNotEmpty &&
        _confirmController.text.trim().isNotEmpty &&
        _passwordController.text.trim() == _confirmController.text.trim();
  }

  @override
  void initState() {
    super.initState();
    _authController.clearError();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _showSuccessDialog() async {
    setState(() {
      _isSubmitting = true;
    });

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _PasswordResetSuccessDialog(),
    );

    if (!mounted) return;
    Get.find<HomeController>().setBottomNav(0);
    Get.offAllNamed(HomeRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        leading: const AuthBackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Image.asset(AppImages.appLogo, width: 150, height: 130),
            const SizedBox(height: 16),
            Text('Reset Password', style: authTitleStyle()),
            const SizedBox(height: 8),
            Text(
              'Enter your new password and confirm password',
              style: authSubtitleStyle(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _passwordController,
              hintText: 'Create Password',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
              onChanged: (_) => setState(() {}),
              suffix: IconButton(
                onPressed: () => setState(() {
                  _obscurePassword = !_obscurePassword;
                }),
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AuthColors.fieldIcon,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _confirmController,
              hintText: 'Confirm Password',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureConfirm,
              onChanged: (_) => setState(() {}),
              suffix: IconButton(
                onPressed: () => setState(() {
                  _obscureConfirm = !_obscureConfirm;
                }),
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: AuthColors.fieldIcon,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => AuthPrimaryButton(
                label: 'Continue',
                isLoading: _authController.isLoading.value,
                onPressed: _isValid &&
                        !_isSubmitting &&
                        !_authController.isLoading.value
                    ? () async {
                        final success = await _authController.resetPassword(
                          newPassword: _passwordController.text.trim(),
                        );
                        if (success) {
                          _showSuccessDialog();
                        }
                      }
                    : null,
              ),
            ),
            Obx(() {
              final message = _authController.errorMessage.value;
              if (message.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.redAccent,
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PasswordResetSuccessDialog extends StatefulWidget {
  const _PasswordResetSuccessDialog();

  @override
  State<_PasswordResetSuccessDialog> createState() =>
      _PasswordResetSuccessDialogState();
}

class _PasswordResetSuccessDialogState
    extends State<_PasswordResetSuccessDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
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
            Text(
              'Successful!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AuthColors.purple,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your account is ready to use. Your will\nbe redirected to the Home page in a\nfew seconds..',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                height: 1.45,
                color: AuthColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 22),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: AuthColors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
