import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // ── Fields ───────────────────────────────────────────────────────────────
  final currentIndex = 0.obs;
  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex.value);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // ── Navigation ───────────────────────────────────────────────────────────
  void navigateTo(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
