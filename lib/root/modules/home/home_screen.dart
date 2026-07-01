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
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && controller.currentIndex.value != 0) {
            controller.onPageChanged(0);
          }
        },
        child: Scaffold(
          extendBody: true,
          backgroundColor: CustomColors.cardSubtleBg,
          // appBar: buildAppBar(controller, context),
          body: SafeArea(
          bottom: false,
            child: NotificationListener<ScrollUpdateNotification>(
              onNotification: (notification) {
                if (notification.depth == 0) {
                  final page = controller.pageController.page?.round();
                  if (page != null && page != controller.currentIndex.value) {
                    controller.onPageChanged(page);
                  }
                }
                return false;
              },
              child: LayoutBuilder(
                builder: (context, constraints) => CustomScrollView(
                  controller: controller.pageController,
                  scrollDirection: Axis.horizontal,
                  physics: const PageScrollPhysics(),
                  cacheExtent: constraints.maxWidth * 4,
                  slivers: [
                    SliverFillViewport(
                      delegate: SliverChildListDelegate(const [
                        ExploreScreen(),
                        SavedScreen(),
                        BookingsScreen(),
                        ProfileScreen(),
                      ]),
                    ),
                  ],
                ),
              ),
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
