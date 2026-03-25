import 'package:flutter/material.dart';

import 'package:cembostyle/core/theme/app_palette.dart';

class HomePrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double height;
  final double? width;
  final Widget? icon;
  final double radius;

  const HomePrimaryButton({
    super.key,
    required this.text,
    this.onTap,
    this.height = 48,
    this.width,
    this.icon,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.purple,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 8)],
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
