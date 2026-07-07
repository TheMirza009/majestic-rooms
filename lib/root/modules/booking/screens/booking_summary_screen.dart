import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({
    super.key,
    this.isPaid = false,
    this.booking,
  });

  /// When true: read-only mode — shows a green "Paid" banner instead of
  /// the confirm button. Set by [BookingCard] when opening a past booking.
  final bool isPaid;

  /// The past booking to display in read-only mode. Required when [isPaid]
  /// is true. Provides the hotel object, dates, rooms and price data without
  /// needing [BookingController].
  final BookingModel? booking;



  @override
  Widget build(BuildContext context) {
    // In paid mode, BookingController may not be registered (different route
    // context), so only look it up when actually needed.
    final controller = isPaid ? null : Get.find<BookingController>();
    final effectiveHotel = isPaid ? booking!.hotel : controller!.hotel;
    final heroImage =
        effectiveHotel.images.isNotEmpty ? effectiveHotel.images.first.url : null;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        surfaceTintColor: const Color(0xFFF7F7F9),
        centerTitle: true,
        title: const Text(
          'Booking Summary',
           style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leadingWidth: 70,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.maybePop(context),
          ),
      ),
      body: Stack(
        children: [
          // SCROLLABLE CONTENT
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // HOTEL HERO IMAGE
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
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
              ),

              // BODY
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 140),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([

                    // STAY DETAILS GRID
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Stay Details', style: _sectionTitleStyle),
                        if (!isPaid)
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => controller!.selectDateRange(context),
                            child: const Text('Edit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: CustomColors.brandRed)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (isPaid) ...[
                      // PAID MODE — static date/rooms grid from BookingModel
                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('CHECK-IN', style: _labelStyle),
                                  const SizedBox(height: 6),
                                  Text(
                                    booking != null
                                        ? DateFormat('MMM dd, yyyy').format(booking!.checkInDate)
                                        : '—',
                                    style: _valueStyle,
                                  ),
                                  const SizedBox(height: 2),
                                  const Text('After 02:00 PM', style: _subValueStyle),
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
                                  const Text('CHECK-OUT', style: _labelStyle),
                                  const SizedBox(height: 6),
                                  Text(
                                    booking != null
                                        ? DateFormat('MMM dd, yyyy').format(booking!.checkOutDate)
                                        : '—',
                                    style: _valueStyle,
                                  ),
                                  const SizedBox(height: 2),
                                  const Text('Before 11:00 AM', style: _subValueStyle),
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
                                      const Text('DURATION', style: _labelStyle),
                                      const SizedBox(height: 2),
                                      Text(
                                        booking != null
                                            ? '${booking!.nights} Night${booking!.nights == 1 ? '' : 's'}'
                                            : '—',
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
                                      const Text('ROOMS', style: _labelStyle),
                                      const SizedBox(height: 2),
                                      Text(
                                        booking != null
                                            ? '${booking!.numberOfRooms} Room${booking!.numberOfRooms == 1 ? '' : 's'}'
                                            : '—',
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
                    ] else
                      Obx(() {
                        final dateRange = controller!.dateRange.value;
                        final checkInStr = dateRange != null ? DateFormat('MMM dd, yyyy').format(dateRange.start) : 'Not selected';
                        final checkOutStr = dateRange != null ? DateFormat('MMM dd, yyyy').format(dateRange.end) : 'Not selected';
                        final nights = controller.nights;
                        
                        return Column(
                          children: [
                            Row(
                              children: [
                                // CHECK-IN
                                Expanded(
                                  child: SummaryCard(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('CHECK-IN', style: _labelStyle),
                                        const SizedBox(height: 6),
                                        Text(checkInStr, style: _valueStyle),
                                        const SizedBox(height: 2),
                                        const Text('After 02:00 PM', style: _subValueStyle),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // CHECK-OUT
                                Expanded(
                                  child: SummaryCard(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('CHECK-OUT', style: _labelStyle),
                                        const SizedBox(height: 6),
                                        Text(checkOutStr, style: _valueStyle),
                                        const SizedBox(height: 2),
                                        const Text('Before 11:00 AM', style: _subValueStyle),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                // DURATION
                                Expanded(
                                  child: SummaryCard(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                CustomColors.brandRed.withOpacity(0.08),
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
                                            const Text('DURATION', style: _labelStyle),
                                            const SizedBox(height: 2),
                                            Text('$nights Night${nights == 1 ? '' : 's'}', style: _valueStyle),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                
                                // ROOMS COUNT
                                Expanded(
                                  child: SummaryCard(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: CustomColors.brandRed
                                                .withOpacity(0.08),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('ROOMS', style: _labelStyle),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${controller.totalQuantity} Room${controller.totalQuantity == 1 ? '' : 's'}',
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
                    const SizedBox(height: 20),

                    // SELECTED ROOMS
                    SelectedRoomsList(booking: isPaid ? booking : null),
                    
                    // PRICE BREAKDOWN
                    if (isPaid && booking != null) ...[
                      const Text('Price Details', style: _sectionTitleStyle),
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
                                const Text('Subtotal', style: TextStyle(fontSize: 13, color: CustomColors.textMuted)),
                                Text(formatPrice(booking!.grossTotal), style: const TextStyle(fontSize: 13, color: CustomColors.textMain)),
                              ],
                            ),
                            if (booking!.discount > 0) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Discount', style: TextStyle(fontSize: 13, color: Color(0xFF2E7D32))),
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
                                const Text('Total Paid', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: CustomColors.textMain)),
                                Text(formatPrice(booking!.netTotal), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: CustomColors.brandRed)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ] else if (!isPaid) ...[
                      const Text('Price Details', style: _sectionTitleStyle),
                      const SizedBox(height: 10),
                      const PriceBreakdown(),
                      const SizedBox(height: 20),
                    ],

                    // CANCELLATION POLICY
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CustomColors.brandRed.withOpacity(0.04),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
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
                                const Text(
                                  'Cancellation Policy',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: CustomColors.textMain,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  effectiveHotel.terms ??
                                      'Free cancellation before check-in date. Review our full terms before confirming.',
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
                    SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),

          // BOTTOM ACTION BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: CustomColors.surfaceWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: isPaid
                  // STATUS BANNER — paid read-only mode
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (booking!.bookingStatus == BookingStatus.cancelled)
                          Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: CustomColors.brandRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            alignment: Alignment.center,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cancel_rounded, size: 20, color: CustomColors.brandRed),
                                SizedBox(width: 8),
                                Text(
                                  'Cancelled',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: CustomColors.brandRed,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else ...[
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
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    size: 20, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Paid',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (booking!.bookingStatus != BookingStatus.completed) ...[
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () => _showCancelDialog(context, booking!),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                foregroundColor: CustomColors.brandRed,
                                side: const BorderSide(color: CustomColors.brandRed, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              ),
                              child: const Text('Cancel Booking', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                            ),
                          ],
                        ],
                      ],
                    )
                  // CONFIRM BUTTON — active booking mode
                  : Obx(() {
                      final subtotal = controller!.totalPrice;
                      final total = subtotal * 1.172; // 10% service + 7.2% taxes
                      return Row(
                        children: [
                          // BOOK NOW BUTTON
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.confirmBooking(context),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 54,
                                decoration: BoxDecoration(
                                  color: controller.isBooking.value ? Colors.grey : CustomColors.brandRed,
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: controller.isBooking.value ? [] : [
                                    BoxShadow(
                                      color: CustomColors.brandRed.withOpacity(0.30),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: controller.isBooking.value
                                      ? const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          key: ValueKey('booking'),
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Booking...',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          key: ValueKey('confirm'),
                                          children: [
                                            Text(
                                              'Confirm Booking',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            SizedBox(width: 6),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // TOTAL PRICE LABEL
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Total price',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: CustomColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formatPrice(total),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: CustomColors.textMain,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: CustomColors.surfaceWhite,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Cancel Booking?', style: TextStyle(fontWeight: FontWeight.w800)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to cancel this booking? Cancelling a booking may incur extra charges depending on the hotel policy.',
                style: TextStyle(color: CustomColors.textMuted, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CustomColors.brandRed.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CustomColors.brandRed.withOpacity(0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, color: CustomColors.brandRed, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking.hotel.terms ?? 'Free cancellation before check-in date. Review our full terms before confirming.',
                        style: const TextStyle(fontSize: 13, color: CustomColors.brandRed, fontWeight: FontWeight.w500, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(foregroundColor: CustomColors.textMuted),
              child: const Text('Keep Booking', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog immediately
                final tempController = Get.put(BookingController(hotel: booking.hotel));
                tempController.cancelBooking(booking, context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: CustomColors.brandRed.withOpacity(0.10)),
              child: const Text('Cancel Booking', style: TextStyle(color: CustomColors.brandRed, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
