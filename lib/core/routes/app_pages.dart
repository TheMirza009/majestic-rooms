import 'package:get/get.dart';
import 'package:majestic_rooms/core/routes/app_routes.dart';
import 'package:majestic_rooms/root/modules/auth/login_binding.dart';
import 'package:majestic_rooms/root/modules/auth/login_screen.dart';
import 'package:majestic_rooms/root/modules/auth/signup_screen.dart';
import 'package:majestic_rooms/root/modules/home/home_binding.dart';
import 'package:majestic_rooms/root/modules/home/home_screen.dart';

/// Maps each route name to its page and its (lazy) controller binding.
class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
