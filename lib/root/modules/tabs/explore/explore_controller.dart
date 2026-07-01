import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final searchController   = TextEditingController();
  final selectedCategories = <int>{}.obs; // empty = no filter, show all hotels
  final cities          = <City>[].obs;
  final isLoadingImages = false.obs;
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

  void onSearch() {} // TODO: trigger search
  void onFilter() {} // TODO: open filter sheet

  /// Hotels in the selected cities. With nothing selected, returns all hotels.
  List<Hotel> get filteredHotels {
    if (selectedCategories.isEmpty) return hotels;
    final selectedCities = selectedCategories.map((i) => categories[i]).toSet();
    return hotels.where((hotel) => selectedCities.contains(hotel.city)).toList();
  }

  void fetchCities() {
    final storage = Supabase.instance.client.storage;
    cities.value = categories.map((name) {
      final url = storage.from(_bucket).getPublicUrl('${name.toLowerCase()}.webp');
      return City(name: name, imageURL: url);
    }).toList();
    debugPrint("Cities: ${cities.value.map((city) {print("URL: " + city.imageURL + "\n Name: " + city.name);})}");
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
