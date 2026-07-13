import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:majestic_rooms/core/data/models/booking.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/booking/booking_controller.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/summary_widgets/price_breakdown.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/summary_widgets/selected_rooms_list.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/summary_widgets/summary_card.dart';

// ── Shared style constants ────────────────────────────────────────────────────
const _labelStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.8,
  color: CustomColors.textMuted,
);
const _valueStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w700,
  color: CustomColors.textMain,
);
const _subValueStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: CustomColors.textMuted,
);
const _sectionTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: CustomColors.textMain,
);

class BookingScreenshotWidget extends StatelessWidget {
  final bool isPaid;
  final BookingModel? booking;

  const BookingScreenshotWidget({
    super.key,
    required this.isPaid,
    this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final controller = isPaid ? null : Get.find<BookingController>();
    final effectiveHotel = isPaid ? booking!.hotel : controller!.hotel;
    final heroImage = effectiveHotel.images.isNotEmpty ? effectiveHotel.images.first.url : null;

    return Container(
      color: const Color(0xFFF7F7F9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER (Title)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: const Color(0xFFF7F7F9),
            child: Text(
              'Booking Summary'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.textMain,
              ),
            ),
          ),

          // HOTEL HERO IMAGE
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // HOTEL IMAGE
                  heroImage != null
                      ? CachedNetworkImage(
                          imageUrl: heroImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const ColoredBox(color: CustomColors.cardSubtleBg),
                          errorWidget: (context, url, error) =>
                              const ColoredBox(
                            color: CustomColors.cardSubtleBg,
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: CustomColors.hintColor,
                              size: 48,
                            ),
                          ),
                        )
                      : const ColoredBox(color: CustomColors.cardSubtleBg),
                  // GRADIENT OVERLAY
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x00000000),
                          Color(0x99000000),
                        ],
                        stops: [0.4, 1.0],
                      ),
                    ),
                  ),
                  // HOTEL NAME + LOCATION OVERLAY
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          effectiveHotel.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        if (effectiveHotel.address != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: Color(0xCCFFFFFF),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  effectiveHotel.address!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xCCFFFFFF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CONTENT PADDING
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // STAY DETAILS TITLE
                Text('Stay Details'.tr, style: _sectionTitleStyle),
                const SizedBox(height: 10),

                // STAY DETAILS GRID
                if (isPaid && booking != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CHECK-IN'.tr, style: _labelStyle),
                              const SizedBox(height: 6),
                              Text(
                                DateFormat('MMM dd, yyyy', Get.locale?.languageCode).format(booking!.checkInDate),
                                style: _valueStyle,
                              ),
                              const SizedBox(height: 2),
                              Text('After 02:00 PM'.tr, style: _subValueStyle),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SummaryCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CHECK-OUT'.tr, style: _labelStyle),
                              const SizedBox(height: 6),
                              Text(
                                DateFormat('MMM dd, yyyy', Get.locale?.languageCode).format(booking!.checkOutDate),
                                style: _valueStyle,
                              ),
                              const SizedBox(height: 2),
                              Text('Before 11:00 AM'.tr, style: _subValueStyle),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: CustomColors.brandRed.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.nightlight_round,
                                  size: 18,
                                  color: CustomColors.brandRed,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('DURATION'.tr, style: _labelStyle),
                                  const SizedBox(height: 2),
                                  Text(
                                    booking!.nights == 1
                                        ? 'night_count'.trParams({'count': booking!.nights.toString()})
                                        : 'nights_count'.trParams({'count': booking!.nights.toString()}),
                                    style: _valueStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SummaryCard(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: CustomColors.brandRed.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.person_outline_rounded,
                                  size: 18,
                                  color: CustomColors.brandRed,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ROOMS'.tr, style: _labelStyle),
                                  const SizedBox(height: 2),
                                  Text(
                                    booking!.numberOfRooms == 1
                                        ? 'room_count'.trParams({'count': booking!.numberOfRooms.toString()})
                                        : 'rooms_count'.trParams({'count': booking!.numberOfRooms.toString()}),
                                    style: _valueStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Obx(() {
                    final dateRange = controller!.dateRange.value;
                    final checkInStr = dateRange != null ? DateFormat('MMM dd, yyyy', Get.locale?.languageCode).format(dateRange.start) : 'Not selected'.tr;
                    final checkOutStr = dateRange != null ? DateFormat('MMM dd, yyyy', Get.locale?.languageCode).format(dateRange.end) : 'Not selected'.tr;
                    final nights = controller.nights;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('CHECK-IN'.tr, style: _labelStyle),
                                    const SizedBox(height: 6),
                                    Text(checkInStr, style: _valueStyle),
                                    const SizedBox(height: 2),
                                    Text('After 02:00 PM'.tr, style: _subValueStyle),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SummaryCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('CHECK-OUT'.tr, style: _labelStyle),
                                    const SizedBox(height: 6),
                                    Text(checkOutStr, style: _valueStyle),
                                    const SizedBox(height: 2),
                                    Text('Before 11:00 AM'.tr, style: _subValueStyle),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: CustomColors.brandRed.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.nightlight_round,
                                        size: 18,
                                        color: CustomColors.brandRed,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('DURATION'.tr, style: _labelStyle),
                                        const SizedBox(height: 2),
                                        Text(
                                          nights == 1
                                              ? 'night_count'.trParams({'count': nights.toString()})
                                              : 'nights_count'.trParams({'count': nights.toString()}),
                                          style: _valueStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SummaryCard(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: CustomColors.brandRed.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.person_outline_rounded,
                                        size: 18,
                                        color: CustomColors.brandRed,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('ROOMS'.tr, style: _labelStyle),
                                        const SizedBox(height: 2),
                                        Text(
                                          controller.totalQuantity == 1
                                              ? 'room_count'.trParams({'count': controller.totalQuantity.toString()})
                                              : 'rooms_count'.trParams({'count': controller.totalQuantity.toString()}),
                                          style: _valueStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
                const SizedBox(height: 20),

                // SELECTED ROOMS
                SelectedRoomsList(booking: isPaid ? booking : null),

                // PRICE BREAKDOWN
                if (isPaid && booking != null) ...[
                  Text('Price Details'.tr, style: _sectionTitleStyle),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CustomColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal'.tr, style: const TextStyle(fontSize: 13, color: CustomColors.textMuted)),
                            Text(formatPrice(booking!.grossTotal), style: const TextStyle(fontSize: 13, color: CustomColors.textMain)),
                          ],
                        ),
                        if (booking!.discount > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Discount'.tr, style: const TextStyle(fontSize: 13, color: Color(0xFF2E7D32))),
                              Text('- ${formatPrice(booking!.discount)}', style: const TextStyle(fontSize: 13, color: Color(0xFF2E7D32))),
                            ],
                          ),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Paid'.tr, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: CustomColors.textMain)),
                            Text(formatPrice(booking!.netTotal), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: CustomColors.brandRed)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ] else ...[
                  Text('Price Details'.tr, style: _sectionTitleStyle),
                  const SizedBox(height: 10),
                  const PriceBreakdown(),
                  const SizedBox(height: 20),
                ],

                // CANCELLATION POLICY
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CustomColors.brandRed.withOpacity(0.04),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: CustomColors.brandRed.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: 20,
                          color: CustomColors.brandRed,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cancellation Policy'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: CustomColors.textMain,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              effectiveHotel.terms ??
                                  'free_cancellation_fallback'.tr,
                              style: const TextStyle(
                                fontSize: 13,
                                color: CustomColors.textMuted,
                                height: 1.5,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // STATUS BANNER (if paid)
                if (isPaid && booking != null) ...[
                  const SizedBox(height: 20),
                  if (booking!.bookingStatus == BookingStatus.cancelled)
                    Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: CustomColors.brandRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cancel_rounded, size: 20, color: CustomColors.brandRed),
                          const SizedBox(width: 8),
                          Text(
                            'Cancelled'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: CustomColors.brandRed,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                        ),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2E7D32).withOpacity(0.30),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              size: 20, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Paid'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
