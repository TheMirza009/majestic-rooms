import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:majestic_rooms/core/data/models/booking.dart';
import 'package:majestic_rooms/core/extensions/context_extensions.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:majestic_rooms/root/modules/booking/screens/booking_summary_screen.dart';
import 'package:majestic_rooms/root/modules/booking/widgets/summary_widgets/booking_screenshot_widget.dart';
import 'package:majestic_rooms/root/modules/home/home_controller.dart';
import 'package:majestic_rooms/root/modules/home/home_screen.dart';

// ── Shared style constants ─────────────────────────────────────────────────────
TextStyle _snapshotLabelStyle(BuildContext context) => TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.8,
  color: context.textMutedColor,
);
TextStyle _snapshotValueStyle(BuildContext context) => TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: context.textMainColor,
);

class BookingSuccessScreen extends StatefulWidget {
  const BookingSuccessScreen({super.key, required this.booking});

  final BookingModel booking;

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen>
    with SingleTickerProviderStateMixin {
  // ── Control Panel ──────────────────────────────────────────────────────────
  static const _animationDuration = Duration(milliseconds: 1500);

  // ── Fields ─────────────────────────────────────────────────────────────────
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isCapturing = false;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    Future.delayed(
      Duration(milliseconds: 500),
      () => _animController.forward(),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ── Handlers ───────────────────────────────────────────────────────────────
  void _goToBookings() {
    Get.find<HomeController>().resetToTab(2);
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  void _backToExploring() {
    Get.find<HomeController>().navigateTo(0);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _captureAndAction({required bool saveToGallery}) async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final Uint8List? imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 200),
      );

      if (imageBytes == null) throw Exception("Failed to capture screenshot");

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/booking_${widget.booking.id ?? DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(imageBytes);

      if (saveToGallery) {
        await Gal.putImage(file.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Saved to gallery!'.tr,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: context.primaryColor,
            ),
          );
        }
      } else {
        await Share.shareXFiles([
          XFile(file.path),
        ], text: 'My booking at ${widget.booking.hotelName}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: @error'.trParams({'error': e.toString()}),
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

  Widget _buildChipButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFEEEEEE),
        foregroundColor: context.textMutedColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final checkIn = DateFormat(
      'MMM dd, yyyy',
      Get.locale?.languageCode,
    ).format(booking.checkInDate);
    final checkOut = DateFormat(
      'MMM dd, yyyy',
      Get.locale?.languageCode,
    ).format(booking.checkOutDate);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _backToExploring();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F9),
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
                          isPaid: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // SizedBox(height: context.screenHeight * 0.25),
                    SizedBox(height: 100),

                    // ANIMATED CHECK
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF9B2728), context.primaryColor],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x407A2021),
                              blurRadius: 32,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 52,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // SUCCESS TEXT
                    Text(
                      'Booking Confirmed!'.tr,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: context.textMainColor,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    // SUBTITLE
                    Text(
                      'reservation_confirmed'.trParams({
                        'hotel': booking.hotelName,
                      }),
                      style: TextStyle(
                        fontSize: 14,
                        color: context.textMutedColor,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // BOOKING SNAPSHOT
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hotel name row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: context.primaryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.hotel_rounded,
                                  size: 18,
                                  color: context.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'HOTEL'.tr,
                                      style: _snapshotLabelStyle(context),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      booking.hotelName,
                                      style: _snapshotValueStyle(context),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                          ),
                          // Dates row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CHECK-IN'.tr,
                                      style: _snapshotLabelStyle(context),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(checkIn, style: _snapshotValueStyle(context)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: context.primaryColor.withOpacity(0.07),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: context.primaryColor,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'CHECK-OUT'.tr,
                                      style: _snapshotLabelStyle(context),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(checkOut, style: _snapshotValueStyle(context)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                          ),
                          // Nights + total row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DURATION'.tr,
                                    style: _snapshotLabelStyle(context),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    booking.nights == 1
                                        ? 'night_count'.trParams({
                                            'count': booking.nights.toString(),
                                          })
                                        : 'nights_count'.trParams({
                                            'count': booking.nights.toString(),
                                          }),
                                    style: _snapshotValueStyle(context),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'TOTAL PAID'.tr,
                                    style: _snapshotLabelStyle(context),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatPrice(booking.netTotal),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: context.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ACTION BUTTONS
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: GestureDetector(
                            onTap: _goToBookings,
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.primaryColor,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: context.primaryColor.withOpacity(
                                      0.30,
                                    ),
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
                                    Icons.bookmark_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Go to Bookings'.tr,
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
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: GestureDetector(
                            onTap: _backToExploring,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: context.primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.explore_rounded,
                                    size: 18,
                                    color: context.primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Back to Exploring'.tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: context.primaryColor,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildChipButton(
                              icon: Icons.image_outlined,
                              label: _isCapturing
                                  ? 'Saving...'.tr
                                  : 'Save to Gallery'.tr,
                              onTap: () =>
                                  _captureAndAction(saveToGallery: true),
                            ),
                            const SizedBox(width: 12),
                            _buildChipButton(
                              icon: Icons.share_outlined,
                              label: 'Share'.tr,
                              onTap: () =>
                                  _captureAndAction(saveToGallery: false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ], // End of Stack children
        ), // End of Stack
      ),
    );
  }
}
