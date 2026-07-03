import 'package:supabase_flutter/supabase_flutter.dart';

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
    final rawUrl = json['image_url'] ?? json['url'] as String?;
    
    return HotelImage(
      id: json['id'] ?? 0, // Using 0 as fallback if id is not fetched
      hotelSlug: json['hotel_slug'] as String?,
      url: _parseUrl(rawUrl),
      description: json['description'] as String?,
      sortOrder: json['sort_order'] as int?,
    );
  }

  static String _parseUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return 'https://picsum.photos/600/400';
    if (rawUrl.startsWith('http')) return rawUrl;
    
    // The database might store relative paths that already include the bucket name 
    // (e.g. "hotel-images/front.png"). Instead of using .from('bucket').getPublicUrl(), 
    // which would duplicate the bucket name, we manually construct the full path.
    final storageUrl = Supabase.instance.client.storage.url; // e.g. "https://xyz.supabase.co/storage/v1"
    final normalizedPath = rawUrl.startsWith('/') ? rawUrl : '/$rawUrl';
    return '$storageUrl/object/public$normalizedPath';
  }
}
