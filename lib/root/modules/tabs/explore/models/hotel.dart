class Hotel {
  final String name;
  final String address;
  final String city;  // matches ExploreController.categories — used for filtering
  final String imageUrl;
  final num    rate;   // price per night
  final double rating; // 0.0 – 5.0

  const Hotel({
    required this.name,
    required this.address,
    required this.city,
    required this.imageUrl,
    required this.rate,
    required this.rating,
  });
}
