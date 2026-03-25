import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_cached_image.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/moduls/stencil/controllers/stencil_controller.dart';
import 'package:cembostyle/moduls/stencil/presentation/routes/stencil_routes.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/moduls/stencil/presentation/widgets/generating_dialog.dart';
import 'package:cembostyle/moduls/stencil/presentation/widgets/style_option_card.dart';

class CustomizeStyleScreen extends StatelessWidget {
  const CustomizeStyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StencilController>();

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Customize Style',
          style: TextStyle(
            color: AppPalette.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: BackButton(
          color: AppPalette.textPrimary,
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose your stencil style and adjust settings',
                style: TextStyle(fontSize: 11, color: AppPalette.textSecondary),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppPalette.cardBorder),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: AppCachedImage(
                      imageUrl: controller.samples.first.originalUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      onTap: () {},
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Obx(() {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(controller.stencilStyles.length, (
                    index,
                  ) {
                    final item = controller.stencilStyles[index];
                    final selected =
                        controller.selectedStyleIndex.value == index;
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 42) / 2,
                      child: StyleOptionCard(
                        title: item.title,
                        subtitle: item.subtitle,
                        isSelected: selected,
                        onTap: () =>
                            controller.selectedStyleIndex.value = index,
                      ),
                    );
                  }),
                );
              }),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppPalette.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.tune, size: 16, color: AppPalette.purple),
                        SizedBox(width: 6),
                        Text(
                          'Adjustments',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _AdjustmentSlider(
                      label: 'Brightness',
                      value: controller.brightness,
                    ),
                    const SizedBox(height: 6),
                    _AdjustmentSlider(
                      label: 'Contrast',
                      value: controller.contrast,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const GeneratingDialog(),
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    Get.back();
                    Get.toNamed(StencilRoutes.stencilResult);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.auto_awesome, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Generate Stencil',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
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

class _AdjustmentSlider extends StatelessWidget {
  final String label;
  final RxDouble value;

  const _AdjustmentSlider({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(fontSize: 11)),
              const Spacer(),
              Text(
                '${(value.value * 100).round()}%',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppPalette.textSecondary,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.black,
              inactiveTrackColor: const Color(0xFFE6E6E6),
              thumbColor: Colors.white,
              overlayColor: Colors.black.withOpacity(0.08),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: value.value,
              min: 0,
              max: 1,
              onChanged: (newValue) => value.value = newValue,
            ),
          ),
        ],
      );
    });
  }
}
