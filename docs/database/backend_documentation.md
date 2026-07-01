# Majestic Rooms — Supabase Backend Reference (Flutter Client Guide)

Generated from a live schema export (tables, foreign keys, RLS policies, generated types) plus storage bucket and RLS-status queries. This doc is written for consuming the backend from **Flutter**, not for administering it.

> **How to read this doc if you're new to Supabase:** think of each table below as a REST "resource," the way you'd think of an endpoint in Postman. Instead of `GET /hotels`, you write `supabase.from('hotel').select()`. The Supabase client library builds the HTTP request for you — same underlying idea as a REST API, just expressed as a query builder instead of a URL.

---

## ⚠️ Security Summary — Read This First

RLS (Row Level Security) is what decides whether a table is locked down or wide open to anyone holding your app's anon key. Current status:

| Table | RLS Enabled? | Real-world meaning |
|---|---|---|
| `accounts` | ✅ Yes | Users can only read/update their **own** row |
| `facilities` | ✅ Yes | Authenticated users can read/write freely (see note below — likely unused table) |
| `blog_post`, `booking`, `booking_detail`, `facility`, `hotel`, `hotel_facility`, `hotel_images`, `hotel_rooms`, `location`, `payment`, `promotion`, `review`, `review_detail_rating`, `room_category`, `room_images`, `search_log`, `system_settings` | ❌ **No** | **Fully open** — no restrictions at all. Anyone with the anon key can read, insert, update, or delete rows directly, with no authentication required. |

This means as it stands today, `booking` and `payment` — the two most sensitive tables in the app — have no protection. Anyone could create fake bookings, alter prices, or tamper with payment records via direct API calls, bypassing your Flutter UI entirely. This isn't a Flutter problem to fix; it's a Supabase dashboard policy problem. Worth raising with whoever owns the backend before this goes further into production.

**Duplicate facility tables:** `facility` (integer id) is the one actually used — it's linked to `hotel` via the `hotel_facility` join table. `facilities` (uuid id) has RLS policies but is referenced by nothing. Treat `facilities` as likely legacy/unused until confirmed otherwise.

---

## Auth

**Method:** Email + password only (no OAuth, no magic link).

Supabase auth issues a session (access token + refresh token) on sign-in, which the client library stores and auto-refreshes for you — you don't manage tokens manually.

**Sign up**
```dart
final response = await supabase.auth.signUp(
  email: email,
  password: password,
);
```
Note: signing up creates a row in Supabase's internal `auth.users` table, **not** in `accounts` automatically — check whether a database trigger creates the matching `accounts` row, or whether the React app does this manually after signup. If nothing creates it, your Flutter app will need to insert one itself right after `signUp`.

**Sign in**
```dart
final response = await supabase.auth.signInWithPassword(
  email: email,
  password: password,
);
final user = response.user;
```

**Sign out**
```dart
await supabase.auth.signOut();
```

**Get current user / session**
```dart
final user = supabase.auth.currentUser;       // null if not signed in
final session = supabase.auth.currentSession; // null if not signed in
```

**Listen for auth state changes** (recommended — drive your router off this)
```dart
supabase.auth.onAuthStateChange.listen((data) {
  final event = data.event;       // signedIn, signedOut, tokenRefreshed, etc.
  final session = data.session;
});
```

**Password reset**
```dart
await supabase.auth.resetPasswordForEmail(email);
```

---

## Storage

All 6 buckets are **public**, meaning files are served via a plain URL — no signed URLs or extra auth needed to *view* an image. Uploading still requires whatever RLS policy is set on `storage.objects` for that bucket (not fully verified — test an upload once to confirm).

| Bucket | Public | Size limit | Allowed types | What it's for |
|---|---|---|---|---|
| `account_image` | ✅ | none set | none set | User profile pictures |
| `background-videos` | ✅ | none set | none set | App background video assets (found: an mp4) |
| `facility_icons` | ✅ | none set | none set | Icons for amenities (wifi, pool, etc.) |
| `hotel-images` | ✅ | 50MB | webp/png/jpeg/jpg | Hotel gallery photos |
| `locations` | ✅ | 50MB | webp/png/jpeg/jpg | City/region imagery (also has a stray `.webm` video and a mixed folder structure — see note) |
| `room-images` | ✅ | 50MB | webp/png/jpeg/jpg | Room gallery photos |

