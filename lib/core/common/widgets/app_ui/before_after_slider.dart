import 'package:flutter/material.dart';

import 'package:cembostyle/core/common/widgets/app_cached_image.dart';
import 'package:cembostyle/core/theme/app_palette.dart';

class BeforeAfterSlider extends StatelessWidget {
  final String beforeImage;
  final String afterImage;
  final double value;
  final ValueChanged<double> onChanged;

  const BeforeAfterSlider({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final sliderX = width * value;
        const radius = 8.0;

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final newValue = (details.localPosition.dx / width).clamp(
              0.05,
              0.95,
            );
            onChanged(newValue);
          },
          onTapDown: (details) {
            final newValue = (details.localPosition.dx / width).clamp(
              0.05,
              0.95,
            );
            onChanged(newValue);
          },
          child: Stack(
            children: [
              AppCachedImage(
                imageUrl: afterImage,
                width: width,
                height: height,
                borderRadius: BorderRadius.circular(radius),
                onTap: () {},
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: AppCachedImage(
                    imageUrl: beforeImage,
                    width: width,
                    height: height,
                    borderRadius: BorderRadius.circular(radius),
                    onTap: () {},
                  ),
                ),
              ),
              Positioned(
                left: sliderX - 1,
                top: 10,
                bottom: 10,
                child: Container(width: 2, color: AppPalette.purple),
              ),
              Positioned(
                left: sliderX - 14,
                top: height / 2 - 14,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppPalette.purple, width: 1.4),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    size: 20,
                    color: AppPalette.purple,
                  ),
                ),
              ),
              IgnorePointer(
                child: CustomPaint(
                  size: Size(width, height),
                  painter: _CornerBracketPainter(
                    color: AppPalette.purple,
                    strokeWidth: 2,
                    cornerLength: 22,
                    inset: 6,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;
  final double inset;

  const _CornerBracketPainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
    required this.inset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final left = inset;
    final top = inset;
    final right = size.width - inset;
    final bottom = size.height - inset;

    // Top-left
    canvas.drawLine(Offset(left, top + cornerLength), Offset(left, top), paint);
    canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), paint);
    // Top-right
    canvas.drawLine(
      Offset(right - cornerLength, top),
      Offset(right, top),
      paint,
    );
    canvas.drawLine(
      Offset(right, top),
      Offset(right, top + cornerLength),
      paint,
    );
    // Bottom-left
    canvas.drawLine(
      Offset(left, bottom - cornerLength),
      Offset(left, bottom),
      paint,
    );
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left + cornerLength, bottom),
      paint,
    );
    // Bottom-right
    canvas.drawLine(
      Offset(right - cornerLength, bottom),
      Offset(right, bottom),
      paint,
    );
    canvas.drawLine(
      Offset(right, bottom),
      Offset(right, bottom - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerBracketPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.cornerLength != cornerLength ||
        oldDelegate.inset != inset;
  }
}
