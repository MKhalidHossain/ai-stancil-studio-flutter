import 'package:flutter/material.dart';

import 'package:cembostyle/core/common/widgets/app_cached_image.dart';
import 'package:cembostyle/core/theme/app_palette.dart';

class RecentActivityTile extends StatelessWidget {
  final String title;
  final String style;
  final String date;
  final String thumbnailUrl;
  final bool highlightStyle;
  final bool splitPreview;

  const RecentActivityTile({
    super.key,
    required this.title,
    required this.style,
    required this.date,
    required this.thumbnailUrl,
    this.highlightStyle = false,
    this.splitPreview = true,
  });

  @override
  Widget build(BuildContext context) {
    const previewSize = 86.0;
    const previewRadius = 12.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppPalette.cardBorder, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: previewSize,
            height: previewSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(previewRadius),
              border: Border.all(color: AppPalette.cardBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(previewRadius - 2),
              child: splitPreview
                  ? Row(
                      children: [
                        Expanded(
                          child: AppCachedImage(
                            imageUrl: thumbnailUrl,
                            width: previewSize / 2,
                            height: previewSize,
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
                              imageUrl: thumbnailUrl,
                              width: previewSize / 2,
                              height: previewSize,
                              fit: BoxFit.cover,
                              onTap: () {},
                            ),
                          ),
                        ),
                      ],
                    )
                  : AppCachedImage(
                      imageUrl: thumbnailUrl,
                      width: previewSize,
                      height: previewSize,
                      fit: BoxFit.cover,
                      onTap: () {},
                    ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  style,
                  style: TextStyle(
                    fontSize: 15,
                    color: highlightStyle
                        ? AppPalette.textSecondary
                        : AppPalette.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppPalette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
