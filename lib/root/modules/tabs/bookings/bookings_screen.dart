import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
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
          itemCount: bookings.length + 2,
          itemBuilder: (_, index) {
            if (index < bookings.length) {
              return BookingCard(booking: bookings[index]);
            }
            if (index == bookings.length) {
              return const _DebugClearBookingsButton();
            }
            return const SizedBox(height: 100);
          },
        );
      }),
    );
  }
}

class _DebugClearBookingsButton extends StatelessWidget {
  const _DebugClearBookingsButton();

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: ElevatedButton.icon(
        onPressed: () async {
          debugPrint("CANCEL BOOKING CALLED");
          try {
            final supabase = Supabase.instance.client;
            final user = supabase.auth.currentUser;
            if (user == null) {
               Get.find<CommonController>().bookings.clear();
               Get.snackbar('Debug', 'Local bookings cleared (No user logged in).', snackPosition: SnackPosition.BOTTOM);
               return;
            }
            final userId = user.id;
            
            final userBookings = await supabase.from('booking').select('id').eq('account_id', userId);
            final List<String> bookingIds = (userBookings as List).map((b) => b['id'].toString()).toList();
            
            if (bookingIds.isNotEmpty) {
              await supabase.from('booking_detail').delete().inFilter('booking_id', bookingIds);
              await supabase.from('payment').delete().inFilter('booking_id', bookingIds);
              await supabase.from('booking').delete().inFilter('id', bookingIds);
            }
            
            Get.find<CommonController>().bookings.clear();
            if (context.mounted) {
              Get.snackbar(
                'Debug',
                'All bookings completely deleted from backend and app.',
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(16),
              );
            }
          } catch (e) {
            debugPrint('❌ [Debug] Failed to wipe bookings: $e');
            if (context.mounted) {
              Get.snackbar(
                'Error',
                'Failed to delete bookings: $e',
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(16),
              );
            }
          }
        },
        icon: const Icon(Icons.delete_forever),
        label: const Text('Clear All Bookings (Debug)'),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.brandRed,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
