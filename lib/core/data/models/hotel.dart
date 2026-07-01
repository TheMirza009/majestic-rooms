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
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      address: json['address'] as String?,
      city: json['location_slug'] as String? ?? 'Unknown',
      distanceFromHaram: json['distance_from_haram'] as num?,
      liscenseNo: json['liscense_no'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      hotelClass: json['class'] as num?,
      paymentPolicies: json['payment_policies'] as String?,
      description: json['description'] as String?,
      terms: json['terms'] as String?,
      serveBreakfast: json['serve_breakfast'] as bool?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
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
      activePromotion: json['promotion'] != null 
              ? Promotion.fromJson(json['promotion'] as Map<String, dynamic>) 
              : null,
    );
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
