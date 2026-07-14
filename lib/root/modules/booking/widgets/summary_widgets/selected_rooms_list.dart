import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/booking/booking_controller.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/summary_widgets/summary_card.dart';

import 'package:majestic_rooms/core/data/models/booking.dart';

/// Reactive list of selected rooms. Renders nothing when the selection is empty.
/// Can optionally accept a [BookingModel] to render static data in paid mode.
class SelectedRoomsList extends StatelessWidget {
  const SelectedRoomsList({super.key, this.booking});

  final BookingModel? booking;

  @override
  Widget build(BuildContext context) {
    if (booking != null) {
      if (booking!.details.isEmpty) return const SizedBox.shrink();
      return _buildList(
        context,
        items: booking!.details
            .map(
              (item) => _RoomItemData(
                name: item.roomName ?? 'Standard Room'.tr,
                roomNumber: null,
                qty: item.quantity,
                totalPrice: item.grossAmount,
              ),
            )
            .toList(),
      );
    }

    final controller = Get.find<BookingController>();
    return Obx(() {
      final rooms = controller.selectedRooms;
      final nights = controller.nights;
      if (rooms.isEmpty) return const SizedBox.shrink();
      return _buildList(
        context,
        items: rooms.entries.map((entry) {
          final room = entry.key;
          final qty = entry.value;
          return _RoomItemData(
            name: room.name ?? room.category?.name ?? 'Standard Room'.tr,
            roomNumber: room.roomNumber,
            qty: qty,
            totalPrice: room.pricePerNight * qty * nights,
          );
        }).toList(),
      );
    });
  }

  Widget _buildList(
    BuildContext context, {
    required List<_RoomItemData> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        Text(
          'Selected Rooms'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: context.textMainColor,
          ),
        ),
        const SizedBox(height: 10),
        // ROOM LIST
        ...items.map((item) {
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
                      color: context.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.king_bed_outlined,
                      size: 22,
                      color: context.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.textMainColor,
                          ),
                        ),
                        if (item.roomNumber != null)
                          Text(
                            'Room @number'.trParams({
                              'number': item.roomNumber!,
                            }),
                            style: TextStyle(
                              fontSize: 12,
                              color: context.textMutedColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'x${item.qty}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.textMutedColor,
                        ),
                      ),
                      Text(
                        formatPrice(item.totalPrice),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: context.primaryColor,
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
  }
}

class _RoomItemData {
  final String name;
  final String? roomNumber;
  final int qty;
  final num totalPrice;

  _RoomItemData({
    required this.name,
    this.roomNumber,
    required this.qty,
    required this.totalPrice,
  });
}
