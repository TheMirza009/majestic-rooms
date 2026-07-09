import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:majestic_rooms/core/data/models/hotel_room.dart';
import 'package:majestic_rooms/root/modules/booking/booking_controller.dart';

// ── Enums ─────────────────────────────────────────────────────────────────────

enum BookingStatus {
  pending('PENDING'),
  confirmed('CONFIRMED'),
  cancelled('CANCELLED'),
  checkedIn('CHECKED_IN'),
  completed('COMPLETED');

  const BookingStatus(this.value);

  /// The exact string expected by the Supabase `booking_status_enum`.
  final String value;

  static BookingStatus fromValue(String value) {
    return BookingStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => BookingStatus.pending,
    );
  }
}

// ── BookingDetailItem ─────────────────────────────────────────────────────────

/// One line item — maps to a single row in the `booking_detail` Supabase table.
///
/// [roomId] is stored as an int? to match `hotel_rooms.id` (integer PK).
/// [includesBreakfast] mirrors the `includes_breakfast` column.
class BookingDetailItem {
  final int? roomId;
  final String? roomName;
  final int quantity;
  final double pricePerNight;
  final double grossAmount;
  final double discount;
  final double netAmount;
  final bool includesBreakfast;

  const BookingDetailItem({
    this.roomId,
    this.roomName,
    required this.quantity,
    required this.pricePerNight,
    required this.grossAmount,
    this.discount = 0.0,
    required this.netAmount,
    this.includesBreakfast = false,
  });

  /// Produces the Map for a `booking_detail` INSERT.
  /// Caller must inject [bookingId] (the UUID returned from the `booking` insert).
  ///
  /// Future wiring: pass the result of `supabase.from('booking_detail').insert(toInsertJson(id))`.
  Map<String, dynamic> toInsertJson(String bookingId) => {
        'booking_id': bookingId,
        'room_id': roomId,
        'no_of_rooms': quantity,
        'room_price': pricePerNight,
        'gross_amount': grossAmount,
        'discount': discount,
        'net_amount': netAmount,
        'includes_breakfast': includesBreakfast,
      };

