import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeController extends GetxController {
  // ── Fields ───────────────────────────────────────────────────────────────
  final currentIndex = 0.obs;
  late PageController pageController;

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
    // currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void resetToTab(int index) {
    currentIndex.value = index;
    pageController = PageController(initialPage: index);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  // ── Back Navigation ──────────────────────────────────────────────────────
  DateTime? _lastBackPressTime;

  Future<bool> handleBackPress() async {
    // 1. If not on the first tab (Explore), go to Explore
    if (currentIndex.value != 0) {
      navigateTo(0);
      return false; // Do not exit
    }

    // 2. If on Explore, check time since last back press
    final now = DateTime.now();
    final isWarningActive = _lastBackPressTime != null && 
                            now.difference(_lastBackPressTime!) < const Duration(seconds: 3);

    if (isWarningActive) {
      // 3. Exiting app
      return true;
    } else {
      // Show warning toast
      _lastBackPressTime = now;
      Fluttertoast.showToast(
        msg: "Press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        // backgroundColor: const Color(0xFF2E2E2E),
        textColor: Colors.white,
      );
      return false; // Do not exit yet
    }
  }
}
