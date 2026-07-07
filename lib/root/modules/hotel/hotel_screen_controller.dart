import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/data/models/review.dart';
import 'package:majestic_rooms/core/utils/helper.dart';
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
      if (hotelId.startsWith('local_')) {
        debugPrint('Hotel $hotelId is a local hotel. Skipping reviews fetch.');
        Utils.showToast('Could not fetch reviews');
        return;
      }

      final supabase = Supabase.instance.client;
      // 1. Check if hotel exists
      final hotelRow = await supabase
          .from('hotel')
          .select('id')
          .eq('id', hotelId)
          .maybeSingle();

      if (hotelRow == null) {
        debugPrint('Hotel $hotelId does not exist on server. Skipping reviews fetch.');
        Utils.showToast('Could not fetch reviews');
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
      Utils.showToast('Could not fetch reviews');
    } finally {
      isLoadingReviews.value = false;
    }
  }
}
