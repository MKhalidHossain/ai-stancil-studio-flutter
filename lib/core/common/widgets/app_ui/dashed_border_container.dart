import 'package:flutter/material.dart';

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color borderColor;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  const DashedBorderContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.borderColor = const Color(0xFFD9C8FF),
    this.strokeWidth = 1.5,
    this.dashLength = 6,
    this.gapLength = 4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        borderRadius: borderRadius,
        borderColor: borderColor,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final double borderRadius;
  final Color borderColor;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  const _DashedBorderPainter({
    required this.borderRadius,
    required this.borderColor,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics().first;
    double distance = 0.0;

    while (distance < metrics.length) {
      final length = dashLength;
      final next = distance + length;
      final extract = metrics.extractPath(distance, next);
      canvas.drawPath(extract, paint);
      distance = next + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
