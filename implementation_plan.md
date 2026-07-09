# Remove Dummy Data and Implement Lazy Loading

We will completely remove the local dummy hotels fallback, wire the application to fetch purely from Supabase, and implement cursor/offset pagination so that large datasets do not choke the app.

## Proposed Changes

### [DELETE] `lib/core/data/dummy_hotels.dart`
- Delete this file entirely to prevent any accidental fallbacks to mock data.

---

### [MODIFY] `lib/core/base/common_controller.dart`
- Remove the `kDummyHotels` fallback in `_loadSavedHotels`.
- Replace it with a Supabase query: `await Supabase.instance.client.from('hotel').select('*, hotel_images(*), hotel_rooms(*, room_images(*)), hotel_facility(facility(*)), promotion(*)').inFilter('slug', savedSlugs)`.
- This ensures saved hotels are fully loaded from the live DB.

---

### [MODIFY] `lib/core/data/models/booking.dart`
- Remove the `kDummyHotels` import and fallback inside `BookingModel.fromJson`.
- If the hotel object is missing from the JSON (which shouldn't happen based on the JOIN queries), it will gracefully fall back to a minimal empty `Hotel` object rather than searching mock data.

---

### [MODIFY] `lib/root/modules/tabs/explore/explore_controller.dart`
- Remove local filtering logic (`filteredHotels`). All filtering (categories and search) will now happen at the database level.
- Introduce pagination state: `int _currentPage = 0`, `bool _hasMore = true`, `static const int _pageSize = 10`.
- Implement `ScrollController scrollController` to track list scrolling.
- Create a unified `fetchHotels({bool isLoadMore = false})` method:
  - Constructs the DB query including search (`.or('name.ilike...')`) and categories (`.inFilter('location_slug')`).
  - Applies `.range()` for the current page.
  - Appends to or overwrites the `hotels` observable list.
- Attach a listener to `scrollController` to trigger `fetchHotels(isLoadMore: true)` when the user reaches the bottom.

---

### [MODIFY] `lib/root/modules/tabs/explore/explore_screen.dart`
- Assign `_controller.scrollController` to the `ListView`.
- Replace references to `_controller.filteredHotels` with `_controller.hotels`.
- Add a loading indicator at the bottom of the `ListView` when fetching the next page.

## Verification Plan

### Automated Tests
- No automated tests required for this UI refactor.

### Manual Verification
1. Run the app and ensure the Explore tab loads the first 10 hotels from Supabase.
2. Scroll to the bottom and verify the next chunk of hotels loads seamlessly.
3. Test search and category filters to ensure they reset the list and pull the correct filtered results from the database.
4. Verify saved hotels load correctly across app restarts.
