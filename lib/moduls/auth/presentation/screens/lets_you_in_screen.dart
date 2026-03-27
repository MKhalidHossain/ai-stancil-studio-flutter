import 'package:cembostyle/moduls/auth/presentation/routes/auth_routes.dart';
import 'package:cembostyle/moduls/auth/presentation/widgets/auth_widgets.dart';
import 'package:cembostyle/core/common/constants/app_images.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LetsYouInScreen extends StatelessWidget {
  const LetsYouInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 90),
            Image.asset(AppImages.appLogo, width: 150, height: 130),
            const SizedBox(height: 18),
            Text(
              'Welcome to Bheppo Stencil app',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AuthColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const Spacer(),
            AuthPrimaryButton(
              label: 'Create an Account',
              onPressed: () => Get.toNamed(AuthRoutes.signup),
            ),
            const SizedBox(height: 12),
            AuthOutlineButton(
              label: 'Sign in',
              onPressed: () => Get.toNamed(AuthRoutes.login),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
