import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:majestic_rooms/core/data/models/hotel_room.dart';
import 'package:majestic_rooms/core/data/models/booking.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/booking/screens/booking_summary_screen.dart';
import 'package:majestic_rooms/root/modules/booking/screens/booking_success_screen.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/date_range/custom_date_range_picker.dart';

class BookingController extends GetxController {
  final Hotel hotel;
  
  // Track selected rooms and their quantities
  final RxMap<HotelRoom, int> selectedRooms = <HotelRoom, int>{}.obs;

  // Date range
  late final Rx<DateTimeRange?> dateRange;

  BookingController({required this.hotel});

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    dateRange = Rx<DateTimeRange?>(DateTimeRange(start: today, end: tomorrow));
  }

  void clearState() {
    selectedRooms.clear();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    dateRange.value = DateTimeRange(start: today, end: tomorrow);
  }

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
    final DateTime today = DateTime(now.year, now.month, now.day);
    
    showCustomDateRangePicker(
      context,
      dismissible: true,
      minimumDate: today,
      maximumDate: today.add(const Duration(days: 365)),
      startDate: dateRange.value?.start,
      endDate: dateRange.value?.end,
      backgroundColor: CustomColors.surfaceWhite,
      primaryColor: CustomColors.brandRed,
      rangeColor: CustomColors.brandRed.withValues(alpha: 0.1),
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

  /// Finalizes the booking by sending data to Supabase.
  /// First checks if the hotel exists on the server to prevent orphans.
  /// If missing, falls back to a dummy local mode for UI continuity.
  Future<void> confirmBooking(BuildContext context) async {
    final booking = BookingModel.fromController(this);
    final commonController = Get.find<CommonController>();
    final supabase = Supabase.instance.client;

    try {
      // 1. Check if hotel exists on backend
      final hotelRow = await supabase
          .from('hotel')
          .select('slug')
          .eq('slug', booking.hotelSlug)
          .maybeSingle();

      if (hotelRow == null) {
        // Dummy local mode
        Get.snackbar('Local Mode', 'Hotel does not exist on the server. Proceeding in local mode.', snackPosition: SnackPosition.BOTTOM);
        commonController.addBooking(booking);
      } else {
        // Backend insert
        final result = await supabase
            .from('booking')
            .insert(booking.toInsertJson(accountId: supabase.auth.currentUser?.id))
            .select('id')
            .single();

        final serverId = result['id'] as String;
        
        await supabase
            .from('booking_detail')
            .insert(booking.detailsToInsertJson(serverId));

        // Refetch to maintain sync, or insert local with server ID
        commonController.addBooking(
          BookingModel(
            id: serverId,
            hotel: booking.hotel,
            hotelSlug: booking.hotelSlug,
            hotelName: booking.hotelName,
            hotelImageUrl: booking.hotelImageUrl,
            checkInDate: booking.checkInDate,
            checkOutDate: booking.checkOutDate,
            nights: booking.nights,
            numberOfRooms: booking.numberOfRooms,
            grossTotal: booking.grossTotal,
            discount: booking.discount,
            netTotal: booking.netTotal,
            bookingDate: booking.bookingDate,
            bookingStatus: booking.bookingStatus,
            details: booking.details,
          )
        );
      }

      if (context.mounted) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => BookingSuccessScreen(booking: booking),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ [BookingController] Failed to confirm booking: $e');
      if (context.mounted) {
         Get.snackbar('Error', 'Failed to confirm booking.', snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