**Naming convention note:** actual file paths are inconsistent — some are flat (`front.png`), some use a folder per hotel/room (`room_1/1775482119078_fvyh7u2bia5.jpeg`), and `locations` mixes both `.webp` files at the root and a `locations/` subfolder of `.png` duplicates. Don't assume a strict convention; always store the full path/URL returned at upload time in your table row (e.g. `hotel_images.url`) rather than reconstructing paths from IDs.

**Get a public URL for a file**
```dart
final imageUrl = supabase.storage
    .from('hotel-images')
    .getPublicUrl('front.png');
```

**Upload a file**
```dart
final path = '${hotelSlug}/${fileName}';
await supabase.storage.from('hotel-images').upload(path, file);
final url = supabase.storage.from('hotel-images').getPublicUrl(path);
```

**Delete a file**
```dart
await supabase.storage.from('hotel-images').remove([path]);
```

---

## Enums

Referenced by several tables below — Postgres enums map to plain strings on the Dart/Flutter side.

| Enum | Values |
|---|---|
| `booking_status_enum` | `PENDING`, `CONFIRMED`, `CANCELLED`, `CHECKED_IN`, `COMPLETED` |
| `payment_method_enum` | `MASTER`, `VISA`, `MADA`, `APPLE_PAY` |
| `payment_status_enum` | `PENDING`, `COMPLETED`, `FAILED` |
| `room_status_enum` | `AVAILABLE`, `OCCUPIED`, `MAINTENANCE` |
| `service_rating_category` | `CLEANLINESS`, `STAFF`, `FOOD`, `VALUE_FOR_MONEY`, `COMFORT` |

---

## Table Reference

Each card: purpose → columns → relationships → RLS → example Flutter call. Sorted by how central the table is to the booking flow.

---

### `accounts`
**Purpose:** User profile, one row per authenticated user. `id` matches the Supabase auth user id — this is how RLS ties the row to "yourself."

| Column | Type | Nullable | Notes |
|---|---|---|---|
| `id` | uuid | No | = `auth.uid()`, primary key |
| `name` | varchar | No | |
| `email` | varchar | Yes | |
| `picture_url` | varchar | Yes | Likely from `account_image` bucket |
| `public_data` | jsonb | No | Free-form — maps to `Map<String, dynamic>` in Dart |
| `created_at` / `updated_at` | timestamptz | Yes | |
| `created_by` / `updated_by` | uuid | Yes | |

**RLS:** ✅ Enabled — a user can only `SELECT`/`UPDATE` their own row (`auth.uid() = id`). No `INSERT`/`DELETE` policy exists, so account rows likely need to be created by a trigger or server-side logic, not directly by the client.

**Example — fetch your own profile:**
```dart
final userId = supabase.auth.currentUser!.id;
final account = await supabase
    .from('accounts')
    .select()
    .eq('id', userId)
    .single();
```

**Example — update your own profile:**
```dart
await supabase
    .from('accounts')
    .update({'name': newName, 'picture_url': newUrl})
    .eq('id', userId);
```

---

### `hotel`
**Purpose:** Core hotel/property listing.

| Column | Type | Nullable | Notes |
|---|---|---|---|
| `id` | uuid | No | |
| `slug` | text | Yes | Used as the join key by rooms/images/bookings — treat as the practical "foreign key" for most lookups |
| `name` | varchar | No | |
| `address` | varchar | Yes | |
| `location_slug` | text | Yes | → `location.slug` |
| `latitude` / `longitude` | double | Yes | |
| `coordinates` | USER-DEFINED (postgis point) | Yes | Raw Postgres geometry type — likely needs special handling, not a plain Dart type |
| `class` | integer | Yes | Star rating, presumably 1–5 |
| `distance_from_haram` | numeric | Yes | Domain-specific (Mecca/Madinah hotels) |
| `is_best_hotel` | boolean | Yes | Featured flag |
| `is_active` | boolean | Yes | **Filter on this** — inactive hotels shouldn't show in the app |
| `serve_breakfast` | boolean | Yes | |
| `description`, `terms`, `payment_policies` | text | Yes | |
| `email`, `phone_number`, `land_line`, `liscense_no` | varchar | Yes | |

**RLS:** ❌ Disabled — fully open, no restrictions.

