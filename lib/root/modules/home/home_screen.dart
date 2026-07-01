import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/helper.dart';
import 'package:majestic_rooms/root/modules/home/home_controller.dart';
import 'package:majestic_rooms/root/modules/home/widgets/glass_bottom_nav.dart';
import 'package:majestic_rooms/root/modules/tabs/bookings/bookings_screen.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/explore_screen.dart';
import 'package:majestic_rooms/root/modules/tabs/profile/profile_screen.dart';
import 'package:majestic_rooms/root/modules/tabs/saved/saved_screen.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldPop = await controller.handleBackPress();
          if (shouldPop) {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          extendBody: true,
          backgroundColor: CustomColors.cardSubtleBg,
          // appBar: buildAppBar(controller, context),
          body: SafeArea(
          bottom: false,
            child: PageView(
              controller: controller.pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: controller.onPageChanged,
              allowImplicitScrolling: true,
              children: const [
                ExploreScreen(),
                SavedScreen(),
                BookingsScreen(),
                ProfileScreen(),
              ],
            ),
          ),
          bottomNavigationBar: GlassBottomNavBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.navigateTo,
          ),
        ),
      ),
    ));
  }
}

AppBar? buildAppBar(HomeController controller, BuildContext context) {
  const _titles = ['Explore', 'Saved', 'Bookings', 'Profile'];
  if (controller.currentIndex.value != 3) {
    return null;
  }

  return AppBar(
    title: Text(_titles[controller.currentIndex.value]),
    actions: [
      IconButton(
        onPressed: Utils.logoutDialog,
        icon: const Icon(Icons.logout),
      ),
    ],
  );
}
