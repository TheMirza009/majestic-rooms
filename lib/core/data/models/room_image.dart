import 'package:majestic_rooms/core/supabase/environment.dart';

class RoomImage {
  final int id;
  final String? roomId;
  final String url;
  final String? description;
  final int? sortOrder;

  const RoomImage({
    required this.id,
    this.roomId,
    required this.url,
    this.description,
    this.sortOrder,
  });

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    final rawUrl = json['image_url'] ?? json['url'] as String?;

    return RoomImage(
      id: json['id'] ?? 0, // Using 0 as fallback if id is not fetched
      roomId: json['room_id']?.toString(),
      url: _parseUrl(rawUrl),
      description: json['description'] as String?,
      sortOrder: json['sort_order'] as int?,
    );
  }

  static String _parseUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty)
      return 'https://picsum.photos/600/400';
    if (rawUrl.startsWith('http')) return rawUrl;

    // NOTE: We cannot use Supabase.instance.client.storage.url here because this method
    // is called from a compute isolate where Supabase is not initialized.
    final storageUrl = '${Environment.supabaseUrl}/storage/v1';
    final normalizedPath = rawUrl.startsWith('/') ? rawUrl : '/$rawUrl';
    return '$storageUrl/object/public$normalizedPath';
  }
}