**Example — active hotels in a location:**
```dart
final hotels = await supabase
    .from('hotel')
    .select()
    .eq('location_slug', locationSlug)
    .eq('is_active', true);
```

---

### `hotel_rooms`
**Purpose:** Room inventory belonging to a hotel.

| Column | Type | Nullable | Notes |
|---|---|---|---|
| `id` | integer | No | |
| `hotel_slug` | text | Yes | → `hotel.slug` |
| `room_category_id` | integer | Yes | → `room_category.id` |
| `room_number` | varchar | No | |
| `name` | varchar | Yes | |
| `description` | text | Yes | |
| `beds` | integer | Yes | |
| `city_view` | boolean | Yes | |
| `price_per_night` | numeric | No | |
| `price_per_night_with_breakfast` | numeric | Yes | |
| `status` | `room_status_enum` | Yes | `AVAILABLE` / `OCCUPIED` / `MAINTENANCE` |

**RLS:** ❌ Disabled.

**Example — available rooms for a hotel:**
```dart
final rooms = await supabase
    .from('hotel_rooms')
    .select()
    .eq('hotel_slug', hotelSlug)
    .eq('status', 'AVAILABLE');
```

---

### `booking`
**Purpose:** A guest's reservation. This is the central transactional table.

| Column | Type | Nullable | Notes |
|---|---|---|---|
| `id` | uuid | No | |
| `account_id` | uuid | Yes | → `accounts.id` — nullable, so guest checkout without an account may be supported |
| `hotel_slug` | text | Yes | → `hotel.slug` |
| `room_id` | integer | Yes | → `hotel_rooms.id` |
| `check_in_date` / `check_out_date` | date | No | |
| `nights` | integer | Yes | |
| `number_of_rooms` | integer | Yes | Default `1` |
| `booking_status` | `booking_status_enum` | Yes | Default `PENDING` |
| `booking_date` | date | Yes | Default today |
| `guest_full_name`, `guest_email`, `guest_phone` | varchar | Yes | |
| `special_request` | text | Yes | |
| `promocode` | varchar | Yes | |
| `gross_total`, `discount`, `net_total` | numeric | Yes | |

**RLS:** ❌ Disabled — see security note at top of doc.

**Example — create a booking:**
```dart
final booking = await supabase.from('booking').insert({
  'hotel_slug': hotelSlug,
  'room_id': roomId,
  'account_id': supabase.auth.currentUser?.id,
  'check_in_date': checkIn.toIso8601String().split('T').first,
  'check_out_date': checkOut.toIso8601String().split('T').first,
  'number_of_rooms': roomCount,
  'guest_full_name': name,
  'guest_email': email,
  'guest_phone': phone,
  'gross_total': grossTotal,
  'net_total': netTotal,
}).select().single();
```

**Example — a user's own bookings (requires being signed in):**
```dart
final bookings = await supabase
    .from('booking')
    .select()
    .eq('account_id', supabase.auth.currentUser!.id)
    .order('booking_date', ascending: false);
```

---

### `booking_detail`
**Purpose:** Per-room line items within a booking (a booking can cover multiple rooms).

| Column | Type | Nullable | Notes |
|---|---|---|---|
| `id` | bigint | No | |
| `booking_id` | uuid | Yes | → `booking.id` |
| `room_id` | integer | Yes | → `hotel_rooms.id` |
| `no_of_rooms` | integer | Yes | Default `1` |
| `room_price` | numeric | No | |
| `gross_amount`, `discount`, `net_amount` | numeric | Yes/No | `discount` defaults `0` |
| `includes_breakfast` | boolean | Yes | Default `false` |

**RLS:** ❌ Disabled.

**Example — insert alongside a booking:**
```dart
await supabase.from('booking_detail').insert({
  'booking_id': bookingId,
  'room_id': roomId,
  'no_of_rooms': roomCount,
  'room_price': roomPrice,
  'gross_amount': grossAmount,
  'net_amount': netAmount,
  'includes_breakfast': includesBreakfast,
});
```

---

### `payment`
**Purpose:** Payment record tied to a booking.

