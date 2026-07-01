class Promotion {
  final String code;
  final String hotelId;
  final num? discountPercent;
  final String? validFrom;
  final String? validTo;
  final bool? isActive;

  const Promotion({
    required this.code,
    required this.hotelId,
    this.discountPercent,
    this.validFrom,
    this.validTo,
    this.isActive,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      code: json['code'] as String,
      hotelId: json['hotel_id'] as String,
      discountPercent: json['discount_percent'] as num?,
      validFrom: json['valid_from'] as String?,
      validTo: json['valid_to'] as String?,
      isActive: json['is_active'] as bool?,
    );
  }
}
