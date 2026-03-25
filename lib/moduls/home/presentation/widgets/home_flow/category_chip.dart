import 'package:flutter/material.dart';

import 'package:cembostyle/core/theme/app_palette.dart';

class CategoryChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.text,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppPalette.purple : AppPalette.cardBorder,
            width: isSelected ? 1.2 : 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppPalette.purple : AppPalette.textSecondary,
          ),
        ),
      ),
    );
  }
}
