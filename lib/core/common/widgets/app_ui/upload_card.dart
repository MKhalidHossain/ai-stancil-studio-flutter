import 'package:flutter/material.dart';

import 'package:cembostyle/core/theme/app_palette.dart';
import 'dashed_border_container.dart';
import 'home_outline_button.dart';

class UploadCard extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;
  final bool showActionButtons;

  const UploadCard({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
    this.showActionButtons = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashedBorderContainer(
          borderRadius: 18,
          borderColor: AppPalette.purple,
          dashLength: 6,
          gapLength: 4,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            color: const Color(0xFFF8F6FF),
            child: Column(
              children: const [
                Icon(Icons.ios_share, color: AppPalette.textPrimary, size: 26),
                SizedBox(height: 8),
                Text(
                  'Upload Your own Image',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  '3 Day free-trial experience',
                  style: TextStyle(fontSize: 12, color: AppPalette.textSecondary),
                ),
              ],
            ),
          ),
        ),
        if (showActionButtons) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: HomeOutlineButton(
                  text: 'Gallery',
                  icon: const Icon(
                    Icons.photo_library_outlined,
                    size: 18,
                    color: AppPalette.black,
                  ),
                  onTap: onGalleryTap,
                  height: 44,
                  radius: 26,
                  borderColor: AppPalette.purple,
                  fillColor: AppPalette.purpleSoft,
                  foregroundColor: AppPalette.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HomeOutlineButton(
                  text: 'Camera',
                  icon: const Icon(
                    Icons.photo_camera_outlined,
                    size: 18,
                    color: AppPalette.black,
                  ),
                  onTap: onCameraTap,
                  height: 44,
                  radius: 26,
                  borderColor: AppPalette.purple,
                  fillColor: AppPalette.purpleSoft,
                  foregroundColor: AppPalette.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
