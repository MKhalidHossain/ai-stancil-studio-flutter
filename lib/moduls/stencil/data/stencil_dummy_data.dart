import '../models/stencil_models.dart';

class StencilDummyData {
  static const List<StencilStyleOption> stencilStyles = [
    StencilStyleOption(
      id: 'outline',
      title: 'Outline',
      subtitle: 'Clean lines',
    ),
    StencilStyleOption(
      id: 'realism',
      title: 'Realism Map',
      subtitle: 'Animals',
    ),
    StencilStyleOption(
      id: 'detail',
      title: 'Detail Guide',
      subtitle: 'Optional',
    ),
    StencilStyleOption(
      id: 'halftone',
      title: 'Halftone Guide',
      subtitle: 'Optional advanced',
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

  static const List<StencilActivityItem> recentActivities = [
    StencilActivityItem(
      id: 's1',
      title: 'Stenciled a dragon tattoo',
      style: 'Impressionist',
      date: '27/02/2026',
      thumbnailUrl: 'https://picsum.photos/id/1025/200/240',
    ),
    StencilActivityItem(
      id: 's2',
      title: 'Stenciled a dragon tattoo',
      style: 'Impressionist',
      date: '27/02/2026',
      thumbnailUrl: 'https://picsum.photos/id/1005/200/240',
    ),
    StencilActivityItem(
      id: 's3',
      title: 'Stenciled a dragon tattoo',
      style: 'Impressionist',
      date: '27/02/2026',
      thumbnailUrl: 'https://picsum.photos/id/1000/200/240',
    ),
  ];

  static const List<StencilSampleImage> samples = [
    StencilSampleImage(
      id: 'sample1',
      originalUrl: 'https://picsum.photos/id/1062/700/700',
      resultUrl: 'https://picsum.photos/id/1050/700/700',
    ),
  ];
}
