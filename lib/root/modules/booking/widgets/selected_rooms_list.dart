import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/booking/booking_controller.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/summary_card.dart';

/// Reactive list of selected rooms. Renders nothing when the selection is empty.
class SelectedRoomsList extends StatelessWidget {
  const SelectedRoomsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    return Obx(() {
      final rooms = controller.selectedRooms;
      if (rooms.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          const Text(
            'Selected Rooms',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: CustomColors.textMain,
            ),
          ),
          const SizedBox(height: 10),
          // ROOM LIST
          ...rooms.entries.map((entry) {
            final room = entry.key;
            final qty = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SummaryCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: CustomColors.brandRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.king_bed_outlined,
                        size: 22,
                        color: CustomColors.brandRed,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.name ?? room.category?.name ?? 'Standard Room',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.textMain,
                            ),
                          ),
                          if (room.roomNumber != null)
                            Text(
                              'Room ${room.roomNumber}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: CustomColors.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'x$qty',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.textMuted,
                          ),
                        ),
                        Text(
                          formatPrice(room.pricePerNight * qty),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: CustomColors.brandRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      );
    });
  }
}
