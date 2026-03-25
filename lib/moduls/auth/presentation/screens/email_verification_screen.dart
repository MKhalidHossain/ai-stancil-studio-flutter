import 'package:cembostyle/moduls/auth/presentation/routes/auth_routes.dart';
import 'package:cembostyle/moduls/auth/presentation/widgets/auth_widgets.dart';
import 'package:cembostyle/core/common/constants/app_images.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cembostyle/moduls/auth/presentation/controllers/auth_controller.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  bool get _isValid => _emailController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _authController.clearError();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
            Text('Email Verification', style: authTitleStyle()),
            const SizedBox(height: 6),
            Text(
              'Enter your email to receive the OTP',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AuthColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _emailController,
              hintText: 'Enter Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Obx(
              () => AuthPrimaryButton(
                label: 'Continue',
                isLoading: _authController.isLoading.value,
                onPressed: _isValid
                    ? () async {
                        final success = await _authController
                            .requestPasswordResetOtp(
                          email: _emailController.text.trim(),
                        );
                        if (success) {
                          Get.toNamed(AuthRoutes.otp);
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
