class RoomCategory {
  final int id;
  final String name;

  const RoomCategory({required this.id, required this.name});

  factory RoomCategory.fromJson(Map<String, dynamic> json) {
    return RoomCategory(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  bool get isStandard => name.toLowerCase() == "standard";
}

class RoomImage {
  final int id;
  final String url;

  const RoomImage({required this.id, required this.url});

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      id: json['id'] as int,
      url: json['url'] as String,
    );
  }
}

class HotelRoom {
  final String? id;
  final String? hotelSlug;
  final String? name;
  final int? beds;
  final num pricePerNight;
  final String? roomNumber;
  final RoomCategory? category;
  final List<RoomImage> images;
  final String? description;
  final bool? cityView;
  final num? pricePerNightWithBreakfast;

  const HotelRoom({
    this.id,
    this.hotelSlug,
    this.name,
    this.beds,
    required this.pricePerNight,
    this.roomNumber,
    this.category,
    this.images = const [],
    this.description,
    this.cityView,
    this.pricePerNightWithBreakfast,
  });

  factory HotelRoom.fromJson(Map<String, dynamic> json) {
    return HotelRoom(
      id: json['id']?.toString(),
      hotelSlug: json['hotel_slug']?.toString(),
      name: json['name']?.toString(),
      beds: json['beds'] as int?,
      pricePerNight: json['price_per_night'] as num,
      roomNumber: json['room_number']?.toString(),
      category: _parseCategory(json['room_category']),
      images: (json['room_images'] as List<dynamic>?)
              ?.map((e) => RoomImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      description: json['description']?.toString(),
      cityView: json['city_view'] as bool?,
      pricePerNightWithBreakfast: json['price_per_night_with_breakfast'] as num?,
    );
  }

  static RoomCategory? _parseCategory(dynamic categoryData) {
    if (categoryData == null) return null;
    if (categoryData is List) {
      if (categoryData.isEmpty) return null;
      return RoomCategory.fromJson(categoryData.first as Map<String, dynamic>);
    }
    if (categoryData is Map<String, dynamic>) {
      return RoomCategory.fromJson(categoryData);
    }
    return null;
  }
}
