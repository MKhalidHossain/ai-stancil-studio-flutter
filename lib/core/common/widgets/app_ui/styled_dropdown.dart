import 'package:flutter/material.dart';

import 'package:cembostyle/core/theme/app_palette.dart';

class StyledDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const StyledDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppPalette.textSecondary, width: 0.8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          isDense: true,
          borderRadius: BorderRadius.circular(16),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          style: const TextStyle(
            fontSize: 13,
            color: AppPalette.textPrimary,
          ),
        ),
      ),
    );
  }
}
