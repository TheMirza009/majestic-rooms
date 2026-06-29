import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/explore_controller.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/city_chips.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/explore_search_bar.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/hotel_card.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/profile_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late final ExploreController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ExploreController());
  }

  @override
  void dispose() {
    Get.delete<ExploreController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PROFILE
          ProfileBar(onNotificationsTap: _controller.fetchCities),
    
          // SEARCH
          ExploreSearchBar(
            controller: _controller.searchController,
            onSearchTap: _controller.onSearch,
            onFilterTap: _controller.onFilter,
          ),
    
          // CATEGORIES
          Obx(
            () => CityChips(
              categories: ExploreController.categories,
              cities: _controller.cities,
              selectedIndices: _controller.selectedCategories.toSet(),
              isLoading: _controller.isLoadingImages.value,
              onSelected: _controller.selectCategory,
            ),
          ),
    
          // HOTELS
          Expanded(
            child: Obx(() {
              final hotels = _controller.filteredHotels;
              final saved = _controller.controller.savedHotels.value;
              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: hotels.length + 1,
                physics: BouncingScrollPhysics(),
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  // Padding box
                  if (index == hotels.length) {
                    return Container(
                      decoration: BoxDecoration(),
                      height: 70,
                      width: double.infinity,
                    );
                  }
    
                  // Single hotel item
                  final hotel = hotels[index];
    
                  // Main Hotel display card
                  return HotelCard(
                    hotel: hotel,
                    initialSaveValue: saved.contains(hotel),
                    onSaveTap: (_) => _controller.controller.toggleHotelSave(hotel),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
