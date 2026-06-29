import 'package:get/get.dart';

class HomeController extends GetxController {
  // ── Fields ───────────────────────────────────────────────────────────────
  final currentIndex = 0.obs;

  // ── Navigation ───────────────────────────────────────────────────────────
  void navigateTo(int index) => currentIndex.value = index;
}
