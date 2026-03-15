// import '/core/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final Future<void> Function()? onApiPressed; // For API calls (with loading)
  final VoidCallback? onSimplePressed; // For navigation/local actions
  final String? tag;
  final String text;

  final Widget? iconLeft;
  final Widget? iconRight;

  final double? width;
  final double? height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final bool isGradient;

  const PrimaryButton({
    super.key,
    this.onApiPressed,
    this.onSimplePressed,
    this.tag,
    required this.text,
    this.iconLeft,
    this.iconRight,
    this.width,
    this.height = 50,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.borderRadius = 100,
    this.isGradient = false,
  });

  String get _uniqueTag => tag ?? text;

  @override
  Widget build(BuildContext context) {
    final isLoading = Get.put(false.obs, tag: _uniqueTag);

    return GestureDetector(
      onTap: onApiPressed != null
          ? () async {
              if (isLoading.value) return;
              isLoading.value = true;

              try {
                await onApiPressed!();
              } catch (e) {
                Get.snackbar(
                  "Error",
                  e.toString(),
                  backgroundColor: Colors.red[600],
                  colorText: Colors.white,
                );
              } finally {
                isLoading.value = false;
                // Optional: auto cleanup after 10 sec
                Future.delayed(const Duration(seconds: 10), () {
                  if (Get.isRegistered<RxBool>(tag: _uniqueTag)) {
                    Get.delete<RxBool>(tag: _uniqueTag);
                  }
                });
              }
            }
          : onSimplePressed,
      child: Obx(() {
        return AbsorbPointer(
          absorbing: isLoading.value,
          child: Opacity(
            opacity: isLoading.value ? 0.6 : 1.0,
            child: Container(
              width: width ?? double.infinity,
              height: height ?? 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                gradient: isGradient ? LinearGradient(colors: [
                  Color(0xFF263451),
                  Color(0xFF00297E),
                  Color(0xFF263451),
                ]) : null,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: isLoading.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (iconLeft != null) ...[
                          iconLeft!,
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        if (iconRight != null) ...[
                          const SizedBox(width: 8),
                          iconRight!,
                        ],
                      ],
                    ),
            ),
          ),
        );
      }),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final Future<void> Function()? onApiPressed; // For API calls (with loading)
  final VoidCallback? onSimplePressed; // For navigation/local actions
  final String? tag;
  final String text;
  final double? width;
  final double? height;
  final Color borderColor;
  final Color textColor;
  final Color? backgroundColor;
  final double borderRadius;
  final double borderWidth;
  final Widget? iconLeft;
  final Widget? iconRight;

  const SecondaryButton({
    super.key,
    this.onApiPressed,
    this.onSimplePressed,
    this.tag,
    required this.text,
    this.width,
    this.height = 50,
    this.borderColor = AppColors.primary,
    this.textColor = AppColors.primary,
    this.backgroundColor,
    this.borderRadius = 100,
    this.borderWidth = 1.0,
    this.iconLeft,
    this.iconRight,
  });

  String get _uniqueTag => tag ?? text;

  @override
  Widget build(BuildContext context) {
    final isLoading = Get.put(false.obs, tag: _uniqueTag);

    return GestureDetector(
      onTap: onApiPressed != null
          ? () async {
              if (isLoading.value) return;
              isLoading.value = true;

              try {
                await onApiPressed!();
              } catch (e) {
                Get.snackbar(
                  "Error",
                  e.toString(),
                  backgroundColor: Colors.red[600],
                  colorText: Colors.white,
                );
              } finally {
                isLoading.value = false;
                // Optional: auto cleanup after 10 sec
                Future.delayed(const Duration(seconds: 10), () {
                  if (Get.isRegistered<RxBool>(tag: _uniqueTag)) {
                    Get.delete<RxBool>(tag: _uniqueTag);
                  }
                });
              }
            }
          : onSimplePressed,
      child: Obx(() {
        return AbsorbPointer(
          absorbing: isLoading.value,
          child: Opacity(
            opacity: isLoading.value ? 0.6 : 1.0,
            child: Container(
              width: width ?? double.infinity,
              height: height ?? 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: borderColor, width: borderWidth),
              ),
              child: isLoading.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (iconLeft != null) ...[
                    iconLeft!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  if (iconRight != null) ...[
                    const SizedBox(width: 8),
                    iconRight!,
                  ],
                ],
              )
            ),
          ),
        );
      }),
    );
  }
}
