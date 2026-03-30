import 'package:flutter/material.dart';

import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/moduls/stencil/models/stencil_models.dart';

class ColorThemeSelector extends StatelessWidget {
  final List<ColorThemeOption> themes;
  final String selectedThemeId;
  final ValueChanged<ColorThemeOption> onSelected;

  const ColorThemeSelector({
    super.key,
    required this.themes,
    required this.selectedThemeId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final selectedTheme = themes.firstWhere(
      (theme) => theme.id == selectedThemeId,
      orElse: () => themes.first,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppPalette.textSecondary, width: 0.8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ColorThemeOption>(
          value: selectedTheme,
          isExpanded: true,
          borderRadius: BorderRadius.circular(16),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: AppPalette.textPrimary,
          ),
          selectedItemBuilder: (context) {
            return themes
                .map(
                  (theme) => Align(
                    alignment: Alignment.centerLeft,
                    child: _ThemeOptionRow(theme: theme),
                  ),
                )
                .toList();
          },
          items: themes
              .map(
                (theme) => DropdownMenuItem<ColorThemeOption>(
                  value: theme,
                  child: _ThemeOptionRow(theme: theme),
                ),
              )
              .toList(),
          onChanged: (theme) {
            if (theme != null) {
              onSelected(theme);
            }
          },
        ),
      ),
    );
  }
}

class _ThemeOptionRow extends StatelessWidget {
  final ColorThemeOption theme;

  const _ThemeOptionRow({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: theme.accentColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            theme.title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppPalette.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
