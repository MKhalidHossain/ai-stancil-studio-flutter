import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/moduls/stencil/controllers/stencil_controller.dart';
import 'package:cembostyle/moduls/stencil/presentation/routes/stencil_routes.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/core/common/widgets/app_ui/quick_action_card.dart';
import 'package:cembostyle/core/common/widgets/app_ui/recent_activity_tile.dart';
import 'package:cembostyle/core/common/widgets/app_ui/section_title.dart';
import 'package:cembostyle/core/common/widgets/app_ui/upload_card.dart';

class StencilScreen extends StatelessWidget {
  const StencilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StencilController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stencil Generator',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppPalette.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(
                  child: QuickActionCard(
                    title: 'My Stencils',
                    value: '03',
                    icon: Icons.folder_copy_outlined,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: QuickActionCard(
                    title: 'Total Stencil',
                    value: '08',
                    icon: Icons.layers_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            UploadCard(
              onGalleryTap: () => Get.toNamed(StencilRoutes.customizeStyle),
              onCameraTap: () => Get.toNamed(StencilRoutes.customizeStyle),
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Recent Stencil Activity'),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isRecentActivityLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final items = controller.recentActivities;
              final hasError = controller.recentActivityError.value.isNotEmpty;

              if (items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          hasError
                              ? controller.recentActivityError.value
                              : 'No recent stencil activity yet.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppPalette.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: controller.refreshRecentActivities,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final limitedItems = items.take(3).toList();

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
                              'Could not refresh activity. Showing last saved data.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppPalette.textSecondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: controller.refreshRecentActivities,
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    ),
                  ...limitedItems.map(
                    (item) => RecentActivityTile(
                      title: item.title,
                      style: item.style,
                      date: item.date,
                      thumbnailUrl: item.thumbnailUrl,
                      splitPreview: false,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
