import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/core/common/widgets/app_ui/before_after_slider.dart';
import 'package:cembostyle/core/common/widgets/app_ui/detail_level_slider.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_outline_button.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_primary_button.dart';
import 'package:cembostyle/core/common/widgets/app_ui/styled_dropdown.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/moduls/stencil/controllers/stencil_controller.dart';

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
        title: const Text(
          'Your Stencil',
          style: TextStyle(color: AppPalette.textPrimary, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Obx(() {
            final record = controller.activeStencil.value;
            final image =
                record?.originalImageUrl ?? controller.samples.first.originalUrl;
            final resultImage =
                record?.stencilImageUrl ?? controller.samples.first.resultUrl;
            final hasFailed = record?.status == 'FAILED';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailLevelSlider(
                  value: controller.selectedDetailLevel.value,
                  onChanged: (value) =>
                      controller.selectedDetailLevel.value = value,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select color theme',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                StyledDropdown(
                  value: controller.selectedColorTheme,
                  items: controller.colorThemes
                      .map(
                        (theme) => DropdownMenuItem(
                          value: theme,
                          child: Text(
                            theme.title,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (newValue) {
                    if (newValue == null) {
                      return;
                    }
                    final index = controller.colorThemes.indexOf(newValue);
                    controller.selectedColorThemeIndex.value = index;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 280,
                  child: BeforeAfterSlider(
                    beforeImage: image,
                    afterImage: resultImage,
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
                ] else ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaChip(
                        label: record?.style.isNotEmpty == true
                            ? record!.style
                            : controller.selectedStyle.title,
                      ),
                      _MetaChip(
                        label: record?.colorTheme.isNotEmpty == true
                            ? record!.colorTheme
                            : controller.selectedColorTheme.title,
                      ),
                      _MetaChip(
                        label: 'Detail ${controller.selectedDetailLevel.value}',
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                HomePrimaryButton(
                  text: 'Save to library',
                  icon: const Icon(Icons.bookmark_border, size: 16),
                  onTap: controller.markAsSaved,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: HomeOutlineButton(
                        text: 'Open',
                        icon: const Icon(Icons.open_in_new, size: 16),
                        onTap: controller.openActiveStencilExternally,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: HomeOutlineButton(
                        text: 'Share',
                        icon: const Icon(Icons.share, size: 16),
                        onTap: controller.shareActiveStencil,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.refresh,
                      size: 16,
                      color: AppPalette.purple,
                    ),
                    label: const Text(
                      'Regenerate with new setting',
                      style: TextStyle(color: AppPalette.purple, fontSize: 12),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;

  const _MetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppPalette.purpleSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppPalette.textPrimary,
        ),
      ),
    );
  }
}
