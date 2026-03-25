import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/moduls/home/controllers/home_controller.dart';
import 'package:cembostyle/core/navigation/bottom_nav_bar.dart';
import 'package:cembostyle/moduls/home/presentation/screens/home_flow/home_screen.dart';
import 'package:cembostyle/moduls/home/presentation/screens/profile_screen.dart';
import 'package:cembostyle/moduls/stencil/presentation/screens/stencil_tab_screen.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return AppScaffold(
      removePadding: true,
      body: Obx(() {
        return IndexedStack(
          index: controller.bottomNavIndex.value,
          children: const [HomeScreen(), StencilScreen(), ProfileScreen()],
        );
      }),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
