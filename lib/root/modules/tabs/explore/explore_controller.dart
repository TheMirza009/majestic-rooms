import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/root/modules/home/notifications_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:majestic_rooms/core/data/dummy_hotels.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';

class City {
  final String name;
  final String imageURL;
  const City({required this.name, required this.imageURL});
}

class ExploreController extends GetxController {

  final CommonController controller = Get.find<CommonController>();

  // ── Control Panel ────────────────────────────────────────────────────────
  static const List<String> categories = [
    'Mecca', 'Medina', 'Jeddah', 'Riyadh', 'Khobar', 'Dhahran', 'Abha',
  ];
  static const String _bucket = 'locations';

  // ── Fields ───────────────────────────────────────────────────────────────
  final searchQuery        = ''.obs;
  final selectedCategories = <int>{}.obs; // empty = no filter, show all hotels
  final cities          = <City>[].obs;
  final isLoadingImages = false.obs;
  final isSearching     = false.obs;
  final hotels          = <Hotel>[].obs;

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchCities();
    hotels.assignAll(kDummyHotels);
  }

  // ── Actions ──────────────────────────────────────────────────────────────
  /// Toggles a category chip. Tapping a selected chip deselects it.
  void selectCategory(int index) {
    if (selectedCategories.contains(index)) {
      selectedCategories.remove(index);
    } else {
      selectedCategories.add(index);
    }
  }

  Future<void> onSearchSubmit(String query) async {
    if (isSearching.value) return;

    if (query.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Search query cannot be empty',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    try {
      isSearching.value = true;
      var dbQuery = Supabase.instance.client
          .from('hotel')
          .select('*, hotel_images(*), hotel_rooms(*), hotel_facility(facility(*)), promotion(*)')
          .or('name.ilike.%$query%,location_slug.ilike.%$query%,address.ilike.%$query%');

      if (selectedCategories.isNotEmpty) {
        final selectedCities = selectedCategories.map((i) => categories[i]).toList();
        dbQuery = dbQuery.inFilter('location_slug', selectedCities);
      }

      final response = await dbQuery;
      
      final parsedHotels = (response as List).map((e) => Hotel.fromJson(e as Map<String, dynamic>)).toList();
      
      if (parsedHotels.isEmpty) {
        Fluttertoast.showToast(
          msg: 'No hotels found',
          toastLength: Toast.LENGTH_SHORT,
        );
      }

      _mergeHotels(parsedHotels);
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      isSearching.value = false;
    }
  }

  // — merge: add API results not already in the canonical list (by id)
  void _mergeHotels(List<Hotel> incoming) {
    final existingIds = hotels.map((h) => h.id).toSet();
    final newOnes = incoming.where((h) => !existingIds.contains(h.id)).toList();
    if (newOnes.isNotEmpty) hotels.addAll(newOnes);
  }

  void onFilter() {} // TODO: open filter sheet

  /// Hotels in the selected cities and matching the search query. With nothing selected, returns all hotels.
  List<Hotel> get filteredHotels {
    List<Hotel> result = hotels;
    
    if (selectedCategories.isNotEmpty) {
      final selectedCities = selectedCategories.map((i) => categories[i]).toSet();
      result = result.where((hotel) => selectedCities.contains(hotel.city)).toList();
    }
    
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((hotel) {
        final nameMatch = hotel.name.toLowerCase().contains(query);
        final cityMatch = hotel.city.toLowerCase().contains(query);
        final addressMatch = hotel.address?.toLowerCase().contains(query) ?? false;
        return nameMatch || cityMatch || addressMatch;
      }).toList();
    }
    
    return result;
  }

  void fetchCities() {
    final storage = Supabase.instance.client.storage;
    cities.value = categories.map((name) {
      final url = storage.from(_bucket).getPublicUrl('${name.toLowerCase()}.webp');
      return City(name: name, imageURL: url);
    }).toList();
    debugPrint("Cities: ${cities.value.map((city) {print("URL: " + city.imageURL + "\n Name: " + city.name);})}");
  }

  void openNotifications() {
    Navigator.push(Get.context!, CupertinoPageRoute(builder: (context) => const NotificationsScreen()));
  }

  @override
  void onClose() {
    super.onClose();
  }
}
