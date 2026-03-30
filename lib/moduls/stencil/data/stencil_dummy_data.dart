import '../models/stencil_models.dart';

class StencilDummyData {
  static const List<StencilStyleOption> stencilStyles = [
    StencilStyleOption(
      id: 'outline',
      title: 'Outline',
      subtitle: 'Simple clean transfer lines',
    ),
    StencilStyleOption(
      id: 'realism_map',
      title: 'Realism Map',
      subtitle: 'Grayscale value map for depth and shading',
    ),
    StencilStyleOption(
      id: 'detail_guide',
      title: 'Detail Guide',
      subtitle: 'Texture and landmark guide',
    ),
    StencilStyleOption(
      id: 'halftone_guide',
      title: 'Halftone Guide',
      subtitle: 'Dot-shaded guide for print-style shading',
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
