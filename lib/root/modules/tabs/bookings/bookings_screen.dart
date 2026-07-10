import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/data/models/booking.dart';
import 'package:majestic_rooms/root/modules/tabs/bookings/booking_card.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  // ── Control Panel ─────────────────────────────────────────────────────────
  static const _scaffoldBg = Color(0xFFF7F7F9);

  // ── Fields ────────────────────────────────────────────────────────────────
  BookingStatus? _selectedStatus;
  final Map<BookingStatus, GlobalKey> _chipKeys = {
    for (final status in BookingStatus.values) status: GlobalKey(),
  };

  // ── Handlers ──────────────────────────────────────────────────────────────
  void _onFilterSelected(BookingStatus status) {
    setState(() {
      _selectedStatus = (_selectedStatus == status) ? null : status;
    });

    final context = _chipKeys[status]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  String _statusLabel(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending: return 'Pending';
      case BookingStatus.confirmed: return 'Confirmed';
      case BookingStatus.cancelled: return 'Cancelled';
      case BookingStatus.checkedIn: return 'Checked In';
      case BookingStatus.completed: return 'Completed';
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommonController>();
    return Scaffold(
      backgroundColor: _scaffoldBg,
      appBar: AppBar(
        backgroundColor: _scaffoldBg,
        surfaceTintColor: _scaffoldBg,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        centerTitle: true,
        title: const Text(
          'My Bookings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // ── Filter Chips ──────────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                for (final status in BookingStatus.values)
                  Padding(
                    key: _chipKeys[status],
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Builder(
                      builder: (context) {
                        final isSelected = _selectedStatus == status;
                        return ChoiceChip(
                          label: Text(_statusLabel(status)),
                          selected: isSelected,
                          onSelected: (_) => _onFilterSelected(status),
                          selectedColor: CustomColors.brandBlack,
                          backgroundColor: CustomColors.surfaceWhite,
                          labelStyle: TextStyle(
                            color: isSelected ? CustomColors.textLight : CustomColors.textMuted,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            fontFamily: 'Fustat',
                            fontSize: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: const BorderSide(color: Color.fromRGBO(231, 231, 231, 1)),
                          ),
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        );
                      }
                    ),
                  ),
              ],
            ),
          ),

          // ── Content ───────────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              final allBookings = controller.bookings.reversed.toList();
              final bookings = _selectedStatus == null
                  ? allBookings
                  : allBookings.where((b) => b.bookingStatus == _selectedStatus).toList();

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: bookings.isEmpty
                    ? Center(
                        key: ValueKey('empty_${_selectedStatus?.name ?? 'all'}'),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.bookmark_border_rounded,
                              size: 56,
                              color: CustomColors.hintColor,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No bookings yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: CustomColors.textMain,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _selectedStatus == null
                                  ? 'Your confirmed reservations will appear here.'
                                  : 'No reservations match this filter.',
                              style: const TextStyle(
                                fontSize: 13,
                                color: CustomColors.textMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        key: ValueKey('list_${_selectedStatus?.name ?? 'all'}'),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        physics: const BouncingScrollPhysics(),
                        itemCount: bookings.length + 2,
                        itemBuilder: (_, index) {
                          if (index < bookings.length) {
                            return BookingCard(booking: bookings[index]);
                          }
                          if (index == bookings.length) {
                            return const _DebugClearBookingsButton();
                          }
                          return const SizedBox(height: 100);
                        },
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DebugClearBookingsButton extends StatelessWidget {
  const _DebugClearBookingsButton();

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: ElevatedButton.icon(
        onPressed: () async {
          debugPrint("CANCEL BOOKING CALLED");
          try {
            final supabase = Supabase.instance.client;
            final user = supabase.auth.currentUser;
            if (user == null) {
               Get.find<CommonController>().bookings.clear();
               Get.snackbar('Debug', 'Local bookings cleared (No user logged in).', snackPosition: SnackPosition.BOTTOM);
               return;
            }
            final userId = user.id;
            
            final userBookings = await supabase.from('booking').select('id').eq('account_id', userId);
            final List<String> bookingIds = (userBookings as List).map((b) => b['id'].toString()).toList();
            
            if (bookingIds.isNotEmpty) {
              await supabase.from('booking_detail').delete().inFilter('booking_id', bookingIds);
              await supabase.from('payment').delete().inFilter('booking_id', bookingIds);
              await supabase.from('booking').delete().inFilter('id', bookingIds);
            }
            
            Get.find<CommonController>().bookings.clear();
            if (context.mounted) {
              Get.snackbar(
                'Debug',
                'All bookings completely deleted from backend and app.',
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(16),
              );
            }
          } catch (e) {
            debugPrint('❌ [Debug] Failed to wipe bookings: $e');
            if (context.mounted) {
              Get.snackbar(
                'Error',
                'Failed to delete bookings: $e',
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(16),
              );
            }
          }
        },
        icon: const Icon(Icons.delete_forever),
        label: const Text('Clear All Bookings (Debug)'),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.brandRed,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
