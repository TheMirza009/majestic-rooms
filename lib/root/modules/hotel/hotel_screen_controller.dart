import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/data/models/review.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HotelScreenController extends GetxController {
  final String hotelId;

  HotelScreenController({required this.hotelId});

  final reviews = <Review>[].obs;
  final isLoadingReviews = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      final supabase = Supabase.instance.client;
      // 1. Check if hotel exists
      final hotelRow = await supabase
          .from('hotel')
          .select('id')
          .eq('id', hotelId)
          .maybeSingle();

      if (hotelRow == null) {
        debugPrint('Hotel $hotelId does not exist on server. Skipping reviews fetch.');
        return;
      }

      final response = await supabase
          .from('review')
          .select('id, reviewer_name, overall_rating, feedback, review_detail_rating(id, review_id, service, rating)')
          .eq('hotel_id', hotelId)
          .order('id', ascending: false);
      reviews.assignAll((response as List).map((e) => Review.fromJson(e)).toList());
    } catch (e) {
      debugPrint('Reviews fetch error: $e');
    } finally {
      isLoadingReviews.value = false;
    }
  }
}
