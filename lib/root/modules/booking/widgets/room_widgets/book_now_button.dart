
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/booking/booking_controller.dart';

class BookNowButton extends StatelessWidget {
  const BookNowButton({
    super.key,
    required this.controller,
  });

  final BookingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasSelection = controller.selectedRooms.isNotEmpty;
      final total = controller.totalPrice;
      
      return AnimatedSlide(
        offset: hasSelection ? Offset.zero : const Offset(0, 2.0),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: FloatingActionButton.extended(
              heroTag: 'book_now_fab',
              onPressed: controller.proceedToNextStep,
              backgroundColor: CustomColors.brandRed,
              elevation: 6,
              shape: const StadiumBorder(),
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Book Now".tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white),
                      ],
                    ),
                    const SizedBox(width: 24), // Spacer
                    Text(
                      formatPrice(total),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
