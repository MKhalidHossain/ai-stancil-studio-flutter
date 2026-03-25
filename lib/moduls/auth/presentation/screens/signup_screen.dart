import 'package:cembostyle/moduls/auth/presentation/routes/auth_routes.dart';
import 'package:cembostyle/moduls/auth/presentation/widgets/auth_widgets.dart';
import 'package:cembostyle/core/common/constants/app_images.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cembostyle/moduls/auth/presentation/controllers/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _acceptedTerms = false;
  bool _obscurePassword = true;
  final AuthController _authController = Get.find<AuthController>();

  bool get _isValid {
    return _acceptedTerms &&
        _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _authController.clearError();
  }

  @override
  void dispose() {
    _nameController.dispose();
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
            Text('Create New Account', style: authTitleStyle()),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _nameController,
              hintText: 'Name',
              prefixIcon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
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
                  value: _acceptedTerms,
                  activeColor: AuthColors.purple,
                  onChanged: (value) => setState(() {
                    _acceptedTerms = value ?? false;
                  }),
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'I accept the ',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AuthColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'terms & services',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AuthColors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => AuthPrimaryButton(
                label: 'Sign up',
                isLoading: _authController.isLoading.value,
                onPressed: _isValid
                    ? () async {
                        final success = await _authController.signup(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                        if (success) {
                          Get.offNamed(AuthRoutes.login);
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
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Get.offNamed(AuthRoutes.login),
              child: Text.rich(
                TextSpan(
                  text: 'Already Have an Account? ',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AuthColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AuthColors.purple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
