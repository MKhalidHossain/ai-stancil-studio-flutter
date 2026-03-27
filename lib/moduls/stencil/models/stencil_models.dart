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

  const ColorThemeOption({required this.id, required this.title});
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
  final String status;
  final String errorMessage;
  final String colorTheme;
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
    this.status = '',
    this.errorMessage = '',
    this.colorTheme = '',
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
  final String colorTheme;
  final int detailLevel;
  final double brightness;
  final double contrast;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String originalImageUrl;
  final String stencilImageUrl;
  final String errorCode;
  final String errorMessage;
  final bool isSaved;

  const StencilRecord({
    required this.id,
    required this.style,
    required this.colorTheme,
    required this.detailLevel,
    required this.brightness,
    required this.contrast,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.originalImageUrl,
    required this.stencilImageUrl,
    required this.errorCode,
    required this.errorMessage,
    required this.isSaved,
  });

  factory StencilRecord.fromApi(Map<String, dynamic> json) {
    final original = json['originalImage'] as Map<String, dynamic>?;
    final stencil = json['stencilImage'] as Map<String, dynamic>?;

    final originalUrl = original?['url'] as String? ?? '';
    final stencilUrl = stencil?['url'] as String? ?? '';
    final id =
        (json['_id'] as String?) ??
        (original?['publicId'] as String?) ??
        originalUrl;

    return StencilRecord(
      id: id,
      style: json['style'] as String? ?? '',
      colorTheme: json['colorTheme'] as String? ?? '',
      detailLevel: (json['detailLevel'] as num?)?.round() ?? 1,
      brightness: (json['brightness'] as num?)?.toDouble() ?? 0.8,
      contrast: (json['contrast'] as num?)?.toDouble() ?? 0.6,
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      originalImageUrl: originalUrl,
      stencilImageUrl: stencilUrl,
      errorCode: json['errorCode'] as String? ?? '',
      errorMessage: json['errorMessage'] as String? ?? '',
      isSaved: json['isSaved'] == true,
    );
  }
}
