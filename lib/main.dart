import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:cembostyle/core/di/service_locator.dart';
import 'package:cembostyle/moduls/auth/presentation/routes/auth_routes.dart';
import 'package:cembostyle/moduls/auth/presentation/screens/email_verification_screen.dart';
import 'package:cembostyle/moduls/auth/presentation/screens/lets_you_in_screen.dart';
import 'package:cembostyle/moduls/auth/presentation/screens/login_screen.dart';
import 'package:cembostyle/moduls/auth/presentation/screens/otp_verification_screen.dart';
import 'package:cembostyle/moduls/auth/presentation/screens/reset_password_screen.dart';
import 'package:cembostyle/moduls/auth/presentation/screens/signup_screen.dart';
import 'package:cembostyle/moduls/auth/presentation/screens/splash_screen.dart';
import 'package:cembostyle/moduls/home/presentation/routes/home_routes.dart';
import 'package:cembostyle/moduls/home/presentation/screens/home_flow/details_screen.dart';
import 'package:cembostyle/moduls/home/presentation/screens/home_flow/gallery_screen.dart';
import 'package:cembostyle/moduls/home/presentation/screens/home_flow/my_stencils_screen.dart';
import 'package:cembostyle/moduls/home/presentation/screens/home_flow/payment_method_screen.dart';
import 'package:cembostyle/moduls/home/presentation/screens/home_flow/pricing_plan_screen.dart';
import 'package:cembostyle/moduls/home/presentation/screens/home_shell_screen.dart';
import 'package:cembostyle/moduls/stencil/presentation/routes/stencil_routes.dart';
import 'package:cembostyle/moduls/stencil/presentation/screens/customize_style_screen.dart';
import 'package:cembostyle/moduls/stencil/presentation/screens/stencil_result_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: false,
      ),
      initialRoute: AuthRoutes.splash,
      getPages: [
        GetPage(name: AuthRoutes.splash, page: () => const SplashScreen()),
        GetPage(name: AuthRoutes.welcome, page: () => const LetsYouInScreen()),
        GetPage(name: AuthRoutes.signup, page: () => const SignUpScreen()),
        GetPage(name: AuthRoutes.login, page: () => const LoginScreen()),
        GetPage(
          name: AuthRoutes.emailVerification,
          page: () => const EmailVerificationScreen(),
        ),
        GetPage(
          name: AuthRoutes.otp,
          page: () => const OtpVerificationScreen(),
        ),
        GetPage(
          name: AuthRoutes.resetPassword,
          page: () => const ResetPasswordScreen(),
        ),
        GetPage(name: HomeRoutes.home, page: () => const HomeShellScreen()),
        GetPage(name: HomeRoutes.gallery, page: () => const GalleryScreen()),
        GetPage(name: HomeRoutes.details, page: () => const DetailsScreen()),
        GetPage(
          name: HomeRoutes.myStencils,
          page: () => const MyStencilsScreen(),
        ),
        GetPage(
          name: HomeRoutes.pricing,
          page: () => const PricingPlanScreen(),
        ),
        GetPage(
          name: HomeRoutes.payment,
          page: () => const PaymentMethodScreen(),
        ),
        GetPage(
          name: StencilRoutes.customizeStyle,
          page: () => const CustomizeStyleScreen(),
        ),
        GetPage(
          name: StencilRoutes.stencilResult,
          page: () => const StencilResultScreen(),
        ),
      ],
    );
  }
}
