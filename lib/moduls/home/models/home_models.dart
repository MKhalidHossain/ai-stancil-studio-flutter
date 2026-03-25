class CategoryItem {
  final String id;
  final String title;

  const CategoryItem({required this.id, required this.title});
}

class GalleryItem {
  final String id;
  final String categoryId;
  final String title;
  final String imageUrl;
  final String resultImageUrl;
  final List<String> availableThemes;
  final List<String> styleLevel;

  const GalleryItem({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.imageUrl,
    required this.resultImageUrl,
    this.availableThemes = const [],
    this.styleLevel = const [],
  });

  factory GalleryItem.fromApi(Map<String, dynamic> json) {
    final image = json['image'] as Map<String, dynamic>?;
    final imageUrl = image?['url'] as String? ?? '';
    final publicId = image?['publicId'] as String?;
    final category = json['category'] as String? ?? '';
    final availableThemes =
        (json['availableThemes'] as List?)?.whereType<String>().toList() ??
        const [];
    final styleLevel =
        (json['styleLevel'] as List?)?.whereType<String>().toList() ?? const [];

    return GalleryItem(
      id: (json['_id'] as String?) ?? publicId ?? imageUrl,
      categoryId: category,
      title: category.isNotEmpty ? category : (publicId ?? 'Gallery Item'),
      imageUrl: imageUrl,
      resultImageUrl: imageUrl,
      availableThemes: availableThemes,
      styleLevel: styleLevel,
    );
  }
}

class ActivityItem {
  final String id;
  final String title;
  final String style;
  final String date;
  final String thumbnailUrl;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.style,
    required this.date,
    required this.thumbnailUrl,
  });
}

class PlanOption {
  final String id;
  final String title;
  final String price;
  final String periodLabel;
  final String badge;
  final String savings;

  const PlanOption({
    required this.id,
    required this.title,
    required this.price,
    required this.periodLabel,
    required this.badge,
    required this.savings,
  });
}

class ColorThemeOption {
  final String id;
  final String title;

  const ColorThemeOption({required this.id, required this.title});
}
