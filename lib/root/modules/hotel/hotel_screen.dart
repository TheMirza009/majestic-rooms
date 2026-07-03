import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
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

class HotelScreen extends StatelessWidget {
  final Hotel hotel;
  final String? heroTag;
  const HotelScreen({super.key, required this.hotel, this.heroTag});

  @override
  Widget build(BuildContext context) {
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
              onTap: () => print("Share"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 10.0),
            child: Obx(() {
              final CommonController controller = Get.find<CommonController>();
              return FavoriteButton(
                value: controller.savedHotels.contains(hotel),
                onChanged: (_) {
                  controller.toggleHotelSave(hotel);
                },
              );
            }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: heroTag ?? hotel.imageUrl,
              child: Material(
                type: MaterialType.transparency,
                child: Stack(
                  children: [
                    ImageCarousel(images: hotel.images.map((image) => image.url).toList()),
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
                                '${hotel.activePromotion!.discountPercent}% OFF',
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
                    hotel.address ?? "In a Galaxy far away", 
                    style: const TextStyle(fontSize: 20, color: CustomColors.textMain),
                  ),

                  // STARS
                  HotelStars(rating: hotel.rating),
                  SizedBox(height: 40),
                  
                  // ABOUT
                  Text(
                    "About",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.textMain,
                    ),
                  ),
                  Text(
                    hotel.description?.isEmpty ?? true ? "No description given" : hotel.description!,
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
                    const Text(
                      "Services",
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
                        label: Text(f.name),
                        avatar: f.icon != null ? Icon(_getIconData(f.icon!), size: 18, color: CustomColors.brandRed) : null,
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
                    "Location",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.textMain,
                    ),
                  ),
                  if (hotel.distanceFromHaram != null) Text(
                    "${hotel.distanceFromHaram} KM from the Haram",
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
                    "Policies",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.textMain,
                    ),
                  ),
                  Text(
                    hotel.terms ?? "Standard terms & conditions apply",
                    style: TextStyle(
                      fontStyle: hotel.description == null ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                  // Extra padding so content isn't covered by the floating CheckAvailabilityBar
                  const SizedBox(height: 200),
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

  IconData _getIconData(String key) {
    final normalized = key.toLowerCase().replaceAll(' ', '-').replaceAll('_', '-');
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
      default:
        return Icons.check_circle_outline;
    }
  }
}
