import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/models/hotel.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/explore_search_bar.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/hotel_card.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CommonController controller = Get.find<CommonController>();
  

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isEmpty = controller.savedHotels.isEmpty;

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_outline_outlined, size: 40),
                    Text("No saved hotels"),
                  ],
                ),
              )
            : Column(
              spacing: 12,
              children: [
                ExploreSearchBar(
                  controller: _searchController, 
                  hintText: "Search your saved hotels",
                  showSuffixIcon: false,
                  ),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        final Hotel hotel = controller.savedHotels[index];
                        return HotelCard(
                          hotel: hotel,
                          initialSaveValue: controller.savedHotels.contains(hotel),
                          onSaveTap: (_) => controller.toggleHotelSave(hotel),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemCount: controller.savedHotels.length,
                    ),
                ),
              ],
            ),
      );
    });
  }
}
