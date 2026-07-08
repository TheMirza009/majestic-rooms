import 'package:majestic_rooms/core/data/models/facility.dart';
import 'package:majestic_rooms/core/data/models/hotel_image.dart';
import 'package:majestic_rooms/core/data/models/hotel_room.dart';
import 'package:majestic_rooms/core/data/models/promotion.dart';

class Hotel {
  final String id;
  final String name;
  final String? slug;
  final String? address;
  final String city; // Maps to location_slug
  final num? distanceFromHaram;
  final String? liscenseNo;
  final num? latitude;
  final num? longitude;
  final num? hotelClass; // Maps to class in Supabase
  final String? paymentPolicies;
  final String? description;
  final String? terms;
  final bool? serveBreakfast;
  final String? phoneNumber;
  final String? email;
  final bool? isActive;

  final List<HotelImage> images;
  final List<HotelRoom> rooms;
  final List<Facility> facilities;
  final Promotion? activePromotion;

  // Compatibility getters for UI
  String get imageUrl => images.isNotEmpty ? images.first.url : 'https://picsum.photos/600/400';
  List<num> get rates => rooms.map((e) => e.pricePerNight).toList();
  double get rating => hotelClass?.toDouble() ?? 0.0;

  const Hotel({
    required this.id,
    required this.name,
    this.slug,
    this.address,
    required this.city,
    this.distanceFromHaram,
    this.liscenseNo,
    this.latitude,
    this.longitude,
    this.hotelClass,
    this.paymentPolicies,
    this.description,
    this.terms,
    this.serveBreakfast,
    this.phoneNumber,
    this.email,
    this.isActive,
    required this.images,
    required this.rooms,
    this.facilities = const [],
    this.activePromotion,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'].toString(),
      name: json['name'].toString(),
      slug: json['slug']?.toString(),
      address: json['address']?.toString(),
      city: json['location_slug']?.toString() ?? 'Unknown',
      distanceFromHaram: json['distance_from_haram'] as num?,
      liscenseNo: json['liscense_no']?.toString(),
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      hotelClass: json['class'] as num?,
      paymentPolicies: json['payment_policies']?.toString(),
      description: json['description']?.toString(),
      terms: json['terms']?.toString(),
      serveBreakfast: json['serve_breakfast'] as bool?,
      phoneNumber: json['phone_number']?.toString(),
      email: json['email']?.toString(),
      isActive: json['is_active'] as bool?,
      images: (json['hotel_images'] as List<dynamic>?)
              ?.map((e) => HotelImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rooms: (json['hotel_rooms'] as List<dynamic>?)
              ?.map((e) => HotelRoom.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      facilities: (json['hotel_facility'] as List<dynamic>?)
              ?.map((e) => Facility.fromJson(e['facility'] as Map<String, dynamic>))
              .toList() ??
          [],
      activePromotion: _parsePromotion(json['promotion']),
    );
  }

  static Promotion? _parsePromotion(dynamic promoData) {
    if (promoData == null) return null;
    if (promoData is List) {
      if (promoData.isEmpty) return null;
      return Promotion.fromJson(promoData.first as Map<String, dynamic>);
    }
    if (promoData is Map<String, dynamic>) {
      return Promotion.fromJson(promoData);
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Hotel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
