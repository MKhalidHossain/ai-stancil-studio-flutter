import '../models/home_models.dart';
import 'package:cembostyle/moduls/stencil/models/stencil_models.dart'
    show ColorThemeOption, ThemeRenderMode;

class HomeDummyData {
  static const List<CategoryItem> categories = [
    CategoryItem(id: 'outline', title: 'Outline'),
    CategoryItem(id: 'realism_map', title: 'Realism Map'),
    CategoryItem(id: 'detail_guide', title: 'Detail Guide'),
    CategoryItem(id: 'halftone_guide', title: 'Halftone Guide'),
  ];

  static const List<GalleryItem> galleryItems = [
    GalleryItem(
      id: 'g1',
      categoryId: 'outline',
      title: 'Ornate Serpent',
      imageUrl: 'https://picsum.photos/id/1025/600/800',
      resultImageUrl: 'https://picsum.photos/id/1011/600/800',
    ),
    GalleryItem(
      id: 'g2',
      categoryId: 'realism_map',
      title: 'Golden Portrait',
      imageUrl: 'https://picsum.photos/id/1005/600/800',
      resultImageUrl: 'https://picsum.photos/id/1003/600/800',
    ),
    GalleryItem(
      id: 'g3',
      categoryId: 'detail_guide',
      title: 'Charcoal Muse',
      imageUrl: 'https://picsum.photos/id/1000/600/800',
      resultImageUrl: 'https://picsum.photos/id/1027/600/800',
    ),
    GalleryItem(
      id: 'g4',
      categoryId: 'halftone_guide',
      title: 'Mountain Path',
      imageUrl: 'https://picsum.photos/id/1018/600/800',
      resultImageUrl: 'https://picsum.photos/id/1016/600/800',
    ),
    GalleryItem(
      id: 'g5',
      categoryId: 'outline',
      title: 'Classic Statue',
      imageUrl: 'https://picsum.photos/id/1001/600/800',
      resultImageUrl: 'https://picsum.photos/id/1002/600/800',
    ),
    GalleryItem(
      id: 'g6',
      categoryId: 'realism_map',
      title: 'Retro Coupe',
      imageUrl: 'https://picsum.photos/id/1072/600/800',
      resultImageUrl: 'https://picsum.photos/id/1074/600/800',
    ),
    GalleryItem(
      id: 'g7',
      categoryId: 'detail_guide',
      title: 'Golden Lion',
      imageUrl: 'https://picsum.photos/id/1070/600/800',
      resultImageUrl: 'https://picsum.photos/id/1069/600/800',
    ),
    GalleryItem(
      id: 'g8',
      categoryId: 'halftone_guide',
      title: 'Regal Portrait',
      imageUrl: 'https://picsum.photos/id/1062/600/800',
      resultImageUrl: 'https://picsum.photos/id/1050/600/800',
    ),
  ];

  static const List<ActivityItem> recentActivities = [
    ActivityItem(
      id: 'a1',
      title: 'Stenciled a dragon tattoo',
      style: 'Impressionist',
      date: '27/02/2026',
      thumbnailUrl: 'https://picsum.photos/id/1025/200/240',
    ),
    ActivityItem(
      id: 'a2',
      title: 'Stenciled a dragon tattoo',
      style: 'Impressionist',
      date: '27/02/2026',
      thumbnailUrl: 'https://picsum.photos/id/1005/200/240',
    ),
    ActivityItem(
      id: 'a3',
      title: 'Stenciled a dragon tattoo',
      style: 'Impressionist',
      date: '27/02/2026',
      thumbnailUrl: 'https://picsum.photos/id/1000/200/240',
    ),
  ];

  static const List<PlanOption> plans = [
    PlanOption(
      id: 'monthly',
      title: 'Monthly Plan',
      price: r'US$9.99',
      periodLabel: '/month',
      badge: '3-Day Free Trial',
      savings: '',
    ),
    PlanOption(
      id: 'yearly',
      title: 'Yearly Plan',
      price: r'US$8.25',
      periodLabel: '/month',
      badge: '3-Day Free Trial',
      savings: r'Save $20.88 per year!',
    ),
  ];

  static const List<ColorThemeOption> colorThemes = [
    ColorThemeOption(
      id: 'tattoo_black_grey',
      title: 'Tattoo Black & Grey',
      accentColorValue: 0xFF1F1F1F,
      renderMode: ThemeRenderMode.gemini,
    ),
    ColorThemeOption(
      id: 'stencil_violet',
      title: 'Stencil Violet',
      accentColorValue: 0xFF7A4BFF,
      renderMode: ThemeRenderMode.localTint,
    ),
    ColorThemeOption(
      id: 'stencil_cobalt_blue',
      title: 'Stencil Cobalt Blue',
      accentColorValue: 0xFF2859C5,
      renderMode: ThemeRenderMode.localTint,
    ),
    ColorThemeOption(
      id: 'red_black_contrast',
      title: 'Red & Black Contrast',
      accentColorValue: 0xFFB42318,
      renderMode: ThemeRenderMode.gemini,
    ),
    ColorThemeOption(
      id: 'deep_blue_ink',
      title: 'Deep Blue Ink',
      accentColorValue: 0xFF1D4F91,
      renderMode: ThemeRenderMode.localTint,
    ),
    ColorThemeOption(
      id: 'sepia_draft',
      title: 'Sepia Draft',
      accentColorValue: 0xFF8A5A3B,
      renderMode: ThemeRenderMode.localTint,
    ),
    ColorThemeOption(
      id: 'super_contrast',
      title: 'Super Contrast',
      accentColorValue: 0xFF111111,
      renderMode: ThemeRenderMode.gemini,
    ),
  ];
}
