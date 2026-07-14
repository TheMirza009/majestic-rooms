import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/data/models/booking.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/booking/booking_controller.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/summary_widgets/price_breakdown.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/summary_widgets/selected_rooms_list.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/summary_widgets/summary_card.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/summary_widgets/booking_screenshot_widget.dart';

// ── Shared style constants ────────────────────────────────────────────────────
TextStyle _labelStyle(BuildContext context) => TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.8,
  color: context.textMutedColor,
);
TextStyle _valueStyle(BuildContext context) => TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w700,
  color: context.textMainColor,
);
TextStyle _subValueStyle(BuildContext context) => TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: context.textMutedColor,
);
TextStyle _sectionTitleStyle(BuildContext context) => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: context.textMainColor,
);

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key, this.isPaid = false, this.booking});

  /// When true: read-only mode — shows a green "Paid" banner instead of
  /// the confirm button. Set by [BookingCard] when opening a past booking.
  final bool isPaid;

  /// The past booking to display in read-only mode. Required when [isPaid]
  /// is true. Provides the hotel object, dates, rooms and price data without
  /// needing [BookingController].
  final BookingModel? booking;

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isCapturing = false;

  Future<void> _captureAndAction({required bool saveToGallery}) async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final Uint8List? imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 200),
      );

      if (imageBytes == null) throw Exception("Failed to capture screenshot");

      final tempDir = await getTemporaryDirectory();
      final hotelName = widget.isPaid
          ? widget.booking!.hotelName
          : Get.find<BookingController>().hotel.name;
      final file = File(
        '${tempDir.path}/booking_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(imageBytes);

      if (saveToGallery) {
        await Gal.putImage(file.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Saved to gallery!',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: context.primaryColor,
            ),
          );
        }
      } else {
        await Share.shareXFiles([
          XFile(file.path),
        ], text: 'My booking at $hotelName');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // In paid mode, BookingController may not be registered (different route
    // context), so only look it up when actually needed.
    final controller = widget.isPaid ? null : Get.find<BookingController>();
    final effectiveHotel = widget.isPaid
        ? widget.booking!.hotel
        : controller!.hotel;
    final heroImage = effectiveHotel.images.isNotEmpty
        ? effectiveHotel.images.first.url
        : null;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        surfaceTintColor: const Color(0xFFF7F7F9),
        centerTitle: true,
        title: Text(
          'Booking Summary'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 0) _captureAndAction(saveToGallery: true);
              if (value == 1) _captureAndAction(saveToGallery: false);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 18,
                      color: context.textMainColor,
                    ),
                    const SizedBox(width: 8),
                    Text('Save to Gallery'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      size: 18,
                      color: context.textMainColor,
                    ),
                    const SizedBox(width: 8),
                    Text('Share'.tr),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // HIDDEN SCREENSHOT TARGET
          Positioned(
            left: 0,
            right: 0,
            top: -10000,
            child: IgnorePointer(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Screenshot(
                    controller: _screenshotController,
                    child: Material(
                      color: const Color(0xFFF7F7F9),
                      child: BookingScreenshotWidget(
                        booking: widget.booking,
                        isPaid: widget.isPaid,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                                placeholder: (context, url) => ColoredBox(
                                  color: CustomColors.cardSubtleBg,
                                ),
                                errorWidget: (context, url, error) =>
                                    ColoredBox(
                                      color: CustomColors.cardSubtleBg,
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: context.hintColor,
                                        size: 48,
                                      ),
                                    ),
                              )
                            : ColoredBox(color: CustomColors.cardSubtleBg),
                        // GRADIENT OVERLAY
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x00000000), Color(0x99000000)],
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
                        Text(
                          'Stay Details'.tr,
                          style: _sectionTitleStyle(context),
                        ),
                        if (!widget.isPaid)
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () =>
                                controller!.selectDateRange(context),
                            child: Text(
                              'Edit'.tr,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (widget.isPaid) ...[
                      // PAID MODE — static date/rooms grid from BookingModel
                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CHECK-IN'.tr,
                                    style: _labelStyle(context),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.booking != null
                                        ? DateFormat(
                                            'MMM dd, yyyy',
                                            Get.locale?.languageCode,
                                          ).format(widget.booking!.checkInDate)
                                        : '—',
                                    style: _valueStyle(context),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'After 02:00 PM'.tr,
                                    style: _subValueStyle(context),
                                  ),
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
                                  Text(
                                    'CHECK-OUT'.tr,
                                    style: _labelStyle(context),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.booking != null
                                        ? DateFormat(
                                            'MMM dd, yyyy',
                                            Get.locale?.languageCode,
                                          ).format(widget.booking!.checkOutDate)
                                        : '—',
                                    style: _valueStyle(context),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Before 11:00 AM'.tr,
                                    style: _subValueStyle(context),
                                  ),
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
                                      color: context.primaryColor.withOpacity(
                                        0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.nightlight_round,
                                      size: 18,
                                      color: context.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'DURATION'.tr,
                                        style: _labelStyle(context),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.booking != null
                                            ? widget.booking!.nights == 1
                                                  ? 'night_count'.trParams({
                                                      'count': widget
                                                          .booking!
                                                          .nights
                                                          .toString(),
                                                    })
                                                  : 'nights_count'.trParams({
                                                      'count': widget
                                                          .booking!
                                                          .nights
                                                          .toString(),
                                                    })
                                            : '—',
                                        style: _valueStyle(context),
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
                                      color: context.primaryColor.withOpacity(
                                        0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.person_outline_rounded,
                                      size: 18,
                                      color: context.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ROOMS'.tr,
                                        style: _labelStyle(context),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.booking != null
                                            ? widget.booking!.numberOfRooms == 1
                                                  ? 'room_count'.trParams({
                                                      'count': widget
                                                          .booking!
                                                          .numberOfRooms
                                                          .toString(),
                                                    })
                                                  : 'rooms_count'.trParams({
                                                      'count': widget
                                                          .booking!
                                                          .numberOfRooms
                                                          .toString(),
                                                    })
                                            : '—',
                                        style: _valueStyle(context),
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
                        final checkInStr = dateRange != null
                            ? DateFormat(
                                'MMM dd, yyyy',
                                Get.locale?.languageCode,
                              ).format(dateRange.start)
                            : 'Not selected'.tr;
                        final checkOutStr = dateRange != null
                            ? DateFormat(
                                'MMM dd, yyyy',
                                Get.locale?.languageCode,
                              ).format(dateRange.end)
                            : 'Not selected'.tr;
                        final nights = controller.nights;

                        return Column(
                          children: [
                            Row(
                              children: [
                                // CHECK-IN
                                Expanded(
                                  child: SummaryCard(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CHECK-IN'.tr,
                                          style: _labelStyle(context),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          checkInStr,
                                          style: _valueStyle(context),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'After 02:00 PM'.tr,
                                          style: _subValueStyle(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // CHECK-OUT
                                Expanded(
                                  child: SummaryCard(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CHECK-OUT'.tr,
                                          style: _labelStyle(context),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          checkOutStr,
                                          style: _valueStyle(context),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Before 11:00 AM'.tr,
                                          style: _subValueStyle(context),
                                        ),
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
                                            color: context.primaryColor
                                                .withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.nightlight_round,
                                            size: 18,
                                            color: context.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'DURATION'.tr,
                                              style: _labelStyle(context),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              nights == 1
                                                  ? 'night_count'.trParams({
                                                      'count': nights
                                                          .toString(),
                                                    })
                                                  : 'nights_count'.trParams({
                                                      'count': nights
                                                          .toString(),
                                                    }),
                                              style: _valueStyle(context),
                                            ),
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
                                            color: context.primaryColor
                                                .withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.person_outline_rounded,
                                            size: 18,
                                            color: context.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'ROOMS'.tr,
                                              style: _labelStyle(context),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              controller.totalQuantity == 1
                                                  ? 'room_count'.trParams({
                                                      'count': controller
                                                          .totalQuantity
                                                          .toString(),
                                                    })
                                                  : 'rooms_count'.trParams({
                                                      'count': controller
                                                          .totalQuantity
                                                          .toString(),
                                                    }),
                                              style: _valueStyle(context),
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
                    SelectedRoomsList(
                      booking: widget.isPaid ? widget.booking : null,
                    ),

                    // PRICE BREAKDOWN
                    if (widget.isPaid && widget.booking != null) ...[
                      Text(
                        'Price Details'.tr,
                        style: _sectionTitleStyle(context),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
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
                                Text(
                                  'Subtotal'.tr,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: context.textMutedColor,
                                  ),
                                ),
                                Text(
                                  formatPrice(widget.booking!.grossTotal),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: context.textMainColor,
                                  ),
                                ),
                              ],
                            ),
                            if (widget.booking!.discount > 0) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Discount'.tr,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                  Text(
                                    '- ${formatPrice(widget.booking!.discount)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(
                                height: 1,
                                color: Color(0xFFEEEEEE),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Paid'.tr,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: context.textMainColor,
                                  ),
                                ),
                                Text(
                                  formatPrice(widget.booking!.netTotal),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: context.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ] else if (!widget.isPaid) ...[
                      Text(
                        'Price Details'.tr,
                        style: _sectionTitleStyle(context),
                      ),
                      const SizedBox(height: 10),
                      const PriceBreakdown(),
                      const SizedBox(height: 20),
                    ],

                    // CANCELLATION POLICY
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withOpacity(0.04),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        border: Border.all(
                          color: context.primaryColor.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: context.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cancellation Policy'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: context.textMainColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  effectiveHotel.terms ??
                                      'free_cancellation_fallback'.tr,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: context.textMutedColor,
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
              decoration: BoxDecoration(
                color: context.surfaceColor,
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
              child: widget.isPaid
                  // STATUS BANNER — paid read-only mode
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.booking!.bookingStatus ==
                            BookingStatus.cancelled)
                          Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: context.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cancel_rounded,
                                  size: 20,
                                  color: context.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Cancelled'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: context.primaryColor,
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
                                  color: const Color(
                                    0xFF2E7D32,
                                  ).withOpacity(0.30),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
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
                          if (widget.booking!.bookingStatus !=
                              BookingStatus.completed) ...[
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () =>
                                  _showCancelDialog(context, widget.booking!),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                foregroundColor: context.primaryColor,
                                side: BorderSide(
                                  color: context.primaryColor,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Text(
                                'Cancel Booking'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ],
                    )
                  // CONFIRM BUTTON — active booking mode
                  : Obx(() {
                      final subtotal = controller!.totalPrice;
                      final total =
                          subtotal * 1.172; // 10% service + 7.2% taxes
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
                                  color: controller.isBooking.value
                                      ? Colors.grey
                                      : context.primaryColor,
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: controller.isBooking.value
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: context.primaryColor
                                                .withOpacity(0.30),
                                            blurRadius: 16,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: controller.isBooking.value
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          key: const ValueKey('booking'),
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Booking...'.tr,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          key: const ValueKey('confirm'),
                                          children: [
                                            Text(
                                              'Confirm Booking'.tr,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Icon(
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
                              Text(
                                'Total price'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.textMutedColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formatPrice(total),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: context.textMainColor,
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
          backgroundColor: context.surfaceColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Cancel Booking?'.tr,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'cancel_booking_desc'.tr,
                style: TextStyle(
                  color: context.textMutedColor,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.primaryColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: context.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking.hotel.terms ?? 'free_cancellation_fallback'.tr,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.primaryColor,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
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
              style: TextButton.styleFrom(
                foregroundColor: context.textMutedColor,
              ),
              child: Text(
                'Keep Booking'.tr,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog immediately
                final tempController = Get.put(
                  BookingController(hotel: booking.hotel),
                );
                tempController.cancelBooking(booking, context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: context.primaryColor.withOpacity(0.10),
              ),
              child: Text(
                'Cancel Booking'.tr,
                style: TextStyle(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
