import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../shimmer/shimmer_loader.dart';

class AppCachedImage extends StatelessWidget {
  final String? imageUrl; // network image
  final File? imageFile;  // local image (picked)
  final ColorFilter? colorFilter;
  final double? width;
  final double? height;
  final BoxFit fit;
  final IconData icon;
  final Color iconColor;
  final BorderRadius? borderRadius;
  final VoidCallback onTap;

  const AppCachedImage({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.colorFilter,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.icon = Icons.error,
    this.iconColor = Colors.red,
    this.borderRadius, required this.onTap,
  });

  // Helper: safely convert double to int for caching
  static int _safeToInt(double? value, {int fallback = 300}) {
    if (value == null || value.isNaN || value.isInfinite || value <= 0) {
      return fallback;
    }
    return value.round();
  }

  @override
  Widget build(BuildContext context) {
    Widget applyFilter(Widget child) {
      if (colorFilter == null) {
        return child;
      }

      return ColorFiltered(
        colorFilter: colorFilter!,
        child: child,
      );
    }

    // 1️⃣ If local image is provided, show it directly
    if (imageFile != null) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: applyFilter(
          Image.file(
            imageFile!,
            width: width,
            height: height,
            fit: fit,
          ),
        ),
      );
    }

    // 2️⃣ If network URL is null or empty, show placeholder
    if (imageUrl == null || imageUrl!.isEmpty) {
      return GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
                size: width != null && width!.isFinite ? width! * 0.5 : 50,
              ),
            ),
          ),
        ),
      );
    }

    // 3️⃣ Compute cache sizes
    final int cacheWidth = _safeToInt(width, fallback: 300);
    final int cacheHeight = _safeToInt(height, fallback: 450);
    final scale = MediaQuery.of(context).devicePixelRatio;
    final int scaledCacheWidth = (cacheWidth * scale).round().clamp(100, 800);
    final int scaledCacheHeight =
    (cacheHeight * scale).round().clamp(100, 1200);

    // 4️⃣ Display network image with caching and shimmer
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        memCacheWidth: scaledCacheWidth,
        memCacheHeight: scaledCacheHeight,
        maxWidthDiskCache: scaledCacheWidth,
        maxHeightDiskCache: scaledCacheHeight,
        width: width,
        height: height,
        fit: fit,
        imageBuilder: (context, imageProvider) => applyFilter(
          Image(
            image: imageProvider,
            width: width,
            height: height,
            fit: fit,
          ),
        ),
        placeholder: (context, url) => ShimmerLoader(
          isLoading: true,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: borderRadius,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: Icon(
            icon,
            color: iconColor,
            size: width != null && width!.isFinite ? width! * 0.5 : 50,
          ),
        ),
      ),
    );
  }
}
