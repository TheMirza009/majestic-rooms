import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/booking/booking_controller.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/date_range/date_range_selection_card.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/room_card.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/room_widgets/book_now_button.dart';

class RoomsScreen extends StatelessWidget {
  final Hotel hotel;

  const RoomsScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    // Initialize the BookingController for this specific hotel
    final controller = Get.put(BookingController(hotel: hotel));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (controller.selectedRooms.isEmpty) {
          Navigator.pop(context);
          return;
        }

        final shouldCancel = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Discard Selections?"),
            content: const Text("Are you sure you want to go back? Your room selections and dates will be reset."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Keep Editing"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Discard", style: TextStyle(color: CustomColors.brandRed)),
              ),
            ],
          ),
        );

        if (shouldCancel == true) {
          controller.clearState();
          if (context.mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
        // backgroundColor: CustomColors.background,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Select Rooms",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.maybePop(context),
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
      floatingActionButton: BookNowButton(controller: controller),
    ),
  );
  }
}
