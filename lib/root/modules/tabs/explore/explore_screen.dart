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
import 'package:shimmer/shimmer.dart';

// Shimmer colours — match HotelCard's own shimmer palette
const Color _shimmerBase      = Color.fromARGB(255, 212, 212, 212);
const Color _shimmerHighlight = Color.fromARGB(255, 243, 243, 243);

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
    if (_controller.isSearching.value) return;
    _controller.clearSearch();
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
          RepaintBoundary(child: ProfileBar(onNotificationsTap: _controller.openNotifications)),

          // SEARCH
          Obx(
            () => ExploreSearchBar(
              controller: _controller.searchController,
              isSearching: _controller.isSearching.value,
              isFilterOn: _controller.isFilterOn.value,
              onSearchTap: () => _controller.onSearchSubmit(_controller.searchController.text),
              onFilterTap: _controller.onFilter,
              onSubmitted: _controller.onSearchSubmit,
              onClear: _onClear,
            ),
          ),

          // CATEGORIES
          Obx(
            () => AnimatedSwitcher(
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
              child: _controller.isFilterOn.value
                  ? CityChips(
                      key: const ValueKey('city-chips-visible'),
                      categories: ExploreController.categories,
                      cities: _controller.cities,
                      selectedIndices: _controller.selectedCategories.toSet(),
                      isLoading: _controller.isLoadingImages.value,
                      isLocked: _controller.isSearching.value,
                      onSelected: _controller.selectCategory,
                    )
                  : const SizedBox.shrink(key: ValueKey('city-chips-hidden')),
            ),
          ),

          // HOTELS
          Expanded(
            child: Obx(() {
              final isInitial = _controller.isInitialLoading.value;
              final hotels = _controller.hotels;
              final saved = _controller.controller.savedHotels.toList();
              final hasSearchQuery = _controller.searchQuery.value.trim().isNotEmpty;

              // SKELETON — shown during the very first load
              if (isInitial) {
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (_, __) => AspectRatio(
                    aspectRatio: 3 / 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // IMAGE AREA
                          Shimmer.fromColors(
                            baseColor: _shimmerBase,
                            highlightColor: _shimmerHighlight,
                            period: const Duration(milliseconds: 1200),
                            child: Container(color: _shimmerBase),
                          ),
                          // INFO PANEL — mirrors the real dark card
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: 0.25,
                              widthFactor: 1.0,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: const Color(0xB3000000),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    child: Shimmer.fromColors(
                                      baseColor: const Color(0xFF555555),
                                      highlightColor: const Color(0xFF888888),
                                      period: const Duration(milliseconds: 1200),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // NAME placeholder
                                          Container(
                                            height: 22,
                                            width: 240,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          // ADDRESS placeholder
                                          Container(
                                            height: 10,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          // RATING placeholder
                                          Container(
                                            height: 10,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              Widget content;
              if (hotels.isEmpty && hasSearchQuery) {
                content = const NoResultsWidget(key: ValueKey('no-results'));
              } else if (hotels.isEmpty) {
                // EMPTY STATE — no hotels in cache and no active search
                content = Center(
                  key: const ValueKey('no-hotels'),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.hotel_outlined,
                        size: 64,
                        color: CustomColors.textMuted.withValues(alpha: 0.35),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No hotels to show'.tr,
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.textMuted.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                content = Column(
                  key: const ValueKey('hotel-list'),
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
                                  hotels.length == 1 ? 'result_found'.trParams({'count': hotels.length.toString()}) : 'results_found'.trParams({'count': hotels.length.toString()}),
                                  style: const TextStyle(fontSize: 14, color: CustomColors.textMuted),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(key: ValueKey('empty-count')),
                    ),

                    // LIST
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _controller.refreshHotels,
                        color: CustomColors.brandRed,
                        child: ListView.separated(
                          controller: _controller.scrollController,
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: hotels.length + 1,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (_, _) => const SizedBox(height: 16),
                          itemBuilder: (_, index) {
                            // Padding box / Loading Indicator
                            if (index == hotels.length) {
                              return SizedBox(
                                height: 70,
                                width: double.infinity,
                                child: Center(
                                  child: _controller.isLoadingMore.value
                                      ? const CircularProgressIndicator(strokeWidth: 2, color: CustomColors.brandRed)
                                      : const SizedBox.shrink(),
                                ),
                              );
                            }

                            // Single hotel item
                            final hotel = hotels[index];

                            // Main Hotel display card
                            return HotelCard(
                              hotel: hotel,
                              heroTag: '${hotel.id}_explore',
                              initialSaveValue: saved.contains(hotel),
                              onSaveTap: (_) => _controller.controller.toggleHotelSave(hotel),
                              onTap: () => Get.to(() => HotelScreen(
                                hotel: hotel,
                                heroTag: '${hotel.id}_explore',
                              )),
                            );
                          },
                        ),
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
