# Task List: Remove Dummy Data & Implement Pagination

- `[x]` 1. Delete `dummy_hotels.dart` and remove it from source control.
- `[x]` 2. Update `booking.dart` to remove the `kDummyHotels` fallback in `fromJson()`.
- `[x]` 3. Update `common_controller.dart` to load saved hotels from Supabase using `.inFilter()`.
- `[x]` 4. Update `explore_controller.dart` to remove local filtering and implement cursor-based pagination.
- `[x]` 5. Update `explore_screen.dart` to bind the new `ScrollController` and use the raw `hotels` list.
