import 'package:flutter/material.dart';

import 'package:cembostyle/core/theme/app_palette.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final String? value;
  final IconData? icon;
  final VoidCallback? onTap;

  const QuickActionCard({
    super.key,
    required this.title,
    this.value,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    final content = Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.cardBorder, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasValue)
            Text(
              value!,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: AppPalette.purple,
              ),
            )
          else if (icon != null)
            Icon(icon, color: AppPalette.purple, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppPalette.purple,
            ),
          ),
        ],
      ),
    );
    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }
}
