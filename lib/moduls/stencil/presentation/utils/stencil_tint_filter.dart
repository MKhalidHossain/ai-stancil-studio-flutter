import 'package:flutter/material.dart';

import 'package:cembostyle/moduls/stencil/models/stencil_models.dart';

ColorFilter? buildAdjustmentColorFilter({
  required double brightness,
  required double contrast,
}) {
  final safeBrightness = brightness.clamp(0.0, 2.0);
  final safeContrast = contrast.clamp(0.0, 2.0);
  final scale = safeBrightness * safeContrast;
  final offset = 127.5 * (1 - safeContrast);

  return ColorFilter.matrix([
    scale,
    0,
    0,
    0,
    offset,
    0,
    scale,
    0,
    0,
    offset,
    0,
    0,
    scale,
    0,
    offset,
    0,
    0,
    0,
    1,
    0,
  ]);
}

ColorFilter? buildLocalTintColorFilter(ColorThemeOption? theme) {
  if (theme == null || !theme.isLocalTintEligible) {
    return null;
  }

  final color = theme.accentColor;
  final red = (color.r * 255.0).round().clamp(0, 255);
  final green = (color.g * 255.0).round().clamp(0, 255);
  final blue = (color.b * 255.0).round().clamp(0, 255);
  final r = red / 255.0;
  final g = green / 255.0;
  final b = blue / 255.0;
  const lumR = 0.2126;
  const lumG = 0.7152;
  const lumB = 0.0722;

  return ColorFilter.matrix([
    lumR * (1 - r),
    lumG * (1 - r),
    lumB * (1 - r),
    0,
    red.toDouble(),
    lumR * (1 - g),
    lumG * (1 - g),
    lumB * (1 - g),
    0,
    green.toDouble(),
    lumR * (1 - b),
    lumG * (1 - b),
    lumB * (1 - b),
    0,
    blue.toDouble(),
    0,
    0,
    0,
    1,
    0,
  ]);
}
