import 'package:flutter/material.dart';

import 'package:cembostyle/core/theme/app_palette.dart';

class GeneratingDialog extends StatelessWidget {
  const GeneratingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppPalette.purpleSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified,
                size: 36,
                color: AppPalette.purple,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Generating Your Stencil!',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppPalette.purple,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'AI is processing your image this usually takes a few seconds.',
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
