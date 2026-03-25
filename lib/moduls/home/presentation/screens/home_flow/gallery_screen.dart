import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_cached_image.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/moduls/home/controllers/home_controller.dart';
import 'package:cembostyle/moduls/home/presentation/routes/home_routes.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/home_flow/category_chip.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        titleSpacing: 0,
        leadingWidth: BackButton().iconSize,

        title: const Text(
          'Try the Gallery for free',
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
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Browse through our pre-selected example images.',
                style: TextStyle(fontSize: 12, color: AppPalette.textSecondary),
              ),
              const SizedBox(height: 16),
              const Text(
                'Categories',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(controller.categories.length, (
                      index,
                    ) {
                      final item = controller.categories[index];
                      final selected =
                          controller.selectedCategoryIndex.value == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          text: item.title,
                          isSelected: selected,
                          onTap: () => controller.selectCategory(index),
                        ),
                      );
                    }),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  if (controller.isGalleryLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final hasError = controller.galleryError.value.isNotEmpty;
                  final items = controller.galleryItems;

                  if (items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              hasError
                                  ? controller.galleryError.value
                                  : 'No images found for this category.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppPalette.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: controller.refreshGallery,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      if (hasError)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppPalette.purple.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Some images may be outdated. Pull to refresh.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppPalette.textSecondary,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: controller.refreshGallery,
                                child: const Text('Refresh'),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: controller.refreshGallery,
                          child: GridView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: items.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 1,
                                ),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return GestureDetector(
                                onTap: () => Get.toNamed(
                                  HomeRoutes.details,
                                  arguments: item,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: AppCachedImage(
                                    imageUrl: item.imageUrl,
                                    onTap: () {},
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
