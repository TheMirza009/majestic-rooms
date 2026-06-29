import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/root/modules/home/home_controller.dart';

/// Wires up app-wide dependencies before the first route is shown.
/// Both controllers are permanent so they survive every navigation.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CommonController>(CommonController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}
