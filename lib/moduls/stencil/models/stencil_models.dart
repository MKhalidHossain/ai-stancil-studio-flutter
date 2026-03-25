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

  const StencilActivityItem({
    required this.id,
    required this.title,
    required this.style,
    required this.date,
    required this.thumbnailUrl,
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
  final String status;
  final String createdAt;
  final String updatedAt;
  final String originalImageUrl;
  final String stencilImageUrl;
  final String errorCode;
  final String errorMessage;

  const StencilRecord({
    required this.id,
    required this.style,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.originalImageUrl,
    required this.stencilImageUrl,
    required this.errorCode,
    required this.errorMessage,
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
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      originalImageUrl: originalUrl,
      stencilImageUrl: stencilUrl,
      errorCode: json['errorCode'] as String? ?? '',
      errorMessage: json['errorMessage'] as String? ?? '',
    );
  }
}
