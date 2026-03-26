import '/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final AppBar? appBar;
  final Widget? drawer;
  final bool removePadding;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool rectangularBackButton;
  final Color? backButtonBackgroundColor;
  final Color? backButtonIconColor;
  final bool? isUnfocus;
  final double backButtonSize;

  const AppScaffold({
    super.key,
    this.appBar,
    this.backgroundColor = AppColors.white,
    this.drawer,
    required this.body,
    this.removePadding = false,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.rectangularBackButton = true,
    this.backButtonBackgroundColor,
    this.backButtonIconColor,
    this.isUnfocus = true,
    this.backButtonSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: drawer,
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(removePadding ? 0 : 16),
          child: GestureDetector(
            onTap: () =>
                isUnfocus == false ? {} : FocusScope.of(context).unfocus(),
            child: body,
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
