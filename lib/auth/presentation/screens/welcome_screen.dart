import 'package:cembostyle/core/common/widgets/button_widgets.dart';
import 'package:flutter/material.dart';

import '../../../core/common/widgets/app_scaffold.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/logo.png', width: 193, height: 167,),
            const SizedBox(height: 16,),
            Text('Welcome to Bheppo Stencil app', 
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),),
            Spacer(),
            PrimaryButton(text: 'Create an Account',),
            const SizedBox(height: 16,),
            SecondaryButton(text: 'Sign in'),
          ],
        ),
      ),
    );
  }
}
