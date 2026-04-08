import 'package:flutter/material.dart';

enum ThemeRenderMode {
  localTint('local_tint'),
  gemini('gemini');

  const ThemeRenderMode(this.apiValue);

  final String apiValue;

  static ThemeRenderMode fromApi(String? value) {
    switch (value) {
      case 'local_tint':
        return ThemeRenderMode.localTint;
      case 'gemini':
      default:
        return ThemeRenderMode.gemini;
    }
  }
}

class StencilStyleOption {
  final String id;
  final String title;
  final String subtitle;

  const StencilStyleOption({
    required this.id,
    required this.title,
    required this.subtitle,
  });
}

class ColorThemeOption {
  final String id;
  final String title;
  final int accentColorValue;
  final ThemeRenderMode renderMode;

  const ColorThemeOption({
    required this.id,
    required this.title,
    required this.accentColorValue,
    required this.renderMode,
  });

  Color get accentColor => Color(accentColorValue);
  bool get isLocalTintEligible => renderMode == ThemeRenderMode.localTint;
  String get badgeLabel => isLocalTintEligible ? 'Instant' : 'AI';
}

class StencilActivityItem {
  final String id;
  final String title;
  final String style;
  final String date;
  final String thumbnailUrl;
  final String styleName;
  final String originalImageUrl;
  final String stencilImageUrl;
  final String baseStencilImageUrl;
  final String status;
  final String errorMessage;
  final String colorTheme;
  final String colorThemeId;
  final ThemeRenderMode themeRenderMode;
  final int detailLevel;
  final bool isSaved;

  const StencilActivityItem({
    required this.id,
    required this.title,
    required this.style,
    required this.date,
    required this.thumbnailUrl,
    this.styleName = '',
    this.originalImageUrl = '',
    this.stencilImageUrl = '',
    this.baseStencilImageUrl = '',
    this.status = '',
    this.errorMessage = '',
    this.colorTheme = '',
    this.colorThemeId = '',
    this.themeRenderMode = ThemeRenderMode.gemini,
    this.detailLevel = 1,
    this.isSaved = false,
  });
}

class StencilSampleImage {
  final String id;
  final String originalUrl;
  final String resultUrl;

  const StencilSampleImage({
    required this.id,
    required this.originalUrl,
    required this.resultUrl,
  });
}

class StencilRecord {
  final String id;
  final String style;
  final String styleId;
  final String colorTheme;
  final String colorThemeId;
  final int detailLevel;
  final double brightness;
  final double contrast;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String originalImageUrl;
  final String stencilImageUrl;
  final String baseStencilImageUrl;
  final String errorCode;
  final String errorMessage;
  final bool isSaved;
  final ThemeRenderMode themeRenderMode;
  final String generationSignature;
  final String sourceFingerprint;

  const StencilRecord({
    required this.id,
    required this.style,
    required this.styleId,
    required this.colorTheme,
    required this.colorThemeId,
    required this.detailLevel,
    required this.brightness,
    required this.contrast,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.originalImageUrl,
    required this.stencilImageUrl,
    required this.baseStencilImageUrl,
    required this.errorCode,
    required this.errorMessage,
    required this.isSaved,
    required this.themeRenderMode,
    required this.generationSignature,
    required this.sourceFingerprint,
  });

  factory StencilRecord.fromApi(Map<String, dynamic> json) {
    final original = json['originalImage'] as Map<String, dynamic>?;
    final stencil = json['stencilImage'] as Map<String, dynamic>?;
    final baseStencil = json['baseStencilImage'] as Map<String, dynamic>?;

    final originalUrl = original?['url'] as String? ?? '';
    final stencilUrl = stencil?['url'] as String? ?? '';
    final baseStencilUrl = baseStencil?['url'] as String? ?? stencilUrl;
    final id =
        (json['_id'] as String?) ??
        (original?['publicId'] as String?) ??
        originalUrl;

    return StencilRecord(
      id: id,
      style: json['style'] as String? ?? '',
      styleId: json['styleId'] as String? ?? '',
      colorTheme: json['colorTheme'] as String? ?? '',
      colorThemeId: json['colorThemeId'] as String? ?? '',
      detailLevel: (json['detailLevel'] as num?)?.round() ?? 1,
      brightness: (json['brightness'] as num?)?.toDouble() ?? 0.8,
      contrast: (json['contrast'] as num?)?.toDouble() ?? 0.6,
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      originalImageUrl: originalUrl,
      stencilImageUrl: stencilUrl,
      baseStencilImageUrl: baseStencilUrl,
      errorCode: json['errorCode'] as String? ?? '',
      errorMessage: json['errorMessage'] as String? ?? '',
      isSaved: json['isSaved'] == true,
      themeRenderMode: ThemeRenderMode.fromApi(json['themeRenderMode'] as String?),
      generationSignature: json['generationSignature'] as String? ?? '',
      sourceFingerprint: json['sourceFingerprint'] as String? ?? '',
    );
  }

  StencilRecord copyWith({
    String? id,
    String? style,
    String? styleId,
    String? colorTheme,
    String? colorThemeId,
    int? detailLevel,
    double? brightness,
    double? contrast,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? originalImageUrl,
    String? stencilImageUrl,
    String? baseStencilImageUrl,
    String? errorCode,
    String? errorMessage,
    bool? isSaved,
    ThemeRenderMode? themeRenderMode,
    String? generationSignature,
    String? sourceFingerprint,
  }) {
    return StencilRecord(
      id: id ?? this.id,
      style: style ?? this.style,
      styleId: styleId ?? this.styleId,
      colorTheme: colorTheme ?? this.colorTheme,
      colorThemeId: colorThemeId ?? this.colorThemeId,
      detailLevel: detailLevel ?? this.detailLevel,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      originalImageUrl: originalImageUrl ?? this.originalImageUrl,
      stencilImageUrl: stencilImageUrl ?? this.stencilImageUrl,
      baseStencilImageUrl: baseStencilImageUrl ?? this.baseStencilImageUrl,
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
      isSaved: isSaved ?? this.isSaved,
      themeRenderMode: themeRenderMode ?? this.themeRenderMode,
      generationSignature: generationSignature ?? this.generationSignature,
      sourceFingerprint: sourceFingerprint ?? this.sourceFingerprint,
    );
  }

  String get previewImageUrl => baseStencilImageUrl.isNotEmpty
      ? baseStencilImageUrl
      : stencilImageUrl;
}