| Column | Type | Nullable | Notes |
|---|---|---|---|
| `id` | integer | No | |
| `booking_id` | uuid | Yes | → `booking.id` |
| `amount` | numeric | No | |
| `payment_date` | date | Yes | Default today |
| `payment_method` | `payment_method_enum` | Yes | `MASTER` / `VISA` / `MADA` / `APPLE_PAY` |
| `payment_status` | `payment_status_enum` | Yes | `PENDING` / `COMPLETED` / `FAILED` |

**RLS:** ❌ Disabled — this table currently has **no protection at all**. Payment records can be read, forged, or altered by anyone with the anon key. Flag this loudly before shipping any payment flow.

**Example — record a payment (once RLS is sorted):**
```dart
await supabase.from('payment').insert({
  'booking_id': bookingId,
  'amount': amount,
  'payment_method': 'VISA',
  'payment_status': 'PENDING',
});
```

---

### `location`
**Purpose:** City/region that hotels are grouped under (e.g. Mecca, Madinah).

| Column | Type | Nullable |
|---|---|---|
| `id` | uuid | No |
| `name` | varchar | No |
| `slug` | text | Yes |
| `thumbnail` | varchar | Yes |

**RLS:** ❌ Disabled.

**Example:**
```dart
final locations = await supabase.from('location').select();
```

---

### `room_category`
**Purpose:** Lookup table for room types (e.g. Standard, Deluxe, Suite).

| Column | Type | Nullable |
|---|---|---|
| `id` | integer | No |
| `name` | varchar | No |
| `slug` | text | Yes |

**RLS:** ❌ Disabled.

```dart
final categories = await supabase.from('room_category').select();
```

---

### `facility`
**Purpose:** Amenity lookup (wifi, pool, parking, etc.) — the one actually in use (see `facilities` note above).

| Column | Type | Nullable |
|---|---|---|
| `id` | integer | No |
| `name` | varchar | No |
| `slug` | text | Yes |
| `icon` | varchar | Yes | Likely a `facility_icons` bucket filename |

**RLS:** ❌ Disabled.

```dart
final facilities = await supabase.from('facility').select();
```

---

### `hotel_facility`
**Purpose:** Join table — which amenities a hotel offers.

| Column | Type | Nullable |
|---|---|---|
| `hotel_id` | uuid | No | → `hotel.id` |
| `facility_id` | integer | No | → `facility.id` |

**RLS:** ❌ Disabled.

**Example — amenities for a hotel (join syntax):**
```dart
final amenities = await supabase
    .from('hotel_facility')
    .select('facility_id, facility(name, icon, slug)')
    .eq('hotel_id', hotelId);
```

---

### `hotel_images`
**Purpose:** Gallery photos for a hotel, with manual sort order.

| Column | Type | Nullable |
|---|---|---|
| `id` | integer | No |
| `hotel_slug` | text | Yes | → `hotel.slug` |
| `url` | varchar | No |
| `description` | varchar | Yes |
| `sort_order` | integer | Yes | Default `-1` |

**RLS:** ❌ Disabled.

```dart
final images = await supabase
    .from('hotel_images')
    .select()
    .eq('hotel_slug', hotelSlug)
    .order('sort_order');
```

---

### `room_images`
**Purpose:** Gallery photos for a specific room.

| Column | Type | Nullable |
|---|---|---|
| `id` | integer | No |
| `room_id` | integer | Yes | → `hotel_rooms.id` |
| `url` | varchar | No |

**RLS:** ❌ Disabled.

```dart
final images = await supabase
    .from('room_images')
    .select()
    .eq('room_id', roomId);
```

---

### `promotion`
**Purpose:** Discount/promo codes scoped to a specific hotel.

| Column | Type | Nullable |
|---|---|---|
| `code` | varchar | No |
| `hotel_id` | uuid | No | → `hotel.id` |
| `discount_percent` | numeric | Yes |
| `is_active` | boolean | Yes |
| `valid_from` / `valid_to` | timestamp | Yes |
| `description` | text | Yes |

**RLS:** ❌ Disabled.

**Example — validate a promo code:**
```dart
final promo = await supabase
    .from('promotion')
    .select()
    .eq('code', code)
    .eq('hotel_id', hotelId)
    .eq('is_active', true)
    .maybeSingle();
```

---

### `review`
**Purpose:** Guest review, tied to a completed booking and a hotel.

