import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:majestic_rooms/core/data/models/hotel_room.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/booking/screens/booking_summary_screen.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/date_range/custom_date_range_picker.dart';

class BookingController extends GetxController {
  final Hotel hotel;
  
  // Track selected rooms and their quantities
  final RxMap<HotelRoom, int> selectedRooms = <HotelRoom, int>{}.obs;

  // Date range
  final Rx<DateTimeRange?> dateRange = Rx<DateTimeRange?>(null);

  BookingController({required this.hotel});

  int getRoomQuantity(HotelRoom room) {
    return selectedRooms[room] ?? 0;
  }

  void incrementRoom(HotelRoom room) {
    final current = selectedRooms[room] ?? 0;
    selectedRooms[room] = current + 1;
  }

  void decrementRoom(HotelRoom room) {
    final current = selectedRooms[room] ?? 0;
    if (current > 1) {
      selectedRooms[room] = current - 1;
    } else {
      selectedRooms.remove(room);
    }
  }

  int get nights {
    if (dateRange.value == null) return 1;
    final duration = dateRange.value!.end.difference(dateRange.value!.start).inDays;
    return duration == 0 ? 1 : duration;
  }

  double get totalPrice {
    return selectedRooms.entries.fold(
      0.0,
      (sum, entry) => sum + (entry.key.pricePerNight * entry.value * nights),
    );
  }

  int get totalQuantity {
    return selectedRooms.values.fold(0, (sum, count) => sum + count);
  }

  void selectDateRange(BuildContext context) {
    final DateTime now = DateTime.now();
    
    showCustomDateRangePicker(
      context,
      dismissible: true,
      minimumDate: now,
      maximumDate: now.add(const Duration(days: 365)),
      startDate: dateRange.value?.start,
      endDate: dateRange.value?.end,
      backgroundColor: CustomColors.surfaceWhite,
      primaryColor: CustomColors.brandRed,
      onApplyClick: (start, end) {
        dateRange.value = DateTimeRange(start: start, end: end);
      },
      onCancelClick: () {
        // Option 1: Clear the date range
        // dateRange.value = null;
        
        // Option 2: Do nothing on cancel to preserve existing selection
      },
    );
  }

  void proceedToNextStep() {
    if (selectedRooms.isEmpty) return;
    
    // Future implementation: Navigate to Guest Details Screen
    Navigator.push(Get.context!, CupertinoPageRoute(builder: (_) => BookingSummaryScreen()));
    Get.snackbar(
      "Rooms Selected",
      "Proceeding to checkout for $totalQuantity room(s) for $nights night(s). Total: \$${totalPrice.toStringAsFixed(2)}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2E2E2E),
      colorText: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
