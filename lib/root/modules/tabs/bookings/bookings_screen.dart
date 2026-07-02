import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/tabs/bookings/booking_card.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommonController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        surfaceTintColor: const Color(0xFFF7F7F9),
        centerTitle: true,
        title: const Text(
          'My Bookings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        // EMPTY STATE
        if (controller.bookings.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bookmark_border_rounded,
                  size: 56,
                  color: CustomColors.hintColor,
                ),
                SizedBox(height: 16),
                Text(
                  'No bookings yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.textMain,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Your confirmed reservations will appear here.',
                  style: TextStyle(
                    fontSize: 13,
                    color: CustomColors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // LIST — newest first
        final bookings = controller.bookings.reversed.toList();
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          physics: const BouncingScrollPhysics(),
          itemCount: bookings.length,
          itemBuilder: (_, index) => BookingCard(booking: bookings[index]),
        );
      }),
    );
  }
}