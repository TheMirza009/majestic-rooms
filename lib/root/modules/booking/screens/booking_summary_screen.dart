import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/booking/booking_controller.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/price_breakdown.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/selected_rooms_list.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/summary_card.dart';
import 'package:majestic_rooms/root/widgets/round_icon_button.dart';

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
  const BookingSummaryScreen({super.key});

  void _onConfirmBooking() {
    Get.snackbar(
      'Booking Confirmed',
      'Your reservation has been submitted successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2E2E2E),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final hotel = controller.hotel;
    final heroImage = hotel.images.isNotEmpty ? hotel.images.first.url : null;
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
        leading: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: RoundIconButton(
              size: 44,
              backgroundColor: CustomColors.cardSubtleBg,
              icon: const Padding(
                padding: EdgeInsets.only(right: 3.0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: CustomColors.textMain,
                  size: 20,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ),
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
                                hotel.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              if (hotel.address != null) ...[
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
                                        hotel.address!,
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
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => controller.selectDateRange(context),
                          child: const Text('Edit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: CustomColors.brandRed)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      final dateRange = controller.dateRange.value;
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
                    const SelectedRoomsList(),
                    
                    // PRICE BREAKDOWN
                    const Text('Price Details', style: _sectionTitleStyle),
                    const SizedBox(height: 10),
                    const PriceBreakdown(),
                    const SizedBox(height: 20),

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
                                  hotel.terms ??
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
              child: Obx(() {
                final subtotal = controller.totalPrice;
                final total = subtotal * 1.172; // 10% service + 7.2% taxes
                return Row(
                  children: [
                    
                    // BOOK NOW BUTTON
                    Expanded(
                      child: GestureDetector(
                        onTap: _onConfirmBooking,
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                            color: CustomColors.brandRed,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: CustomColors.brandRed.withOpacity(0.30),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
}
