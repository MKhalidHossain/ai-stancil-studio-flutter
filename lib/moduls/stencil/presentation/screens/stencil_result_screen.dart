import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/core/common/widgets/app_ui/before_after_slider.dart';
import 'package:cembostyle/core/common/widgets/app_ui/detail_level_slider.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_outline_button.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_primary_button.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/moduls/stencil/controllers/stencil_controller.dart';
import 'package:cembostyle/moduls/stencil/presentation/routes/stencil_routes.dart';
import 'package:cembostyle/moduls/stencil/presentation/widgets/color_theme_selector.dart';
import 'package:cembostyle/moduls/stencil/presentation/widgets/generating_dialog.dart';

class StencilResultScreen extends StatelessWidget {
  const StencilResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StencilController>();

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: const Text(
          'Your Stencil',
          style: TextStyle(
            color: AppPalette.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Obx(() {
          final record = controller.activeStencil.value;
          final image = record?.originalImageUrl.isNotEmpty == true
              ? record!.originalImageUrl
              : controller.samples.first.originalUrl;
          final hasFailed = record?.status == 'FAILED';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preview and save your creation',
                style: TextStyle(
                  fontSize: 12,
                  color: AppPalette.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              DetailLevelSlider(
                value: controller.selectedDetailLevel.value,
                onChanged: (value) {
                  if (value == controller.selectedDetailLevel.value ||
                      controller.isGenerating.value) {
                    return;
                  }
                  _regenerateWithLoader(context, controller, value);
                },
              ),
              const SizedBox(height: 18),
              const Text(
                'Select color theme',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              ColorThemeSelector(
                themes: controller.colorThemes,
                selectedThemeId: controller.selectedColorTheme.id,
                onSelected: (newValue) {
                  final index = controller.colorThemes.indexOf(newValue);
                  if (index < 0 ||
                      index == controller.selectedColorThemeIndex.value ||
                      controller.isGenerating.value) {
                    return;
                  }

                  if (controller.canApplyThemeInstantly(index)) {
                    controller.updateSelectedTheme(index);
                    return;
                  }

                  _changeThemeWithLoader(context, controller, index);
                },
              ),
              const SizedBox(height: 14),
              AspectRatio(
                aspectRatio: 0.94,
                child: BeforeAfterSlider(
                  beforeImage: image,
                  afterImage: controller.activeGeneratedPreviewUrl,
                  afterImageColorFilter: controller.activePreviewColorFilter,
                  value: controller.compareValue.value,
                  onChanged: controller.updateCompare,
                ),
              ),
              if (hasFailed) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4F4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFC5C5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Generation failed',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB42318),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        record?.errorMessage.isNotEmpty == true
                            ? record!.errorMessage
                            : 'The backend could not generate this stencil.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppPalette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              HomePrimaryButton(
                text: controller.isSavingToGallery.value
                    ? 'Saving...'
                    : record?.isSaved == true
                    ? 'Saved to gallery'
                    : 'Save to gallery',
                icon: Icon(
                  record?.isSaved == true
                      ? Icons.check_circle_rounded
                      : Icons.save_alt_rounded,
                  size: 18,
                ),
                radius: 28,
                height: 46,
                onTap: controller.isSavingToGallery.value
                    ? null
                    : () => controller.markAsSaved(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: HomeOutlineButton(
                      text: controller.isDownloadingPdf.value
                          ? 'Downloading...'
                          : 'Download',
                      icon: const Icon(Icons.download_rounded, size: 18),
                      borderColor: AppPalette.textPrimary,
                      foregroundColor: AppPalette.textPrimary,
                      fillColor: Colors.white,
                      radius: 26,
                      height: 46,
                      onTap: controller.isDownloadingPdf.value
                          ? null
                          : () => _showDownloadOptions(context, controller),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HomeOutlineButton(
                      text: 'Share',
                      icon: const Icon(Icons.share_rounded, size: 18),
                      borderColor: AppPalette.textPrimary,
                      foregroundColor: AppPalette.textPrimary,
                      fillColor: Colors.white,
                      radius: 26,
                      height: 46,
                      onTap: controller.shareActiveStencil,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: controller.isGenerating.value
                      ? null
                      : () => Get.offNamed(StencilRoutes.customizeStyle),
                  icon: const Icon(
                    Icons.autorenew_rounded,
                    size: 18,
                    color: AppPalette.purple,
                  ),
                  label: const Text(
                    'Regenerate with new setting',
                    style: TextStyle(
                      color: AppPalette.purple,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

Future<void> _regenerateWithLoader(
  BuildContext context,
  StencilController controller,
  int value,
) async {
  if (controller.isGenerating.value) {
    return;
  }

  final navigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) => const GeneratingDialog(),
  );

  await controller.updateSelectedDetailLevel(value);

  navigator.pop();
}

Future<void> _showDownloadOptions(
  BuildContext context,
  StencilController controller,
) async {
  final format = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Download as',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              _DownloadOptionTile(
                title: 'JPEG',
                subtitle: 'Small image file for sharing',
                onTap: () => Navigator.of(context).pop('jpeg'),
              ),
              _DownloadOptionTile(
                title: 'PNG',
                subtitle: 'High-quality image with crisp lines',
                onTap: () => Navigator.of(context).pop('png'),
              ),
              _DownloadOptionTile(
                title: 'PDF',
                subtitle: 'Printable A4 document',
                onTap: () => Navigator.of(context).pop('pdf'),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (format == null || controller.isDownloadingPdf.value) {
    return;
  }

  await controller.downloadActiveStencil(format);
}

class _DownloadOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DownloadOptionTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppPalette.purpleSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.download_rounded,
          color: AppPalette.purple,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppPalette.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppPalette.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: AppPalette.textSecondary,
      ),
    );
  }
}

Future<void> _changeThemeWithLoader(
  BuildContext context,
  StencilController controller,
  int index,
) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) => const GeneratingDialog(),
  );

  await controller.updateSelectedTheme(index);

  navigator.pop();
}
