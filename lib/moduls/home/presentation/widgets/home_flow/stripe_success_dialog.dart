import 'package:flutter/material.dart';

import 'package:cembostyle/core/theme/app_palette.dart';

class StripeSuccessDialog extends StatelessWidget {
  const StripeSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppPalette.purple,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield, size: 44, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Stripe Payment Added\nSuccessfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppPalette.purple,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your 3 day free trial started now you will be redirected to the Home page in a few seconds.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppPalette.textSecondary),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(color: AppPalette.purple),
          ],
        ),
      ),
    );
  }
}
