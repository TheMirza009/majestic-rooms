import 'package:get/get.dart';
import 'package:majestic_rooms/root/modules/auth/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
