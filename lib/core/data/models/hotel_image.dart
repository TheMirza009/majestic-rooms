class HotelImage {
  final int id;
  final String? hotelSlug;
  final String url;
  final String? description;
  final int? sortOrder;

  const HotelImage({
    required this.id,
    this.hotelSlug,
    required this.url,
    this.description,
    this.sortOrder,
  });

  factory HotelImage.fromJson(Map<String, dynamic> json) {
    return HotelImage(
      id: json['id'] ?? 0, // Using 0 as fallback if id is not fetched
      hotelSlug: json['hotel_slug'] as String?,
      url: json['url'] as String,
      description: json['description'] as String?,
      sortOrder: json['sort_order'] as int?,
    );
  }
}
