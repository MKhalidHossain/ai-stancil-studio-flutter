import 'package:flutter/material.dart';

import 'package:cembostyle/core/theme/app_palette.dart';

class DetailLevelSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const DetailLevelSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const trackHeight = 2.0;
    const thumbRadius = 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final usableWidth = (width - (thumbRadius * 2)).clamp(0, width);
            final positions = [
              thumbRadius,
              thumbRadius + (usableWidth / 2),
              width - thumbRadius,
            ];
            final clampedValue = value.clamp(0, 2);
            final thumbX = positions[clampedValue];

            return GestureDetector(
              onTapDown: (details) {
                final dx = details.localPosition.dx.clamp(0.0, width);
                final nearest = _nearestIndex(dx, positions);
                onChanged(nearest);
              },
              onHorizontalDragUpdate: (details) {
                final dx = details.localPosition.dx.clamp(0.0, width);
                final nearest = _nearestIndex(dx, positions);
                onChanged(nearest);
              },
              child: SizedBox(
                height: 36,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Positioned(
                      left: thumbRadius,
                      right: thumbRadius,
                      child: Container(
                        height: trackHeight,
                        color: AppPalette.textPrimary,
                      ),
                    ),
                    Positioned(
                      left: thumbX - thumbRadius,
                      child: Container(
                        width: thumbRadius * 2,
                        height: thumbRadius * 2,
                        decoration: const BoxDecoration(
                          color: AppPalette.purple,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _LevelLabel(
              text: 'Simple',
              onTap: () => onChanged(0),
            ),
            _LevelLabel(
              text: 'Basic',
              onTap: () => onChanged(1),
            ),
            _LevelLabel(
              text: 'Sketch',
              onTap: () => onChanged(2),
            ),
          ],
        ),
      ],
    );
  }

  static int _nearestIndex(double dx, List<double> positions) {
    var nearestIndex = 0;
    var nearestDistance = (dx - positions[0]).abs();
    for (var i = 1; i < positions.length; i++) {
      final distance = (dx - positions[i]).abs();
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestIndex = i;
      }
    }
    return nearestIndex;
  }
}

class _LevelLabel extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _LevelLabel({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: AppPalette.textSecondary,
        ),
      ),
    );
  }
}
