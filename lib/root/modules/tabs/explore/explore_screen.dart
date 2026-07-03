import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/hotel/hotel_screen.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/explore_controller.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/city_chips.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/explore_search_bar.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/hotel_card.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/profile_bar.dart';
import 'package:majestic_rooms/root/widgets/no_results_widget.dart';

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

  void _onClear() {
    if (_controller.isSearching.value) {
      return;
    }
    _controller.searchController.clear();
    // The addListener in initState syncs _controller.searchQuery automatically.
    // filteredHotels then returns all entries in the canonical hotels list.
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
          RepaintBoundary(child: ProfileBar(onNotificationsTap: _controller.openNotifications)), // fetchCities
    
          // SEARCH
          Obx(
            () => ExploreSearchBar(
              controller: _controller.searchController,
              isSearching: _controller.isSearching.value,
              onSearchTap: () => _controller.onSearchSubmit(_controller.searchController.text),
              onFilterTap: _controller.onFilter,
              onSubmitted: _controller.onSearchSubmit,
              onClear: _onClear,
            ),
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
              final saved = _controller.controller.savedHotels.toList(); // synchronous evaluation tracks the dependency
              final hasSearchQuery = _controller.searchQuery.value.trim().isNotEmpty;
              
              Widget content;
              if (hotels.isEmpty && hasSearchQuery) {
                content = const NoResultsWidget(key: ValueKey('no-results'));
              } else {
                content = Column(
                  key: ValueKey(hotels.map((h) => h.id).join('-')),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: -1.0,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: hasSearchQuery
                          ? Padding(
                              key: const ValueKey('results-count'),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '${hotels.length} result${hotels.length == 1 ? '' : 's'} found',
                                  style: const TextStyle(fontSize: 14, color: CustomColors.textMuted),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(key: ValueKey('empty-count')),
                    ),

                    // LIST
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: hotels.length + 1,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (_, index) {
                          // Padding box
                          if (index == hotels.length) {
                            return const SizedBox(
                              height: 70,
                              width: double.infinity,
                            );
                          }
            
                          // Single hotel item
                          final hotel = hotels[index];
            
                          // Main Hotel display card
                          return HotelCard(
                            hotel: hotel,
                            heroTag: '${hotel.imageUrl}_explore',
                            initialSaveValue: saved.contains(hotel),
                            onSaveTap: (_) => _controller.controller.toggleHotelSave(hotel),
                            onTap: () => Get.to(() => HotelScreen(
                              hotel: hotel,
                              heroTag: '${hotel.imageUrl}_explore',
                            )),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              return AnimatedOpacity(
                opacity: _controller.isSearching.value ? 0.7 : 1.0,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                    );
                  },
                  child: content,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
