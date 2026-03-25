import 'package:cembostyle/moduls/auth/presentation/routes/auth_routes.dart';
import 'package:cembostyle/moduls/auth/presentation/widgets/auth_widgets.dart';
import 'package:cembostyle/core/common/constants/app_images.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cembostyle/moduls/auth/presentation/controllers/auth_controller.dart';
import 'package:cembostyle/moduls/home/presentation/routes/home_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  final AuthController _authController = Get.find<AuthController>();

  bool get _isValid {
    return _emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _authController.clearError();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            Text('Login to Your Account', style: authTitleStyle()),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _passwordController,
              hintText: 'Password',
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
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  activeColor: AuthColors.purple,
                  onChanged: (value) => setState(() {
                    _rememberMe = value ?? false;
                  }),
                ),
                Text(
                  'Remember me',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AuthColors.textSecondary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Get.toNamed(AuthRoutes.emailVerification),
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AuthColors.purple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => AuthPrimaryButton(
                label: 'Sign in',
                isLoading: _authController.isLoading.value,
                onPressed: _isValid
                    ? () async {
                        await _authController.login(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ).then((success) {
                          if (success) {
                            Get.offAllNamed(HomeRoutes.home);
                          }
                        });
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
