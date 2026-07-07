import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:majestic_rooms/core/data/models/booking.dart';
import 'package:majestic_rooms/core/extensions/context_extensions.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/home/home_controller.dart';
import 'package:majestic_rooms/root/modules/home/home_screen.dart';

// ── Shared style constants ─────────────────────────────────────────────────────
const _snapshotLabelStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.8,
  color: CustomColors.textMuted,
);
const _snapshotValueStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: CustomColors.textMain,
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
    Future.delayed(Duration(milliseconds: 500), () => _animController.forward());
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

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final checkIn = DateFormat('MMM dd, yyyy').format(booking.checkInDate);
    final checkOut = DateFormat('MMM dd, yyyy').format(booking.checkOutDate);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _backToExploring();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF9B2728), CustomColors.brandRed],
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
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: CustomColors.textMain,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // SUBTITLE
              Text(
                'Your reservation at ${booking.hotelName} is confirmed.\nCheck your Bookings tab for full details.',
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.textMuted,
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
                  color: CustomColors.surfaceWhite,
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
                            color: CustomColors.brandRed.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.hotel_rounded,
                            size: 18,
                            color: CustomColors.brandRed,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('HOTEL', style: _snapshotLabelStyle),
                              const SizedBox(height: 2),
                              Text(
                                booking.hotelName,
                                style: _snapshotValueStyle,
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
                              const Text(
                                'CHECK-IN',
                                style: _snapshotLabelStyle,
                              ),
                              const SizedBox(height: 4),
                              Text(checkIn, style: _snapshotValueStyle),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.brandRed.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: CustomColors.brandRed,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'CHECK-OUT',
                                style: _snapshotLabelStyle,
                              ),
                              const SizedBox(height: 4),
                              Text(checkOut, style: _snapshotValueStyle),
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
                            const Text('DURATION', style: _snapshotLabelStyle),
                            const SizedBox(height: 4),
                            Text(
                              '${booking.nights} Night${booking.nights == 1 ? '' : 's'}',
                              style: _snapshotValueStyle,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'TOTAL PAID',
                              style: _snapshotLabelStyle,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatPrice(booking.netTotal),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: CustomColors.brandRed,
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
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmark_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Go to Bookings',
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
                            color: CustomColors.brandRed,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.explore_rounded,
                              size: 18,
                              color: CustomColors.brandRed,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Back to Exploring',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: CustomColors.brandRed,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}