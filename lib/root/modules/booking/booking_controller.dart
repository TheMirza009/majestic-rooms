import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:majestic_rooms/core/data/models/hotel_room.dart';

class BookingController extends GetxController {
  final Hotel hotel;
  
  // Track selected rooms and their quantities
  final RxMap<HotelRoom, int> selectedRooms = <HotelRoom, int>{}.obs;

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

  double get totalPrice {
    return selectedRooms.entries.fold(
      0.0,
      (sum, entry) => sum + (entry.key.pricePerNight * entry.value),
    );
  }

  int get totalQuantity {
    return selectedRooms.values.fold(0, (sum, count) => sum + count);
  }

  void proceedToNextStep() {
    if (selectedRooms.isEmpty) return;
    
    // Future implementation: Navigate to Guest Details Screen
    Get.snackbar(
      "Rooms Selected",
      "Proceeding to checkout for $totalQuantity room(s). Total: \$${totalPrice.toStringAsFixed(2)}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2E2E2E),
      colorText: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
