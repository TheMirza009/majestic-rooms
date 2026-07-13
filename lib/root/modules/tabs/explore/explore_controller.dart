import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/root/modules/home/notifications_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:majestic_rooms/core/utils/helper.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';

// Top-level functions to run heavy parsing in a separate isolate
List<Hotel> _parseHotelsWithDebugLog(dynamic response) {
  debugPrint("Search response: ${response.toString()}");
  return (response as List)
      .map((e) => Hotel.fromJson(e as Map<String, dynamic>))
      .toList();
}

List<Hotel> _parseHotels(dynamic response) {
  return (response as List)
      .map((e) => Hotel.fromJson(e as Map<String, dynamic>))
      .toList();
}

class City {
  final String name;
  final String imageURL;
  const City({required this.name, required this.imageURL});
}

class ExploreController extends GetxController {
  final CommonController controller = Get.find<CommonController>();

  // ── Control Panel ────────────────────────────────────────────────────────
  static const List<String> categories = [
    'Mecca',
    'Medina',
    'Jeddah',
    'Riyadh',
    'Khobar',
    'Dhahran',
    'Abha',
  ];
  static const String _bucket = 'locations';
  // Single source of truth for the Supabase select clause used in every query.
  static const String _dbSelect =
      '*, hotel_images(*), hotel_rooms(*, room_images(*)), hotel_facility(facility(*)), promotion(*)';

  // ── Fields ───────────────────────────────────────────────────────────────
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedCategories = <int>{}.obs; // empty = no filter, show all hotels
  final cities = <City>[].obs;
  final isLoadingImages = false.obs;
  /// True only while an explicit user search is in flight. Drives the searchbar spinner.
  final isSearching = false.obs;
  /// True only during the very first page load. Drives shimmer skeletons in the list.
  final isInitialLoading = true.obs;
  /// True when the search text field is non-empty. Used by back-press handling.
  final hasActiveSearch = false.obs;
  final isFilterOn = true.obs;
  final hotels = <Hotel>[].obs;

  // ── Pagination Fields ────────────────────────────────────────────────────
  final ScrollController scrollController = ScrollController();
  int _currentPage = 0;
  static const int _pageSize = 10;
  final isLoadingMore = false.obs;

