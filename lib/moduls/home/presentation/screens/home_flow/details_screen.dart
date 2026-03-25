import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/moduls/home/controllers/home_controller.dart';

import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/core/common/widgets/app_ui/before_after_slider.dart';
import 'package:cembostyle/core/common/widgets/app_ui/detail_level_slider.dart';
import 'package:cembostyle/core/common/widgets/app_ui/styled_dropdown.dart';

import '../../../models/home_models.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final GalleryItem? item = Get.arguments as GalleryItem?;
    final fallbackItem = controller.galleryItems.isNotEmpty
        ? controller.galleryItems.first
        : null;
    final image = item?.imageUrl ?? fallbackItem?.imageUrl ?? '';
    final resultImage =
        item?.resultImageUrl ?? fallbackItem?.resultImageUrl ?? image;

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Details',
          style: TextStyle(
            color: AppPalette.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: BackButton(
          color: AppPalette.textPrimary,
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
                return StyledDropdown<ColorThemeOption>(
                  value: selected,
                  items: controller.colorThemes
                      .map(
                        (theme) => DropdownMenuItem<ColorThemeOption>(
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
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Obx(() {
                      return BeforeAfterSlider(
                        beforeImage: image,
                        afterImage: resultImage,
                        value: controller.compareValue.value,
                        onChanged: controller.updateCompare,
                      );
                    }),
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
