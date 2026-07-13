import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/constants.dart';
import 'package:majestic_rooms/root/modules/booking/booking_controller.dart';
import 'package:majestic_rooms/root/modules/booking/screens/rooms_screen.dart';
import 'package:majestic_rooms/root/modules/hotel/widgets/check_availability_bar.dart';
import 'package:majestic_rooms/root/modules/hotel/widgets/hotel_stars.dart';
import 'package:majestic_rooms/root/modules/hotel/widgets/image_carousel.dart';
import 'package:majestic_rooms/root/modules/hotel/widgets/licence_banner.dart';
import 'package:majestic_rooms/root/modules/hotel/widgets/maps_preview.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/favorite_button.dart';
import 'package:majestic_rooms/root/widgets/round_icon_button.dart';
import 'package:majestic_rooms/root/modules/hotel/screens/image_viewer_screen.dart';
import 'package:majestic_rooms/root/modules/hotel/hotel_screen_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class HotelScreen extends StatefulWidget {
  final Hotel hotel;
  final String? heroTag;
  const HotelScreen({super.key, required this.hotel, this.heroTag});

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  late final HotelScreenController _controller;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _reviewsSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(HotelScreenController(hotelId: widget.hotel.id));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Get.delete<HotelScreenController>();
    super.dispose();
  }

  void _scrollToReviews() {
    if (_reviewsSectionKey.currentContext != null) {
      Scrollable.ensureVisible(
        _reviewsSectionKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onShare() {
    final webUrl = '${Constants.webURL}/hotel/${widget.hotel.slug}';
    final text = 'share_hotel'.trParams({
      'hotel': widget.hotel.name,
      'address': widget.hotel.address ?? '',
      'url': webUrl,
    });
    Share.share(text, subject: 'Majestic Rooms: ${widget.hotel.name}');
  }

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;
    final heroTag = widget.heroTag;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 100,
        toolbarHeight: 66,
        leading: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 10.0),
            child: RoundIconButton(
              size: 46,
              icon: Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: CustomColors.textLight,
                  size: 22,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 10.0, right: 10),
            child: RoundIconButton(
              size: 46,
              icon: Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: const Icon(
                  Icons.share_outlined,
                  color: CustomColors.textLight,
                  size: 22,
                ),
              ),
              onTap: _onShare,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 10.0),
            child: Obx(() {
              final CommonController commonController = Get.find<CommonController>();
              return FavoriteButton(
                value: commonController.savedHotels.contains(hotel),
                onChanged: (_) {
                  commonController.toggleHotelSave(hotel);
                },
              );
            }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              type: MaterialType.transparency,
              child: Stack(
                children: [
                  ImageCarousel(
                    images: hotel.images.map((image) => image.url).toList(),
                    heroTagPrefix: heroTag ?? hotel.imageUrl,
                    onImageTap: (index) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return ImageViewerScreen(
                              imageUrls: hotel.images.map((e) => e.url).toList(),
                              initialIndex: index,
                              heroTagPrefix: heroTag ?? hotel.imageUrl,
                            );
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      );
                    },
                  ),
                  if (hotel.activePromotion != null && hotel.activePromotion?.isActive == true)
                      Positioned(
                        bottom: 24,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_offer_rounded, size: 16, color: Color(0xFF10141B)),
                              const SizedBox(width: 6),
                              Text(
                                'discount_off'.trParams({'discount': hotel.activePromotion!.discountPercent.toString()}),
                                style: const TextStyle(
                                  color: Color(0xFF10141B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),


            // INFO SECTION
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // NAME & ADDRESS
                  Text(
                    hotel.name, 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: CustomColors.textMain),
                  ),
                  Text(
                    hotel.address ?? 'In a Galaxy far away'.tr, 
                    style: const TextStyle(fontSize: 20, color: CustomColors.textMain),
                  ),

                  // STARS
                  Obx(() => HotelStars(
                        rating: hotel.rating,
                        reviewCount: _controller.isLoadingReviews.value ? null : _controller.reviews.length,
                        onTap: _scrollToReviews,
                      )),
                  SizedBox(height: 40),
                  
                  // ABOUT
                  Text(
                    'About'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.textMain,
                    ),
                  ),
                  Text(
                    hotel.description?.isEmpty ?? true ? 'No description given'.tr : hotel.description!,
                    style: TextStyle(
                      fontStyle: hotel.description?.isEmpty ?? true ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: 20),

                  // LICENCE
                  LicenceBanner(licenceNo: hotel.liscenseNo),
                  SizedBox(height: 30),

                  // SERVICES
                  if (hotel.facilities.isNotEmpty) ...[
                    Text(
                      'Services'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: hotel.facilities.map((f) => Chip(
                        label: Text(f.name.tr),
                        avatar: Icon(_getIconData(f.icon, f.name), size: 18, color: CustomColors.brandRed),
                        backgroundColor: CustomColors.surfaceWhite,
                        side: BorderSide(color: CustomColors.borderColor.withOpacity(0.2)),
                        elevation: 2.0,
                        shadowColor: Colors.black.withOpacity(0.4),
                      )).toList(),
                    ),
                    const SizedBox(height: 30),
                  ],
                  
                  // LOCATION
                  Text(
                    'Location'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.textMain,
                    ),
                  ),
                  if (hotel.distanceFromHaram != null) Text(
                    'km_from_haram'.trParams({'km': hotel.distanceFromHaram.toString()}),
                    style: TextStyle(
                      fontStyle: hotel.distanceFromHaram == null ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                  
                  if (hotel.latitude != null && hotel.longitude != null) ...[
                    const SizedBox(height: 16),
                    MapsPreview(
                      latitude: hotel.latitude!.toDouble(),
                      longitude: hotel.longitude!.toDouble(),
                      hotelName: hotel.name,
                    ),
                  ],
                  
                  const SizedBox(height: 30),

                  // POLICIES
                  Text(
                    'Policies'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.textMain,
                    ),
                  ),
                  Text(
                    hotel.terms ?? 'Standard terms & conditions apply'.tr,
                    style: TextStyle(
                      fontStyle: hotel.description == null ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // REVIEWS
                  Container(
                    key: _reviewsSectionKey,
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reviews'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.textMain,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          if (_controller.isLoadingReviews.value) {
                            return _buildReviewsShimmer();
                          }
                          if (_controller.reviews.isEmpty) {
                            return Text(
                              'No reviews yet.'.tr,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: CustomColors.textMuted,
                              ),
                            );
                          }
                          return Column(
                            children: _controller.reviews.map((review) {
                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: CustomColors.surfaceWhite,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: CustomColors.borderColor.withOpacity(0.3)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          review.reviewerName,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        if (review.overallRating != null)
                                          HotelStars(rating: review.overallRating!),
                                      ],
                                    ),
                                    if (review.feedback != null && review.feedback!.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        review.feedback!,
                                        style: const TextStyle(color: CustomColors.textMain, fontSize: 14),
                                      ),
                                    ],
                                    if (review.detailRatings.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: review.detailRatings.map((dr) {
                                          return Chip(
                                            label: Text('${dr.service.capitalizeFirst?.tr ?? dr.service} ${dr.rating} ★', style: const TextStyle(fontSize: 11)),
                                            backgroundColor: CustomColors.cardSubtleBg,
                                            side: BorderSide.none,
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            visualDensity: VisualDensity.compact,
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }),
                      ],
                    ),
                  ),

                  // Extra padding so content isn't covered by the floating CheckAvailabilityBar
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CheckAvailabilityBar(
        rates: hotel.rates,
        onTap: () {
          Get.delete<BookingController>(force: true);
          Navigator.push(
            context, 
            CupertinoPageRoute(
              builder: (context) => RoomsScreen(hotel: hotel),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildReviewsShimmer() {
    return Column(
      children: List.generate(3, (index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }),
    );
  }

  IconData _getIconData(String? iconKey, String name) {
    final keys = [
      if (iconKey != null && iconKey.trim().isNotEmpty)
        iconKey.trim().toLowerCase().replaceAll(' ', '-').replaceAll('_', '-'),
      name.trim().toLowerCase().replaceAll(' ', '-').replaceAll('_', '-'),
    ];

    for (final normalized in keys) {
      switch (normalized) {
        case 'wifi':
        case 'wi-fi':
        case 'wi-fi-internet':
          return Icons.wifi;
        case 'pool':
        case 'swimming-pool':
          return Icons.pool;
        case 'room-service':
          return Icons.room_service;
        case 'parking':
          return Icons.local_parking;
        case 'restaurant':
          return Icons.restaurant;
        case 'gym':
        case 'fitness':
        case 'fitness-center':
          return Icons.fitness_center;
        case 'accessibility':
          return Icons.accessible;
        case 'air-conditioner':
        case 'ac':
          return Icons.ac_unit;
        case 'cards-accepted':
        case 'card-accepted':
        case 'credit-card':
          return Icons.credit_card;
        case 'club':
        case 'nightclub':
          return Icons.nightlife;
        case 'coffee-shop':
        case 'cafe':
          return Icons.local_cafe;
        case 'shuttle':
        case 'shuttle-bus':
        case 'shuttle-bus-service':
          return Icons.airport_shuttle;
        case 'elevator':
        case 'lift':
          return Icons.elevator;
      }
    }
    return Icons.check_circle_outline;
  }
}