  // ── Cache ─────────────────────────────────────────────────────────────────
  /// Master in-memory store of all hotels fetched from Supabase (all pages,
  /// all searches). Never cleared after the initial load completes.
  final List<Hotel> _masterCache = [];
  /// True when the server has no more pages to offer for the no-filter query.
  bool _allPagesLoaded = false;
  /// Maps a trimmed search query → the hotels returned for that query.
  /// Prevents re-fetching the same search.
  final Map<String, List<Hotel>> _searchCache = {};

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      final newText = searchController.text;
      if (searchQuery.value != newText) {
        searchQuery.value = newText;
        hasActiveSearch.value = newText.trim().isNotEmpty;
        _applyFilters();
      }
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        fetchHotels(isLoadMore: true);
      }
    });
    fetchCities();
    fetchHotels();
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  /// Toggles a category chip. Locked while a search is in flight.
  void selectCategory(int index) {
    if (isSearching.value) return; // chips are locked while searching
    if (selectedCategories.contains(index)) {
      selectedCategories.remove(index);
    } else {
      selectedCategories.add(index);
    }
    _applyFilters();
  }

  List<String> _mapCategoryToSlugs(String category) {
    final lower = category.toLowerCase();
    if (lower == 'mecca' || lower == 'makkah') {
      return ['mecca', 'makkah'];
    }
    if (lower == 'medina' || lower == 'madinah') {
      return ['medina', 'madinah'];
    }
    return [lower];
  }

  Future<void> onSearchSubmit(String query) async {
    final q = query.trim();
    if (q.isEmpty && searchQuery.value.trim().isEmpty) {
      Utils.showToast('Search query cannot be empty'.tr);
      return;
    }
    final effectiveQuery = q.isNotEmpty ? q : searchQuery.value.trim();
    if (_searchCache.containsKey(effectiveQuery)) {
      // Cache hit — derive from in-memory data, no network call needed.
      _applyFilters();
      return;
    }
    await _searchHotels(effectiveQuery);
  }

  /// Resets the search field and restores the master cache into view.
  void clearSearch() {
    searchController.clear();
    // searchQuery and hasActiveSearch are updated by the listener above.
    _applyFilters();
  }

  /// Invalidates the entire in-memory cache and re-fetches page 0 from the
  /// server. Called by the pull-to-refresh gesture.
  Future<void> refreshHotels() async {
    _masterCache.clear();
    _searchCache.clear();
    _allPagesLoaded = false;
    _currentPage = 0;
    await fetchHotels();
  }


  // ── Fetch ──────────────────────────────────────────────────────────────────

  Future<void> fetchHotels({bool isLoadMore = false}) async {
    if (isLoadMore) {
      // — guard: skip if all pages are loaded or a page is already loading
      if (_allPagesLoaded || isLoadingMore.value) return;
      isLoadingMore.value = true;
      await _loadNextPage();
      _applyFilters();
      isLoadingMore.value = false;
      return;
    }

    // — initial load: skip entirely if the cache already has data
    if (_masterCache.isNotEmpty) {
      _applyFilters();
      return;
    }

    isInitialLoading.value = true;
    try {
      final response = await Supabase.instance.client
          .from('hotel')
          .select(_dbSelect)
          .range(0, _pageSize - 1);

      final parsedHotels = await compute(_parseHotels, response);
      _mergeIntoCache(parsedHotels);
      _currentPage = 1;
      if (parsedHotels.length < _pageSize) _allPagesLoaded = true;
      _applyFilters();
    } catch (e) {
      debugPrint("Fetch hotels error: $e");
      if (e is PostgrestException && (e.code == 'PGRST303' || e.message.toLowerCase().contains('jwt expired'))) {
        controller.showSessionExpiredDialog();
      }
    } finally {
      isInitialLoading.value = false;
    }
  }

  /// Fetches the next page (no filters) and appends unique results to the cache.
  Future<void> _loadNextPage() async {
    try {
      final from = _currentPage * _pageSize;
      final to = from + _pageSize - 1;
      final response = await Supabase.instance.client
          .from('hotel')
          .select(_dbSelect)
          .range(from, to);

      final parsedHotels = await compute(_parseHotels, response);
      _mergeIntoCache(parsedHotels);
      _currentPage++;
      if (parsedHotels.length < _pageSize) _allPagesLoaded = true;
    } catch (e) {
      debugPrint("Load next page error: $e");
      if (e is PostgrestException && (e.code == 'PGRST303' || e.message.toLowerCase().contains('jwt expired'))) {
        controller.showSessionExpiredDialog();
      }
    }
  }

  /// Fetches Supabase for [query], merges unique results into [_masterCache]
  /// and stores them in [_searchCache]. Sets [isSearching] for the duration.
  Future<void> _searchHotels(String query) async {
    isSearching.value = true;
    try {
      final response = await Supabase.instance.client
          .from('hotel')
          .select(_dbSelect)
          .or('name.ilike.%$query%,location_slug.ilike.%$query%,address.ilike.%$query%');

      final parsedHotels = await compute(_parseHotelsWithDebugLog, response);
      _searchCache[query] = parsedHotels;
      _mergeIntoCache(parsedHotels);
      _applyFilters();

      if (hotels.isEmpty) Utils.showToast('No hotels found'.tr);
    } catch (e) {
      debugPrint("Search hotels error: $e");
      if (e is PostgrestException && (e.code == 'PGRST303' || e.message.toLowerCase().contains('jwt expired'))) {
        controller.showSessionExpiredDialog();
      }
    } finally {
      isSearching.value = false;
    }
  }

  // ── Filter ─────────────────────────────────────────────────────────────────

  /// Derives the visible [hotels] list from [_masterCache] by applying the
  /// active search query and selected city chips. Pure in-memory — no network.
  void _applyFilters() {
    final query = searchQuery.value.trim().toLowerCase();
    final hasQuery = query.isNotEmpty;

    // — determine the base list
    // If a search is active, start from the cached search results so chips
    // filter within the results rather than the full master list.
    List<Hotel> base;
    if (hasQuery && _searchCache.containsKey(query)) {
      base = _searchCache[query]!;
    } else {
      base = _masterCache;
    }

    // — apply city chip filter
    if (selectedCategories.isNotEmpty) {
      final selectedSlugs = selectedCategories
          .expand((i) => _mapCategoryToSlugs(categories[i]))
          .toSet();
      base = base.where((h) => selectedSlugs.contains(h.city)).toList();
    }

    // — apply text filter (only if there's no cached search result for this query,
    //   meaning the user hasn't submitted yet but has typed something)
    if (hasQuery && !_searchCache.containsKey(query)) {
      base = base.where((h) {
        final name = h.name.toLowerCase();
        final city = h.city.toLowerCase();
        final address = (h.address ?? '').toLowerCase();
        return name.contains(query) ||
            city.contains(query) ||
            address.contains(query);
      }).toList();
    }

    hotels.assignAll(base);
  }

  /// Adds hotels from [incoming] that are not already in [_masterCache].
  void _mergeIntoCache(List<Hotel> incoming) {
    final existingIds = _masterCache.map((h) => h.id).toSet();
    for (final hotel in incoming) {
      if (!existingIds.contains(hotel.id)) {
        _masterCache.add(hotel);
        existingIds.add(hotel.id);
      }
    }
  }

  // ── Utilities ─────────────────────────────────────────────────────────────

  void onFilter() {
    isFilterOn.value = !isFilterOn.value;
  }

  void fetchCities() {
    final storage = Supabase.instance.client.storage;
    cities.value = categories.map((name) {
      final url = storage
          .from(_bucket)
          .getPublicUrl('${name.toLowerCase()}.webp');
      return City(name: name, imageURL: url);
    }).toList();
  }

  void openNotifications() {
    Navigator.push(
      Get.context!,
      CupertinoPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
