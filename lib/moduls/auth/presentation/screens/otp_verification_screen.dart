import 'package:cembostyle/moduls/auth/presentation/routes/auth_routes.dart';
import 'package:cembostyle/moduls/auth/presentation/widgets/auth_widgets.dart';
import 'package:cembostyle/core/common/constants/app_images.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:cembostyle/moduls/auth/presentation/controllers/auth_controller.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  String _otp = '';
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _authController.clearError();
    final arg = Get.arguments;
    if (arg is String && arg.trim().isNotEmpty) {
      _authController.setResetEmail(arg.trim());
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Image.asset(AppImages.appLogo, width: 150, height: 130),
            const SizedBox(height: 16),
            Text('OTP Verification', style: authTitleStyle()),
            const SizedBox(height: 20),
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: _otpController,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              cursorColor: AuthColors.purple,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              enableActiveFill: true,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 44,
                fieldWidth: 44,
                activeFillColor: AuthColors.fieldFill,
                inactiveFillColor: AuthColors.fieldFill,
                selectedFillColor: AuthColors.fieldFill,
                activeColor: AuthColors.purple,
                selectedColor: AuthColors.purple,
                inactiveColor: AuthColors.border,
              ),
              onChanged: (value) => setState(() {
                _otp = value;
              }),
            ),
            const SizedBox(height: 16),
            Obx(
              () => AuthPrimaryButton(
                label: 'Verify Now',
                isLoading: _authController.isLoading.value,
                onPressed: _otp.length == 6
                    ? () async {
                        final success = await _authController.verifyOtp(
                          otp: _otp,
                        );
                        if (success) {
                          Get.toNamed(AuthRoutes.resetPassword);
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent,
                  ),
                ),
              );
            }),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
