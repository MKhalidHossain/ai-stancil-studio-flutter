import 'package:flutter/material.dart';

import 'package:cembostyle/core/theme/app_palette.dart';

class HomeOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double height;
  final double? width;
  final Widget? icon;
  final double radius;
  final Color? borderColor;
  final Color? fillColor;
  final Color? foregroundColor;

  const HomeOutlineButton({
    super.key,
    required this.text,
    this.onTap,
    this.height = 44,
    this.width,
    this.icon,
    this.radius = 24,
    this.borderColor,
    this.fillColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? AppPalette.purple,
          backgroundColor: fillColor ?? Colors.transparent,
          side: BorderSide(color: borderColor ?? AppPalette.purple),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 8)],
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
