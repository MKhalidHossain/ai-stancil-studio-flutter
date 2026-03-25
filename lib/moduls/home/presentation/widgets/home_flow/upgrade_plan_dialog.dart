import 'package:flutter/material.dart';

import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_primary_button.dart';

class UpgradePlanDialog extends StatelessWidget {
  final VoidCallback onUpgrade;

  const UpgradePlanDialog({super.key, required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, size: 20),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose the package\nwhich suits you best.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppPalette.purple,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              r'Your monthly subscription begins after 3 days. Cancel anytime before trial ends, no charges. After trial: $9.99/month',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppPalette.textSecondary),
            ),
            const SizedBox(height: 16),
            HomePrimaryButton(
              text: 'Upgrade Plan',
              onTap: () {
                Navigator.of(context).pop();
                onUpgrade();
              },
            ),
          ],
        ),
      ),
    );
  }
}
