import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/core/common/widgets/app_ui/before_after_slider.dart';
import 'package:cembostyle/core/common/widgets/app_ui/detail_level_slider.dart';
import 'package:cembostyle/core/common/widgets/app_ui/styled_dropdown.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/moduls/home/controllers/home_controller.dart';
import 'package:cembostyle/moduls/home/models/home_models.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final HomeController _controller;
  late final GalleryItem _item;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<HomeController>();
    final passedItem = Get.arguments as GalleryItem?;
    final fallbackItem = _controller.galleryItems.isNotEmpty
        ? _controller.galleryItems.first
        : null;
    _item = passedItem ?? fallbackItem!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.generateGalleryPreview(item: _item);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  value: _controller.selectedDetailLevel.value,
                  onChanged: (value) {
                    _controller.selectedDetailLevel.value = value;
                    _controller.generateGalleryPreview(
                      item: _item,
                      forceRefresh: true,
                    );
                  },
                );
              }),
              const SizedBox(height: 16),
              const Text(
                'Select color theme',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Obx(() {
                final selected =
                    _controller.colorThemes[_controller.selectedColorThemeIndex.value];
                return StyledDropdown<ColorThemeOption>(
                  value: selected,
                  items: _controller.colorThemes
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
                    if (newValue == null) {
                      return;
                    }

                    final index = _controller.colorThemes.indexOf(newValue);
                    _controller.selectedColorThemeIndex.value = index;
                    _controller.generateGalleryPreview(
                      item: _item,
                      forceRefresh: true,
                    );
                  },
                );
              }),
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Obx(() {
                      final preview = _controller.activeGalleryPreview.value;
                      final image = preview?.originalImageUrl.isNotEmpty == true
                          ? preview!.originalImageUrl
                          : _item.imageUrl;
                      final resultImage =
                          preview?.previewImageUrl.isNotEmpty == true
                              ? preview!.previewImageUrl
                              : image;

                      return Stack(
                        children: [
                          BeforeAfterSlider(
                            beforeImage: image,
                            afterImage: resultImage,
                            value: _controller.compareValue.value,
                            onChanged: _controller.updateCompare,
                          ),
                          if (_controller.isGalleryPreviewLoading.value)
                            Positioned.fill(
                              child: Container(
                                color: Colors.white.withValues(alpha: 0.65),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              Obx(() {
                final message = _controller.galleryPreviewError.value;
                if (message.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.redAccent,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
