# Graph Report - majestic-rooms  (2026-07-14)

## Corpus Check
- 114 files · ~148,110 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1458 nodes · 2048 edges · 95 communities (90 shown, 5 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 14 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `3c928527`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- entry_field.dart
- hotel_card.dart
- booking.dart
- explore_controller.dart
- update_password_screen.dart
- round_icon_button.dart
- custom_date_range_picker.dart
- booking_success_screen.dart
- custom_calender.dart
- hotel.dart
- profile_screen.dart
- custom_button.dart
- Table Reference
- common_controller.dart
- explore_screen.dart
- package:flutter/material.dart
- constants.dart
- hotel_screen.dart
- city_chips.dart
- custom_colors.dart
- glass_nav_item.dart
- explore_search_bar.dart
- login_screen.dart
- signup_screen.dart
- StatelessWidget
- bump_version.dart
- FlutterWindow
- main.dart
- State
- about_screen.dart
- CLAUDE_FLUTTER_UI.md
- home_screen.dart
- win32_window.cpp
- hotel_room.dart
- booking_controller.dart
- context_extensions.dart
- login_controller.dart
- helper.dart
- image_viewer_screen.dart
- image_carousel.dart
- profile_avatar_flight_controller.dart
- review.dart
- rooms_screen.dart
- user_controller.dart
- Class Refactor Workflow
- city_avatar.dart
- glass_bottom_nav.dart
- profile_bar.dart
- wWinMain
- supabase_utils.dart
- Win32Window
- types.ts
- room_image.dart
- room_card.dart
- promotion.dart
- field_clear_button.dart
- CupertinoPageRoute
- facility.dart
- package:supabase_flutter/supabase_flutter.dart
- widget_extensions.dart
- app_pages.dart
- booking_screenshot_widget.dart
- selected_rooms_list.dart
- maps_preview.dart
- MessageHandler
- booking_card.dart
- hotel_screen_controller.dart
- user_avatar.dart
- summary_card.dart
- scratch.py
- login_binding.dart
- CommonController
- package:majestic_rooms/core/data/models/hotel.dart
- VoidCallback?
- CLAUDE.md
- Hard-Cut Policy
- promotional_banner.dart
- app_translations.dart
- static const
- List
- BookingController
- Map
- HomeController
- LoginController
- RegisterPlugins
- Majestic Rooms
- MainActivity
- Intent
- task.md
- Rect?
- String?

## God Nodes (most connected - your core abstractions)
1. `Table Reference` - 20 edges
2. `Win32Window` - 19 edges
3. `CommonController` - 16 edges
4. `MessageHandler` - 12 edges
5. `Class Refactor Workflow` - 12 edges
6. `FlutterWindow` - 10 edges
7. `Create` - 10 edges
8. `WndProc` - 10 edges
9. `BookingController` - 9 edges
10. `CLAUDE_FLUTTER_UI.md` - 9 edges

## Surprising Connections (you probably didn't know these)
- `OnCreate` --calls--> `RegisterPlugins()`  [INFERRED]
  windows/runner/flutter_window.h → windows/flutter/generated_plugin_registrant.cc
- `wWinMain()` --calls--> `CreateAndAttachConsole()`  [INFERRED]
  windows/runner/main.cpp → windows/runner/utils.cpp
- `Win32Window::Win32Window()` --calls--> `Destroy`  [INFERRED]
  windows/runner/win32_window.cpp → windows/runner/win32_window.h
- `FlutterWindow` --inherits--> `Win32Window`  [EXTRACTED]
  windows/runner/flutter_window.h → windows/runner/win32_window.h
- `OnCreate` --calls--> `GetClientArea`  [INFERRED]
  windows/runner/flutter_window.h → windows/runner/win32_window.h

## Import Cycles
- None detected.

## Communities (95 total, 5 thin omitted)

### Community 0 - "entry_field.dart"
Cohesion: 0.03
Nodes (58): FocusNode?, InputDecoration?, autofocus, _border, borderColor, borderRadius, _borderWidth, build (+50 more)

### Community 1 - "hotel_card.dart"
Cohesion: 0.04
Nodes (47): ImageStream?, ImageStreamListener, _borderColor, build, _cardPadding, _contentPadding, DateRangeSelectionCard, _editStyle (+39 more)

### Community 2 - "booking.dart"
Cohesion: 0.05
Nodes (42): bookingDate, BookingDetailItem, BookingStatus, checkInDate, checkOutDate, _dateString, details, detailsToInsertJson (+34 more)

### Community 3 - "explore_controller.dart"
Cohesion: 0.05
Nodes (41): _allPagesLoaded, _applyFilters, _bucket, categories, cities, clearSearch, controller, _currentPage (+33 more)

### Community 4 - "update_password_screen.dart"
Cohesion: 0.05
Nodes (39): IconData?, animationDuration, build, cardRadius, confirmPasswordController, createState, currentPasswordController, dispose (+31 more)

### Community 5 - "round_icon_button.dart"
Cohesion: 0.05
Nodes (36): Animation, AnimationController, Duration, _activeColor, _bgColor, _bounceDuration, build, _controller (+28 more)

### Community 6 - "custom_date_range_picker.dart"
Cohesion: 0.06
Nodes (35): DateTime?, animationController, animationDuration, backgroundColor, barrierDismissible, build, createState, CustomDateRangePicker (+27 more)

### Community 7 - "booking_success_screen.dart"
Cohesion: 0.06
Nodes (34): _animationDuration, _animController, _backToExploring, booking, build, _buildChipButton, _captureAndAction, createState (+26 more)

### Community 8 - "custom_calender.dart"
Cohesion: 0.06
Nodes (34): alignmentForIndex, animationCurve, animationDuration, baseMonth, build, createState, currentMonthDate, datesForMonth (+26 more)

### Community 9 - "hotel.dart"
Cohesion: 0.06
Nodes (30): activePromotion, address, city, description, distanceFromHaram, email, facilities, fromJson (+22 more)

### Community 10 - "profile_screen.dart"
Cohesion: 0.07
Nodes (28): _avatarAnim, _avatarAnimDuration, _avatarAnimStartScale, _avatarKey, _avatarOpacity, _avatarScale, _avatarSize, createState (+20 more)

### Community 11 - "custom_button.dart"
Cohesion: 0.07
Nodes (26): BoxDecoration?, borderColor, borderRadius, btnColor, build, color, createState, decoration (+18 more)

### Community 12 - "Table Reference"
Cohesion: 0.07
Nodes (26): `accounts`, Auth, `blog_post`, `booking`, `booking_detail`, Enums, `facilities` — ⚠️ likely unused, see note, `facility` (+18 more)

### Community 13 - "common_controller.dart"
Cohesion: 0.07
Nodes (26): addBooking, _authSubscription, bookings, changeLanguage, currencySymbol, currentUser, fetchBookings, _initData (+18 more)

### Community 14 - "explore_screen.dart"
Cohesion: 0.09
Nodes (25): build, _controller, createState, ExploreScreen, _ExploreScreenState, initState, _onClear, _shimmerBase (+17 more)

### Community 15 - "package:flutter/material.dart"
Cohesion: 0.10
Nodes (20): AppTheme, build, NotificationsScreen, build, LicenceBanner, licenceNo, build, _getCurrencyName (+12 more)

### Community 16 - "constants.dart"
Cohesion: 0.09
Nodes (20): googleIcon, ImageAssets, instance, logoBlack, logoWhiteFull, logoWhiteSymbol, tuneOff, VectorStrings (+12 more)

### Community 17 - "hotel_screen.dart"
Cohesion: 0.09
Nodes (22): _buildReviewsShimmer, createState, _controller, dispose, _getIconData, heroTag, hotel, HotelScreen (+14 more)

### Community 18 - "city_chips.dart"
Cohesion: 0.09
Nodes (22): _activeBg, _activeText, _animCurve, _animDuration, _borderColor, build, categories, _chipKeys (+14 more)

### Community 19 - "custom_colors.dart"
Cohesion: 0.10
Nodes (20): bgLight, borderColor, brandBlack, brandGrey, brandRed, brandWhite, cardSubtleBg, CustomColors (+12 more)

### Community 20 - "glass_nav_item.dart"
Cohesion: 0.10
Nodes (20): _activeBg, _activeIconColor, _activeIconSize, _activePaddingH, _animCurve, _animDuration, build, GlassNavItem (+12 more)

### Community 21 - "explore_search_bar.dart"
Cohesion: 0.10
Nodes (20): _border, build, controller, ExploreSearchBar, _fill, _focusBorder, hintText, isFilterOn (+12 more)

### Community 22 - "login_screen.dart"
Cohesion: 0.10
Nodes (19): _borderRadius, _btnTextDark, _btnTextStyle, _buttonHeight, _compactBreakpoint, _fieldHeight, _fieldPadding, _gapLarge (+11 more)

### Community 23 - "signup_screen.dart"
Cohesion: 0.10
Nodes (19): _borderRadius, _btnTextStyle, build, _buttonHeight, _compactBreakpoint, _fieldHeight, _fieldPadding, _gapLarge (+11 more)

### Community 24 - "StatelessWidget"
Cohesion: 0.11
Nodes (18): BookingScreenshotWidget, amount, build, label, PriceBreakdown, _PriceRow, SelectedRoomsList, BookingCard (+10 more)

### Community 25 - "bump_version.dart"
Cohesion: 0.10
Nodes (19): buildNum, constantsContent, constantsFile, constantsRegex, main, major, majorVer, match (+11 more)

### Community 26 - "FlutterWindow"
Cohesion: 0.12
Nodes (16): FlutterViewController, unique_ptr, DartProject, HWND, LPARAM, LRESULT, UINT, WPARAM (+8 more)

### Community 27 - "main.dart"
Cohesion: 0.11
Nodes (18): build, countryCode, initialize, initializeDateFormatting, initialRoute, langCode, locale, main (+10 more)

### Community 28 - "State"
Cohesion: 0.16
Nodes (19): BookingSuccessScreen, _BookingSuccessScreenState, BookingSummaryScreen, _BookingSummaryScreenState, CustomCalendar, CustomCalendarState, FavoriteButton, _FavoriteButtonState (+11 more)

### Community 29 - "about_screen.dart"
Cohesion: 0.11
Nodes (18): AboutScreen, build, description, infoExpansionTile, infoListTile, _licenseLabel, _licenseNumber, missionContent (+10 more)

### Community 30 - "CLAUDE_FLUTTER_UI.md"
Cohesion: 0.11
Nodes (17): 2a. Event handlers, 2b. Reused constants and styles, 3a. One uninterrupted tree, 3b. Comment section markers, 3c. Const correctness, CLAUDE_FLUTTER_UI.md, Failing examples (do NOT extract these), Flutter UI Refactor: Monolith Structure Rules (+9 more)

### Community 31 - "home_screen.dart"
Cohesion: 0.12
Nodes (16): DecimalTextInputFormatter, _exp, formatEditUpdate, UpperCaseTextFormatter, build, buildAppBar, _titles, package:flutter/rendering.dart (+8 more)

### Community 32 - "win32_window.cpp"
Cohesion: 0.18
Nodes (14): Point, Size, wchar_t, Scale(), Create, Destroy, UpdateTheme, Win32Window::Win32Window() (+6 more)

### Community 33 - "hotel_room.dart"
Cohesion: 0.12
Nodes (16): beds, category, cityView, description, fromJson, hotelSlug, id, images (+8 more)

### Community 34 - "booking_controller.dart"
Cohesion: 0.12
Nodes (16): cancelBooking, clearState, dateRange, decrementRoom, getRoomQuantity, hotel, incrementRoom, isBooking (+8 more)

### Community 35 - "context_extensions.dart"
Cohesion: 0.15
Nodes (14): bool get, BuildContext, double get, baseHeight, baseWidth, DeviceTypeExtension, EscapePopExtension, isMobileWidth (+6 more)

### Community 36 - "login_controller.dart"
Cohesion: 0.13
Nodes (14): FormState, confirmPasswordController, emailController, formKey, isLoading, isPasswordVisible, onClose, passwordController (+6 more)

### Community 37 - "helper.dart"
Cohesion: 0.13
Nodes (14): kIsWindows, launchEmail, launchPhone, launchWebUrl, logoutDialog, showAboutDialog, showBottomSnackBar, showBottomSnackBarError (+6 more)

### Community 38 - "image_viewer_screen.dart"
Cohesion: 0.14
Nodes (14): build, createState, _currentIndex, dispose, heroTagPrefix, imageUrls, ImageViewerScreen, _ImageViewerScreenState (+6 more)

### Community 39 - "image_carousel.dart"
Cohesion: 0.14
Nodes (14): build, createState, _currentIndex, dispose, heroTagPrefix, ImageCarousel, _ImageCarouselState, images (+6 more)

### Community 40 - "profile_avatar_flight_controller.dart"
Cohesion: 0.14
Nodes (13): dart:async, dart:math, GetTickerProviderStateMixin, barAvatarKey, _cachedDestinationRect, _flightDuration, flyToProfile, isFlying (+5 more)

### Community 41 - "review.dart"
Cohesion: 0.14
Nodes (13): double?, detailRatings, feedback, fromJson, hotelId, id, overallRating, rating (+5 more)

### Community 42 - "rooms_screen.dart"
Cohesion: 0.15
Nodes (12): Hotel, build, hotel, RoomsScreen, BookNowButton, build, controller, package:majestic_rooms/core/utils/currency_format.dart (+4 more)

### Community 43 - "user_controller.dart"
Cohesion: 0.15
Nodes (12): dart:io, _commonController, deleteAccount, isLoading, _picker, _supabase, updateEmail, updateName (+4 more)

### Community 44 - "Class Refactor Workflow"
Cohesion: 0.15
Nodes (12): Class Refactor Workflow, Principles Summary, Step 1 — Read & Analyse, Step 2 — Clarify Before Planning, Step 3 — Plan, Step 4 — Control Panel, Step 5 — Section Headers, Step 6 — Naming (+4 more)

### Community 45 - "city_avatar.dart"
Cohesion: 0.15
Nodes (12): City, _bgColor, build, _buildImage, _buildLoader, city, CityAvatar, _fadeDuration (+4 more)

### Community 46 - "glass_bottom_nav.dart"
Cohesion: 0.17
Nodes (11): dart:ui, build, currentIndex, GlassBottomNavBar, onTap, _trayBg, _trayBlurSigma, _trayBorder (+3 more)

### Community 47 - "profile_bar.dart"
Cohesion: 0.18
Nodes (11): GlobalKey, _avatarKey, build, createState, initState, onNotificationsTap, ProfileBar, _ProfileBarState (+3 more)

### Community 48 - "wWinMain"
Cohesion: 0.24
Nodes (9): _In_, _In_opt_, vector, wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments() (+1 more)

### Community 49 - "supabase_utils.dart"
Cohesion: 0.17
Nodes (11): _client, currentUser, fetchHotels, onAuthStateChange, printUserStates, signInWithEmailPassword, signInWithGoogle, signOut (+3 more)

### Community 50 - "Win32Window"
Cohesion: 0.21
Nodes (12): OnCreate, RECT, HWND, Win32Window, child_content_, GetClientArea, OnCreate, quit_on_close_ (+4 more)

### Community 51 - "types.ts"
Cohesion: 0.18
Nodes (10): CompositeTypes, Constants, Database, DatabaseWithoutInternals, DefaultSchema, Enums, Json, Tables (+2 more)

### Community 52 - "room_image.dart"
Cohesion: 0.18
Nodes (10): int?, description, fromJson, id, _parseUrl, roomId, RoomImage, sortOrder (+2 more)

### Community 53 - "room_card.dart"
Cohesion: 0.18
Nodes (10): HotelRoom, build, hotelImageUrl, onDecrement, onIncrement, quantity, room, RoomCard (+2 more)

### Community 54 - "promotion.dart"
Cohesion: 0.20
Nodes (9): bool?, code, discountPercent, fromJson, hotelId, isActive, validFrom, validTo (+1 more)

### Community 55 - "field_clear_button.dart"
Cohesion: 0.20
Nodes (9): Color, build, controller, FieldClearButton, icon, iconColor, onClear, size (+1 more)

### Community 56 - "CupertinoPageRoute"
Cohesion: 0.20
Nodes (10): CupertinoPageRoute, build, confirmBooking, proceedToNextStep, build, build, build, openNotifications (+2 more)

### Community 57 - "facility.dart"
Cohesion: 0.20
Nodes (9): int get, Facility, fromJson, hashCode, icon, id, name, operator (+1 more)

### Community 58 - "package:supabase_flutter/supabase_flutter.dart"
Cohesion: 0.20
Nodes (9): description, fromJson, HotelImage, hotelSlug, id, _parseUrl, sortOrder, url (+1 more)

### Community 59 - "widget_extensions.dart"
Cohesion: 0.22
Nodes (9): autofocus, build, callback, child, KeyboardShortcutsX, _KeyboardShortcutWrapper, shortcuts, withKeys (+1 more)

### Community 60 - "app_pages.dart"
Cohesion: 0.20
Nodes (9): AppPages, routes, package:majestic_rooms/core/routes/app_routes.dart, package:majestic_rooms/root/modules/auth/login_binding.dart, package:majestic_rooms/root/modules/auth/login_screen.dart, package:majestic_rooms/root/modules/auth/signup_screen.dart, package:majestic_rooms/root/modules/home/home_binding.dart, package:majestic_rooms/root/modules/home/home_screen.dart (+1 more)

### Community 61 - "booking_screenshot_widget.dart"
Cohesion: 0.20
Nodes (9): booking, build, isPaid, _labelStyle, _sectionTitleStyle, _subValueStyle, _valueStyle, package:majestic_rooms/root/modules/booking/widgets/summary_widgets/price_breakdown.dart (+1 more)

### Community 62 - "selected_rooms_list.dart"
Cohesion: 0.20
Nodes (9): booking, build, _buildList, name, qty, _RoomItemData, roomNumber, totalPrice (+1 more)

### Community 63 - "maps_preview.dart"
Cohesion: 0.20
Nodes (9): build, hotelName, latitude, longitude, MapsPreview, _openNativeMap, package:flutter_map/flutter_map.dart, package:latlong2/latlong.dart (+1 more)

### Community 64 - "MessageHandler"
Cohesion: 0.36
Nodes (10): HWND, LPARAM, LRESULT, UINT, WPARAM, EnableFullDpiSupportIfAvailable(), GetHandle, GetThisFromHandle (+2 more)

### Community 65 - "booking_card.dart"
Cohesion: 0.22
Nodes (8): BookingModel, _badgeBg, _badgeFg, _badgeLabel, booking, _labelStyle, package:intl/intl.dart, package:majestic_rooms/root/modules/booking/screens/booking_summary_screen.dart

### Community 66 - "hotel_screen_controller.dart"
Cohesion: 0.22
Nodes (8): _fetchReviews, hotelId, isLoadingReviews, onInit, reviews, package:flutter/foundation.dart, package:majestic_rooms/core/data/models/review.dart, package:majestic_rooms/core/utils/helper.dart

### Community 67 - "user_avatar.dart"
Cohesion: 0.22
Nodes (8): build, _fallbackBg, heroTag, imageUrl, size, UserAvatar, package:cached_network_image/cached_network_image.dart, static const Color

### Community 68 - "summary_card.dart"
Cohesion: 0.25
Nodes (7): EdgeInsetsGeometry?, build, child, _kRadius, _kShadow, padding, SummaryCard

### Community 69 - "scratch.py"
Cohesion: 0.39
Nodes (7): clean_str(), fetch_og_images(), generate_uuid(), main(), r""" Generates:   - research/hotels_raw.json       (raw researched facts + image, Fetch a page and extract all og:image / twitter:image meta tags, plus JSON-LD., slugify()

### Community 70 - "login_binding.dart"
Cohesion: 0.29
Nodes (6): Bindings, AppBinding, dependencies, LoginBinding, HomeBinding, package:majestic_rooms/root/modules/auth/login_controller.dart

### Community 71 - "CommonController"
Cohesion: 0.33
Nodes (5): dependencies, CommonController, formatPrice, symbol, package:majestic_rooms/core/base/common_controller.dart

### Community 72 - "package:majestic_rooms/core/data/models/hotel.dart"
Cohesion: 0.29
Nodes (6): _dummyFacilities, kDummyHotels, package:majestic_rooms/core/data/models/facility.dart, package:majestic_rooms/core/data/models/hotel.dart, package:majestic_rooms/core/data/models/hotel_image.dart, package:majestic_rooms/core/data/models/hotel_room.dart

### Community 73 - "VoidCallback?"
Cohesion: 0.29
Nodes (6): build, HotelStars, onTap, rating, reviewCount, VoidCallback?

### Community 74 - "CLAUDE.md"
Cohesion: 0.33
Nodes (5): 1. Think Before Coding, 2. Simplicity First, 3. Surgical Changes, 4. Goal-Driven Execution, CLAUDE.md

### Community 75 - "Hard-Cut Policy"
Cohesion: 0.33
Nodes (5): Decision Test, Hard-Cut Policy, Operating Rules, Overview, Review Checklist

### Community 76 - "promotional_banner.dart"
Cohesion: 0.33
Nodes (5): Promotion, build, promotion, PromotionalBanner, package:majestic_rooms/core/data/models/promotion.dart

### Community 77 - "app_translations.dart"
Cohesion: 0.33
Nodes (5): AppTranslations, keys, package:majestic_rooms/core/localization/ar_sa.dart, package:majestic_rooms/core/localization/en_us.dart, Translations

### Community 78 - "static const"
Cohesion: 0.33
Nodes (5): AppRoutes, home, login, signup, static const

### Community 79 - "List"
Cohesion: 0.33
Nodes (5): build, CheckAvailabilityBar, _getLowestPrice, rates, List

### Community 80 - "BookingController"
Cohesion: 0.40
Nodes (5): GetxController, BookingController, HotelScreenController, UserController, ExploreController

### Community 81 - "Map"
Cohesion: 0.40
Nodes (3): arSA, enUS, Map

### Community 82 - "HomeController"
Cohesion: 0.40
Nodes (4): dependencies, HomeController, HomeScreen, package:majestic_rooms/root/modules/home/home_controller.dart

### Community 83 - "LoginController"
Cohesion: 0.67
Nodes (4): GetView, LoginController, LoginScreen, SignupScreen

### Community 85 - "Majestic Rooms"
Cohesion: 0.50
Nodes (3): Key Features, Majestic Rooms, Tech Stack

### Community 87 - "Intent"
Cohesion: 0.67
Nodes (3): Intent, _EscapeIntent, _CallbackIntent

## Knowledge Gaps
- **963 isolated node(s):** `Json`, `Database`, `DatabaseWithoutInternals`, `DefaultSchema`, `Tables` (+958 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Hotel` connect `rooms_screen.dart` to `hotel_card.dart`, `booking.dart`, `booking_controller.dart`, `hotel.dart`, `hotel_screen.dart`?**
  _High betweenness centrality (0.017) - this node is a cross-community bridge._
- **Why does `CommonController` connect `CommonController` to `booking_controller.dart`, `booking.dart`, `update_password_screen.dart`, `helper.dart`, `explore_controller.dart`, `profile_screen.dart`, `user_controller.dart`, `common_controller.dart`, `explore_screen.dart`, `package:flutter/material.dart`, `BookingController`, `hotel_screen.dart`, `profile_bar.dart`?**
  _High betweenness centrality (0.011) - this node is a cross-community bridge._
- **Why does `Promotion` connect `promotional_banner.dart` to `hotel.dart`, `promotion.dart`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **What connects `Json`, `Database`, `DatabaseWithoutInternals` to the rest of the system?**
  _963 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `entry_field.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.03389830508474576 - nodes in this community are weakly interconnected._
- **Should `hotel_card.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.041666666666666664 - nodes in this community are weakly interconnected._
- **Should `booking.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.046511627906976744 - nodes in this community are weakly interconnected._