| Column | Type | Nullable |
|---|---|---|
| `id` | integer | No |
| `booking_id` | uuid | Yes | → `booking.id` |
| `hotel_id` | uuid | Yes | → `hotel.id` |
| `reviewer_name` | varchar | No |
| `reviewer_email` | varchar | Yes |
| `overall_rating` | numeric | Yes |
| `feedback` | text | Yes |

**RLS:** ❌ Disabled.

```dart
final reviews = await supabase
    .from('review')
    .select()
    .eq('hotel_id', hotelId)
    .order('id', ascending: false);
```

---

### `review_detail_rating`
**Purpose:** Per-category rating breakdown belonging to a review (e.g. cleanliness: 4, staff: 5).

| Column | Type | Nullable |
|---|---|---|
| `id` | integer | No |
| `review_id` | integer | Yes | → `review.id` |
| `service` | `service_rating_category` | No | `CLEANLINESS` / `STAFF` / `FOOD` / `VALUE_FOR_MONEY` / `COMFORT` |
| `rating` | numeric | Yes |

**RLS:** ❌ Disabled.

```dart
final breakdown = await supabase
    .from('review_detail_rating')
    .select()
    .eq('review_id', reviewId);
```

---

### `search_log`
**Purpose:** Analytics — logs what users search for. Not user-facing; likely write-only from the client.

| Column | Type | Nullable |
|---|---|---|
| `id` | integer | No |
| `user_id` | uuid | Yes | → `accounts.id` |
| `location_id` | uuid | Yes | → `location.id` |
| `check_in_date` / `check_out_date` | date | Yes |
| `promocode` | varchar | Yes |
| `search_datetime` | timestamp | Yes |

**RLS:** ❌ Disabled.

```dart
await supabase.from('search_log').insert({
  'user_id': supabase.auth.currentUser?.id,
  'location_id': locationId,
  'check_in_date': checkIn,
  'check_out_date': checkOut,
});
```

---

### `system_settings`
**Purpose:** App-wide key-value config store.

| Column | Type | Nullable |
|---|---|---|
| `key` | text | No | Primary key |
| `value` | jsonb | No | `Map<String, dynamic>` in Dart |
| `updated_at` | timestamp | Yes |

**RLS:** ❌ Disabled.

```dart
final setting = await supabase
    .from('system_settings')
    .select()
    .eq('key', 'some_setting_key')
    .single();
```

---

### `blog_post`
**Purpose:** CMS-style blog content — likely marketing/content pages, probably not central to the booking flow but included for completeness.

| Column | Type | Nullable |
|---|---|---|
| `id` | integer | No |
| `title` | varchar | No |
| `short_description` / `long_description` | text | Yes |
| `thumbnail` | varchar | Yes |
| `tags` | array | Yes |
| `created_by` | varchar | Yes |
| `created_at` | timestamp | Yes |

**RLS:** ❌ Disabled.

```dart
final posts = await supabase.from('blog_post').select().order('created_at', ascending: false);
```

---

### `facilities` — ⚠️ likely unused, see note

| Column | Type | Nullable |
|---|---|---|
| `id` | uuid | No |
| `name` | text | No |
| `slug` | text | No |
| `icon` | text | Yes |
| `created_at` / `updated_at` | timestamptz | Yes |

**RLS:** ✅ Enabled — `authenticated` role can freely `SELECT`/`INSERT`/`UPDATE`/`DELETE` (no ownership check, unlike `accounts`).

Not referenced by any foreign key in the schema — nothing joins to it. Confirm with whoever built the React app whether this is dead weight before building anything against it in Flutter.

---

## Future: Admin/Staff Functionality (Not Yet Implemented)

Per your note — admin currently lives entirely in the React app, and the Flutter app is customer-facing only for now. If Flutter later takes on admin/staff duties, likely candidates based on the schema:

- **Hotel/room management** — CRUD on `hotel`, `hotel_rooms`, `hotel_images`, `room_images`
- **Booking management** — updating `booking_status`, viewing all bookings (not just the current user's)
- **Payment reconciliation** — updating `payment_status`
- **Promotion management** — CRUD on `promotion`
- **Blog management** — CRUD on `blog_post`

None of this exists as distinct access rules today since RLS isn't differentiating roles anywhere except `accounts`. If/when this becomes real, it'll need a role system (e.g. a `role` column on `accounts` or a separate `staff` table) plus RLS policies that check it — worth designing deliberately rather than retrofitting.