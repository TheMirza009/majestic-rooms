import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/booking/booking_controller.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/date_range_selection_card.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/room_card.dart';

class RoomsScreen extends StatelessWidget {
  final Hotel hotel;

  const RoomsScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    // Initialize the BookingController for this specific hotel
    final controller = Get.put(BookingController(hotel: hotel));

    return Scaffold(
      // backgroundColor: CustomColors.background,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Select Rooms",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const DateRangeSelectionCard(),
            SizedBox(height: 8),
            Expanded(
              child: hotel.rooms.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.meeting_room_outlined, size: 64, color: CustomColors.hintColor),
                          SizedBox(height: 16),
                          Text(
                            "No rooms available",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 0.0, bottom: 120.0), // padding for FAB
                      itemCount: hotel.rooms.length,
                      itemBuilder: (context, index) {
                        final room = hotel.rooms[index];
                        return Obx(() {
                          return RoomCard(
                            room: room,
                            quantity: controller.getRoomQuantity(room),
                            onIncrement: () => controller.incrementRoom(room),
                            onDecrement: () => controller.decrementRoom(room),
                          );
                        });
                      },
                    ),
            ),
          ],
        ),
      ),
      
      // FLOATING ACTION BUTTON
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
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
                        children: const [
                          Text(
                            "Book Now",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white),
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
      }),
    );
  }
}
