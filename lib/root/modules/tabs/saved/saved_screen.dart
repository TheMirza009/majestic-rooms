import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/root/modules/hotel/hotel_screen.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/explore_search_bar.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/hotel_card.dart';
import 'package:majestic_rooms/root/widgets/no_results_widget.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CommonController controller = Get.find<CommonController>();
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
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
                    Text('No saved hotels'.tr),
                  ],
                ),
              )
            : Column(
              spacing: 12,
              children: [
                ExploreSearchBar(
                  controller: _searchController, 
                  hintText: 'Search your saved hotels'.tr,
                  showSuffixIcon: false,
                  ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final query = _searchController.text.trim().toLowerCase();
                      var hotels = controller.savedHotels.toList();
                      
                      if (query.isNotEmpty) {
                        hotels = hotels.where((hotel) {
                          final nameMatch = hotel.name.toLowerCase().contains(query);
                          final cityMatch = hotel.city.toLowerCase().contains(query);
                          final addressMatch = hotel.address?.toLowerCase().contains(query) ?? false;
                          return nameMatch || cityMatch || addressMatch;
                        }).toList();
                      }
                      
                      if (hotels.isEmpty && query.isNotEmpty) {
                        return const NoResultsWidget();
                      }
                      
                      return ListView.separated(
                          itemBuilder: (context, index) {
                            final Hotel hotel = hotels[index];
                            return HotelCard(
                              hotel: hotel,
                              heroTag: '${hotel.id}_saved',
                              initialSaveValue: controller.savedHotels.contains(hotel),
                              onSaveTap: (_) => confirmRemoveDialog(context, hotel),
                              onTap: () => Get.to(() => HotelScreen(
                                hotel: hotel,
                                heroTag: '${hotel.id}_saved',
                              )),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemCount: hotels.length,
                        );
                    }
                  ),
                ),
              ],
            ),
      );
    });
  }

  Future<void> confirmRemoveDialog(BuildContext context, Hotel hotel) async {
    return await showAdaptiveDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Remove from saved'.tr),
        content: Text('Are you sure you want to remove this hotel from your saved list?'.tr),
        actionsPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              controller.toggleHotelSave(hotel);
              Navigator.pop(context);
            },
            child: Text('Remove'.tr),
          ),
        ],
      );
    });
  }
}
