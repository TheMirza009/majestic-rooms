import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:majestic_rooms/core/data/models/booking.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/booking/screens/booking_summary_screen.dart';
import 'package:get/get.dart';

// ── Shared style constants ─────────────────────────────────────────────────────
const _labelStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.5,
  color: CustomColors.textMuted,
);


class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking});

  final BookingModel booking;

  // ── Status badge helpers ───────────────────────────────────────────────────

  Color _badgeBg(BookingStatus status) => switch (status) {
        BookingStatus.confirmed  => const Color(0x1A2E7D32),
        BookingStatus.cancelled  => const Color(0x1A7A2021),
        BookingStatus.checkedIn  => const Color(0x1A1565C0),
        BookingStatus.completed  => const Color(0x1A555555),
        BookingStatus.pending    => const Color(0x1AC67700),
      };

  Color _badgeFg(BookingStatus status) => switch (status) {
        BookingStatus.confirmed  => const Color(0xFF2E7D32),
        BookingStatus.cancelled  => CustomColors.brandRed,
        BookingStatus.checkedIn  => const Color(0xFF1565C0),
        BookingStatus.completed  => const Color(0xFF555555),
        BookingStatus.pending    => const Color(0xFFC67700),
      };

  String _badgeLabel(BookingStatus status) => switch (status) {
        BookingStatus.confirmed  => 'Confirmed'.tr,
        BookingStatus.cancelled  => 'Cancelled'.tr,
        BookingStatus.checkedIn  => 'Checked In'.tr,
        BookingStatus.completed  => 'Completed'.tr,
        BookingStatus.pending    => 'Pending'.tr,
      };

  @override
  Widget build(BuildContext context) {
    final checkIn  = DateFormat('MMM dd', Get.locale?.languageCode).format(booking.checkInDate);
    final checkOut = DateFormat('MMM dd, yyyy', Get.locale?.languageCode).format(booking.checkOutDate);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => BookingSummaryScreen(
            isPaid: true,
            booking: booking,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: CustomColors.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HOTEL IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl: booking.hotelImageUrl ?? 'https://picsum.photos/600/400',
                width: 90,
                height: 110,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const ColoredBox(color: CustomColors.cardSubtleBg),
                errorWidget: (context, url, error) => const ColoredBox(
                  color: CustomColors.cardSubtleBg,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: CustomColors.hintColor,
                  ),
                ),
              ),
            ),
            // DETAILS
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel name + status badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            booking.hotelName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: CustomColors.textMain,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // STATUS BADGE
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _badgeBg(booking.bookingStatus),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _badgeLabel(booking.bookingStatus),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _badgeFg(booking.bookingStatus),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Date range
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: CustomColors.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '$checkIn → $checkOut',
                          style: _labelStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Nights · rooms
                    Row(
                      children: [
                        const Icon(
                          Icons.nightlight_round,
                          size: 12,
                          color: CustomColors.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'nights_rooms_dot'.trParams({
                            'nights': booking.nights.toString(),
                            'rooms': booking.numberOfRooms.toString()
                          }),
                          style: _labelStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Total
                    Text(
                      formatPrice(booking.netTotal),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: CustomColors.brandRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // CHEVRON
            const Padding(
              padding: EdgeInsets.only(right: 12, top: 44),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: CustomColors.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
