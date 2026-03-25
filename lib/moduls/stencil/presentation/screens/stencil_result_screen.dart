import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/moduls/stencil/controllers/stencil_controller.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/core/common/widgets/app_ui/before_after_slider.dart';
import 'package:cembostyle/core/common/widgets/app_ui/detail_level_slider.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_outline_button.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_primary_button.dart';
import 'package:cembostyle/core/common/widgets/app_ui/styled_dropdown.dart';

class StencilResultScreen extends StatelessWidget {
  const StencilResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StencilController>();
    final image = controller.samples.first.originalUrl;
    final resultImage = controller.samples.first.resultUrl;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return DetailLevelSlider(
                  value: controller.selectedDetailLevel.value,
                  onChanged: (value) =>
                      controller.selectedDetailLevel.value = value,
                );
              }),
              const SizedBox(height: 16),
              const Text(
                'Select color theme',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Obx(() {
                final selected = controller
                    .colorThemes[controller.selectedColorThemeIndex.value];
                return StyledDropdown(
                  value: selected,
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
                    if (newValue == null) return;
                    final index = controller.colorThemes.indexOf(newValue);
                    controller.selectedColorThemeIndex.value = index;
                  },
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                height: 280,
                child: Obx(() {
                  return BeforeAfterSlider(
                    beforeImage: image,
                    afterImage: resultImage,
                    value: controller.compareValue.value,
                    onChanged: controller.updateCompare,
                  );
                }),
              ),
              const SizedBox(height: 16),
              HomePrimaryButton(
                text: 'Save to gallery',
                icon: const Icon(Icons.bookmark_border, size: 16),
                onTap: () {},
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: HomeOutlineButton(
                      text: 'Download',
                      icon: const Icon(Icons.download, size: 16),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HomeOutlineButton(
                      text: 'Share',
                      icon: const Icon(Icons.share, size: 16),
                      onTap: () {},
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
          ),
        ),
      ),
    );
  }
}
