import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_cached_image.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/moduls/stencil/controllers/stencil_controller.dart';
import 'package:cembostyle/moduls/stencil/models/stencil_models.dart';

class MyStencilsScreen extends StatefulWidget {
  const MyStencilsScreen({super.key});

  @override
  State<MyStencilsScreen> createState() => _MyStencilsScreenState();
}

class _MyStencilsScreenState extends State<MyStencilsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StencilController>();

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: AppPalette.textPrimary,
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: const Text(
          'My Stencils',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppPalette.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final total = controller.recentActivities.length;
              return Text(
                'Total $total Stencils',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppPalette.textSecondary,
                ),
              );
            }),
            const SizedBox(height: 12),
            _SearchField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (controller.isRecentActivityLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = _filterActivities(
                  controller.recentActivities,
                  _query,
                );
                final hasError =
                    controller.recentActivityError.value.isNotEmpty;

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
                                : 'No stencils found.',
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

                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _StencilGridCard(item: item);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<StencilActivityItem> _filterActivities(
    List<StencilActivityItem> items,
    String query,
  ) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items
        .where(
          (item) =>
              item.title.toLowerCase().contains(q) ||
              item.style.toLowerCase().contains(q),
        )
        .toList();
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        hintText: 'Search stencils........',
        hintStyle: const TextStyle(
          fontSize: 12,
          color: AppPalette.textSecondary,
        ),
        prefixIcon: const Icon(Icons.search, size: 18),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppPalette.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppPalette.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppPalette.purple),
        ),
      ),
    );
  }
}

class _StencilGridCard extends StatelessWidget {
  final StencilActivityItem item;

  const _StencilGridCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final styleLabel = item.style.split(' • ').first;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.cardBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 1,
              child: Row(
                children: [
                  Expanded(
                    child: AppCachedImage(
                      imageUrl: item.thumbnailUrl,
                      fit: BoxFit.cover,
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.matrix([
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                      ]),
                      child: AppCachedImage(
                        imageUrl: item.thumbnailUrl,
                        fit: BoxFit.cover,
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            styleLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.date,
            style: const TextStyle(
              fontSize: 10,
              color: AppPalette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
