import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/booking/booking_controller.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/summary_widgets/summary_card.dart';

/// Reactive price breakdown card: subtotal, service fee, taxes, and total.
class PriceBreakdown extends StatelessWidget {
  const PriceBreakdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    return Obx(() {
      final subtotal = controller.totalPrice;
      final serviceFee = subtotal * 0.10;
      final taxes = subtotal * 0.072;
      final total = subtotal + serviceFee + taxes;
      return SummaryCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _PriceRow(
              label: '${controller.totalQuantity} room(s) × ${controller.nights} night${controller.nights == 1 ? '' : 's'}',
              amount: formatPrice(subtotal),
            ),
            const SizedBox(height: 12),
            // SERVICE FEE ROW
            _PriceRow(label: 'Service fee', amount: formatPrice(serviceFee)),
            const SizedBox(height: 12),
            // TAXES ROW
            _PriceRow(label: 'Occupancy taxes', amount: formatPrice(taxes)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Divider(height: 1, color: Color(0xFFE5E7EB)),
            ),
            // TOTAL ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.textMain,
                  ),
                ),
                Text(
                  formatPrice(total),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: CustomColors.brandRed,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String? amount;

  const _PriceRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: CustomColors.textMuted),
        ),
        if (amount != null)
          Text(
            amount!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: CustomColors.textMain,
            ),
          ),
      ],
    );
  }
}
