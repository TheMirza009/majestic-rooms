class ReviewDetailRating {
  final int id;
  final int reviewId;
  final String service;
  final double rating;

  ReviewDetailRating({
    required this.id,
    required this.reviewId,
    required this.service,
    required this.rating,
  });

  factory ReviewDetailRating.fromJson(Map<String, dynamic> json) {
    return ReviewDetailRating(
      id: json['id'],
      reviewId: json['review_id'],
      service: json['service'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}

class Review {
  final int id;
  final String hotelId;
  final String reviewerName;
  final double? overallRating;
  final String? feedback;
  final List<ReviewDetailRating> detailRatings;

  Review({
    required this.id,
    required this.hotelId,
    required this.reviewerName,
    this.overallRating,
    this.feedback,
    required this.detailRatings,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    var detailRatingsList = <ReviewDetailRating>[];
    if (json['review_detail_rating'] != null) {
      detailRatingsList = (json['review_detail_rating'] as List)
          .map((i) => ReviewDetailRating.fromJson(i))
          .toList();
    }
    
    return Review(
      id: json['id'],
      hotelId: json['hotel_id'] ?? '', // hotel_id might be absent if we didn't select it, but we can default to empty string if missing since we query by hotel_id
      reviewerName: json['reviewer_name'] ?? 'Anonymous',
      overallRating: json['overall_rating'] != null ? (json['overall_rating'] as num).toDouble() : null,
      feedback: json['feedback'],
      detailRatings: detailRatingsList,
    );
  }
}
