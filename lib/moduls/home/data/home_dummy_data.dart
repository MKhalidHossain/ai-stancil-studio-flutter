import '../models/home_models.dart';

class HomeDummyData {
  static const List<CategoryItem> categories = [
    CategoryItem(id: 'outline', title: 'Outline'),
    CategoryItem(id: 'realism', title: 'Realism Map'),
    CategoryItem(id: 'detail', title: 'Detail Guide'),
    CategoryItem(id: 'halftone', title: 'Halftone'),
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
      categoryId: 'realism',
      title: 'Golden Portrait',
      imageUrl: 'https://picsum.photos/id/1005/600/800',
      resultImageUrl: 'https://picsum.photos/id/1003/600/800',
    ),
    GalleryItem(
      id: 'g3',
      categoryId: 'detail',
      title: 'Charcoal Muse',
      imageUrl: 'https://picsum.photos/id/1000/600/800',
      resultImageUrl: 'https://picsum.photos/id/1027/600/800',
    ),
    GalleryItem(
      id: 'g4',
      categoryId: 'halftone',
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
      categoryId: 'realism',
      title: 'Retro Coupe',
      imageUrl: 'https://picsum.photos/id/1072/600/800',
      resultImageUrl: 'https://picsum.photos/id/1074/600/800',
    ),
    GalleryItem(
      id: 'g7',
      categoryId: 'detail',
      title: 'Golden Lion',
      imageUrl: 'https://picsum.photos/id/1070/600/800',
      resultImageUrl: 'https://picsum.photos/id/1069/600/800',
    ),
    GalleryItem(
      id: 'g8',
      categoryId: 'halftone',
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
    ColorThemeOption(id: 'black', title: 'Tattoo Black & Grey'),
    ColorThemeOption(id: 'stencil_violet', title: 'Stencil Violet'),
    ColorThemeOption(id: 'cobalt', title: 'Stencil Cobalt Blue'),
    ColorThemeOption(id: 'red_black', title: 'Red & Black Contrast'),
    ColorThemeOption(id: 'deep_blue', title: 'Deep Blue Ink'),
    ColorThemeOption(id: 'sepia', title: 'Sepia Draft'),
    ColorThemeOption(id: 'super', title: 'Super Contrast'),
  ];
}
