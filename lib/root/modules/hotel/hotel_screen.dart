import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/hotel/screens/rooms_screen.dart';
import 'package:majestic_rooms/root/modules/hotel/widgets/check_availability_bar.dart';
import 'package:majestic_rooms/root/modules/hotel/widgets/hotel_stars.dart';
import 'package:majestic_rooms/root/modules/hotel/widgets/image_carousel.dart';
import 'package:majestic_rooms/root/modules/hotel/widgets/licence_banner.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/favorite_button.dart';
import 'package:majestic_rooms/root/widgets/round_icon_button.dart';
import 'package:majestic_rooms/core/data/models/facility.dart';

class HotelScreen extends StatelessWidget {
  final Hotel hotel;
  const HotelScreen({super.key, required this.hotel});

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
              tag: hotel.imageUrl,
              child: Material(
                type: MaterialType.transparency,
                child: ImageCarousel(images: hotel.images.map((image) => image.url).toList()),
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
                      )).toList(),
                    ),
                    const SizedBox(height: 30),
                  ],

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
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CheckAvailabilityBar(
        rates: hotel.rates,
        onTap: () => Navigator.push(
          context, 
          CupertinoPageRoute(
            builder: (context) => const RoomsScreen(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  IconData _getIconData(String key) {
    switch (key) {
      case 'wifi':
        return Icons.wifi;
      case 'pool':
        return Icons.pool;
      case 'room_service':
      case 'room-service':
        return Icons.room_service;
      case 'parking':
        return Icons.local_parking;
      case 'restaurant':
        return Icons.restaurant;
      case 'gym':
      case 'fitness':
        return Icons.fitness_center;
      default:
        return Icons.check_circle_outline;
    }
  }
}
