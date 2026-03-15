import 'package:cembostyle/auth/presentation/screens/splash_screen.dart';
import 'package:cembostyle/auth/presentation/screens/welcome_screen.dart';
import 'package:cembostyle/core/init/app_initializer.dart';
import 'package:cembostyle/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppInitializer.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bheppo',
      theme: AppTheme.light,
      home: SplashScreen(),
    );
  }
}