  factory BookingDetailItem.fromJson(Map<String, dynamic> json) {
    return BookingDetailItem(
      roomId: json['room_id'] as int?,
      quantity: json['no_of_rooms'] as int? ?? 1,
      pricePerNight: (json['room_price'] as num?)?.toDouble() ?? 0.0,
      grossAmount: (json['gross_amount'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      netAmount: (json['net_amount'] as num?)?.toDouble() ?? 0.0,
      includesBreakfast: json['includes_breakfast'] as bool? ?? false,
    );
  }
}

// ── BookingModel ──────────────────────────────────────────────────────────────

/// Represents a completed booking.
///
/// [hotel] is a local-only convenience reference — it is **not** included in
/// [toInsertJson]. When backend wiring is added, this field should be removed
/// and the booking detail screen should re-fetch by [id] from Supabase instead,
/// mirroring the admin web-app's confirmation-page pattern.
class BookingModel {
  // ── Control Panel ──────────────────────────────────────────────────────────
  // Service charge + tax multiplier used to derive the displayed total.
  // Keep in sync with the same constant in booking_summary_screen.dart.
  static const double _totalMultiplier = 1.172; // 10% service + 7.2% taxes

  // ── Fields ─────────────────────────────────────────────────────────────────

  /// Local UUID placeholder. When backend wiring happens, replace with the
  /// UUID returned by the `booking` INSERT.
  final String id;

  /// Local-only. Not serialised to JSON. Drop when backend is wired.
  final Hotel hotel;

  // Denormalised display strings (derived from [hotel] at construction).
  final String hotelSlug;
  final String hotelName;
  final String? hotelImageUrl;

  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int nights;
  final int numberOfRooms;

  final double grossTotal;
  final double discount;
  final double netTotal;

  final DateTime bookingDate;
  final BookingStatus bookingStatus;

  /// Line items — one per selected [HotelRoom].
  /// Maps to rows in `booking_detail`.
  final List<BookingDetailItem> details;

  const BookingModel({
    required this.id,
    required this.hotel,
    required this.hotelSlug,
    required this.hotelName,
    this.hotelImageUrl,
    required this.checkInDate,
    required this.checkOutDate,
    required this.nights,
    required this.numberOfRooms,
    required this.grossTotal,
    this.discount = 0.0,
    required this.netTotal,
    required this.bookingDate,
    this.bookingStatus = BookingStatus.pending,
    this.details = const [],
  });

  // ── Factory ────────────────────────────────────────────────────────────────

  /// Assembles a [BookingModel] from the live [BookingController] state.
  /// Call this at the moment the user confirms, before navigating away.
  factory BookingModel.fromController(BookingController controller) {
    final hotel = controller.hotel;
    final nights = controller.nights;
    final dateRange = controller.dateRange.value!;

    // Build one BookingDetailItem per selected room.
    final details = controller.selectedRooms.entries.map((entry) {
      final room = entry.key;
      final quantity = entry.value;
      final gross = room.pricePerNight.toDouble() * quantity * nights;
      return BookingDetailItem(
        roomId: room.id != null ? int.tryParse(room.id!) : null,
        roomName: room.name ?? room.category?.name,
        quantity: quantity,
        pricePerNight: room.pricePerNight.toDouble(),
        grossAmount: gross,
        discount: 0.0,
        netAmount: gross,
        includesBreakfast: false,
      );
    }).toList();

    final grossTotal = controller.totalPrice;
    final netTotal = grossTotal * _totalMultiplier;

    return BookingModel(
      // Local placeholder ID — replaced by Supabase UUID on backend wiring.
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      hotel: hotel,
      hotelSlug: hotel.slug ?? hotel.id,
      hotelName: hotel.name,
      hotelImageUrl: hotel.imageUrl,
      checkInDate: dateRange.start,
      checkOutDate: dateRange.end,
      nights: nights,
      numberOfRooms: controller.totalQuantity,
      grossTotal: grossTotal,
      discount: 0.0,
      netTotal: netTotal,
      bookingDate: DateTime.now(),
      bookingStatus: BookingStatus.pending,
      details: details,
    );
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final String hotelSlug = json['hotel_slug'] as String? ?? 'unknown';
    
    Hotel? fetchedHotel;
    if (json['hotel'] != null && json['hotel'] is Map) {
      fetchedHotel = Hotel.fromJson(json['hotel'] as Map<String, dynamic>);
    }
    
    // Resolve hotel from fetched data or create a placeholder if it's missing
    final Hotel hotel = fetchedHotel ?? Hotel(
      id: hotelSlug,
      slug: hotelSlug,
      name: 'Unknown Hotel',
      city: 'Unknown',
      images: [],
      rooms: [],
    );

    final detailsJson = json['booking_detail'] as List<dynamic>? ?? [];
    final details = detailsJson
        .map((d) => BookingDetailItem.fromJson(d as Map<String, dynamic>))
        .toList();

    return BookingModel(
      id: json['id'] as String? ?? '',
      hotel: hotel,
      hotelSlug: hotelSlug,
      hotelName: hotel.name,
      hotelImageUrl: hotel.imageUrl,
      checkInDate: DateTime.tryParse(json['check_in_date'] as String? ?? '') ?? DateTime.now(),
      checkOutDate: DateTime.tryParse(json['check_out_date'] as String? ?? '') ?? DateTime.now(),
      nights: json['nights'] as int? ?? 1,
      numberOfRooms: json['number_of_rooms'] as int? ?? 1,
      grossTotal: (json['gross_total'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      netTotal: (json['net_total'] as num?)?.toDouble() ?? 0.0,
      bookingDate: DateTime.tryParse(json['booking_date'] as String? ?? '') ?? DateTime.now(),
      bookingStatus: BookingStatus.fromValue(json['booking_status'] as String? ?? ''),
      details: details,
    );
  }

  // ── Supabase insert helpers ─────────────────────────────────────────────────

  /// Produces the Map for the `booking` table INSERT.
  ///
  /// Future wiring:
  /// ```dart
  /// final result = await supabase
  ///     .from('booking')
  ///     .insert(booking.toInsertJson(accountId: supabase.auth.currentUser?.id))
  ///     .select('id')
  ///     .single();
  /// final serverId = result['id'] as String;
  /// ```
  Map<String, dynamic> toInsertJson({String? accountId}) => {
        'hotel_slug': hotelSlug,
        'check_in_date': _dateString(checkInDate),
        'check_out_date': _dateString(checkOutDate),
        'nights': nights,
        'number_of_rooms': numberOfRooms,
        'booking_status': bookingStatus.value,
        'booking_date': _dateString(bookingDate),
        'gross_total': grossTotal,
        'discount': discount,
        'net_total': netTotal,
        'account_id': accountId,
      };

  /// Produces the list of Maps for `booking_detail` INSERTs.
  ///
  /// Future wiring (call after [toInsertJson] resolves with the server ID):
  /// ```dart
  /// await supabase
  ///     .from('booking_detail')
  ///     .insert(booking.detailsToInsertJson(serverId));
  /// ```
  List<Map<String, dynamic>> detailsToInsertJson(String bookingId) =>
      details.map((item) => item.toInsertJson(bookingId)).toList();

  // ── Helpers ────────────────────────────────────────────────────────────────

  static String _dateString(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';
}
