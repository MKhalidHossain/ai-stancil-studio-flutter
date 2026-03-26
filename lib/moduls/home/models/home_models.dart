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

class GalleryPreview {
  final String itemId;
  final String originalImageUrl;
  final String previewImageUrl;
  final String style;
  final String colorTheme;
  final int detailLevel;
  final String status;
  final String errorMessage;

  const GalleryPreview({
    required this.itemId,
    required this.originalImageUrl,
    required this.previewImageUrl,
    required this.style,
    required this.colorTheme,
    required this.detailLevel,
    required this.status,
    required this.errorMessage,
  });

  factory GalleryPreview.fromApi(String itemId, Map<String, dynamic> json) {
    final original = json['originalImage'] as Map<String, dynamic>?;
    final preview = json['stencilImage'] as Map<String, dynamic>?;

    return GalleryPreview(
      itemId: itemId,
      originalImageUrl: (original?['url'] ?? '').toString(),
      previewImageUrl: (preview?['url'] ?? '').toString(),
      style: (json['style'] ?? '').toString(),
      colorTheme: (json['colorTheme'] ?? '').toString(),
      detailLevel: (json['detailLevel'] as num?)?.round() ?? 1,
      status: (json['status'] ?? '').toString(),
      errorMessage: (json['errorMessage'] ?? '').toString(),
    );
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String profileImageUrl;
  final bool isPremium;
  final String subscriptionStatus;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.isPremium,
    required this.subscriptionStatus,
  });

  factory UserProfile.fromApi(Map<String, dynamic> json) {
    final profileImage = json['profileImage'] as Map<String, dynamic>?;

    return UserProfile(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      profileImageUrl: (profileImage?['url'] ?? '').toString(),
      isPremium: json['isPremium'] == true,
      subscriptionStatus: (json['subscriptionStatus'] ?? '').toString(),
    );
  }

  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return 'CS';
    }

    final parts = trimmed.split(RegExp(r'\s+')).where((part) => part.isNotEmpty);
    final initials = parts.take(2).map((part) => part[0].toUpperCase()).join();
    return initials.isEmpty ? 'CS' : initials;
  }
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

  bool get isYearly => id == 'yearly';

  String get checkoutHeadline => isYearly
      ? 'Start your yearly Cembostyle plan'
      : 'Start your monthly Cembostyle plan';

  String get checkoutSummary => isYearly
      ? 'Then \$99.00/year after your 3-day free trial.'
      : 'Then \$9.99/month after your 3-day free trial.';
}

class ColorThemeOption {
  final String id;
  final String title;

  const ColorThemeOption({required this.id, required this.title});
}
