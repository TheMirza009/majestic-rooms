# Implementation Plan: Real Hotel Seed Data → Supabase (Majestic Rooms)

**Audience:** This plan is written for another model (or yourself) to *execute*. It is not the research/data itself — it's the recipe for producing it and pushing it to Supabase.

**Goal:** Replace all dummy data in the Majestic Rooms Flutter app with real-world hotel data (names, addresses, coordinates, star class, amenities, real photos) for 23 hotels across 7 Saudi cities, structured so it satisfies the `Hotel`, `HotelImage`, `HotelRoom`, `Facility`, and `Review` DTOs, then load it into Supabase via a single SQL script.

**Final deliverable:** actual, fully-populated data files (JSON research file + SQL seed script) containing every one of the 23 hotels' real data — not a template or a subset. The executing model should not stop partway and hand back "here's the pattern for the rest"; every hotel, room, image, facility link, and review row needs to be present in the delivered files.

---

## 0. Assumptions (stated up front — flag if any are wrong before starting)

| Area | Decision | Why |
|---|---|---|
| Hotel identity (name, address, city, lat/long, star class, phone) | **Real**, researched via web search | This is the whole point of the exercise |
| Amenities (`facility` table) | **Real**, researched per hotel where feasible | Cheap to get right, adds realism |
| Room inventory, per-room pricing, room descriptions | **Fabricated** but realistic (e.g. Standard/Deluxe/Suite tiers, market-appropriate SAR pricing per city/class) | Per-room live pricing isn't public data |
| Images (`hotel_images`, `room_images`) | **Real, scraped photo URLs** — pulled from the hotel's official site, Google Maps listing, or major OTA listings (Booking.com, Agoda) via image search. This is a testing app, not a published product, so hotlinking real property photos is fine here. | User confirmed no copyright concern for this internal/testing use |
| `license_no` | Fabricated, prefixed `MOCK-` | Makes seeded rows identifiable/removable later |
| `distance_from_haram` | Real distance to Masjid al-Haram for Mecca hotels, to Masjid an-Nabawi for Medina hotels, `null` elsewhere | Field is domain-specific to those two cities |
| `description`, `terms`, `payment_policies` | Fabricated, generic boilerplate (1–3 sentences each) | Not publicly available; not worth over-engineering |
| Reviews (`review`, `review_detail_rating`) | **Fabricated but realistic** — plausible reviewer names, per-category ratings, short feedback text | Real guest reviews are tied to real individuals (attribution/quality concerns) and aren't needed for this to feel real; fabricated is consistent with how rooms/pricing are handled |
| Promotions | **Out of scope** — not required by the `Hotel` DTO | Keep this task bounded |
| Push mechanism | One SQL script, idempotent (`ON CONFLICT DO NOTHING` / `INSERT ... ON CONFLICT (slug) DO UPDATE`) | Simpler than a Dart script; no dependency setup; re-runnable safely |

If a hotel's photos genuinely can't be found via search (rare), fall back to a placeholder (`https://picsum.photos/seed/{id}/800/600`) for that hotel only and note it in the research file — don't block the whole dataset on one property.

---

## 1. Scope

| City | slug | # Hotels |
|---|---|---|
| Mecca | `mecca` | 5 |
| Medina | `medina` | 5 |
| Jeddah | `jeddah` | 5 |
| Riyadh | `riyadh` | 5 |
| Khobar | `khobar` | 1 |
| Dhahran | `dhahran` | 1 |
| Abha | `abha` | 1 |
| **Total** | | **23 hotels** |

Prefer well-known, real, currently-operating hotels (major international chains or well-reviewed local ones) — easier to verify address/coordinates/star class for, and avoids inventing anything.

---

## 2. Step-by-step execution

### Step 1 — Research (web search), per hotel
For each of the 23 hotels, collect:
- Official name
- Full street address
- Approximate latitude/longitude (from Google Maps search)
- Star class (1–5, if published)
- Phone number (general hotel line, if public)
- 3–6 real amenities (e.g. "Free WiFi", "Outdoor Pool", "Airport Shuttle", "Prayer Room", "Fitness Center")
- For Mecca/Medina hotels only: approximate walking distance (meters) to the Haram/Masjid an-Nabawi if commonly advertised (e.g. "200m from Masjid al-Haram")
- **3–4 real exterior/lobby/room photo URLs** per hotel via image search — prefer direct image URLs from the hotel's official website or a major OTA listing (Booking.com, Agoda, Google Maps). Grab the direct file URL (typically ends `.jpg`/`.jpeg`/`.png`/`.webp`), and confirm it actually resolves (loads) before recording it. Note the source (site name) next to each URL.

**Verify:** every hotel has a real name + real address that a search actually returns — no invented properties. Every recorded image URL actually loads.

Save raw findings to `research/hotels_raw.json` as an intermediate file, one object per hotel, before moving to Step 2. This keeps research separate from schema-shaping so mistakes are easy to spot/fix.

### Step 2 — Generate IDs and slugs
- `id`: uuid v4 per hotel (and per room)
- `slug`: kebab-case from name + city, e.g. `hilton-makkah-convention-hotel` — must be unique across all 23
- Same pattern for `location.slug` (city slugs above), `room_category.slug`, `facility.slug`

**Verify:** no duplicate slugs anywhere in the dataset.

### Step 3 — Shape data into table-shaped JSON
Produce one JSON file per table, matching the Supabase schema in the reference doc exactly (column names, types, enums). Required tables:

1. `location` — 7 rows (one per city)
2. `hotel` — 23 rows
3. `hotel_rooms` — 3 rooms per hotel (Standard / Deluxe / Suite), 69 rows total
   - `price_per_night`: fabricate sensibly by city/class (e.g. 5-star Riyadh Deluxe ≠ 3-star Abha Standard — vary realistically, don't flat-rate everything)
   - `status`: `AVAILABLE`
4. `room_category` — 3 rows (`standard`, `deluxe`, `suite`), shared across all hotels
5. `facility` — dedupe amenities into a shared lookup table (don't recreate "Free WiFi" 23 times)
6. `hotel_facility` — join rows linking each hotel to its 3-6 facility ids
7. `hotel_images` — 3-4 **real scraped** photo URLs per hotel (from Step 1), `sort_order` 0,1,2...
8. `room_images` — 1-2 images per room. Real per-room photos rarely exist publicly, so it's fine to reuse the hotel's general property/gallery photos here (still real, just not room-specific) rather than fabricating or falling back to placeholders.
9. `review` — 2-4 fabricated reviews per hotel: `hotel_id`, `reviewer_name`, `overall_rating` (1-5), `feedback` (1-2 sentences). `booking_id` stays `null` (no real bookings exist).
10. `review_detail_rating` — for each review, 3-5 rows covering a subset of `service_rating_category` enum values (`CLEANLINESS`, `STAFF`, `FOOD`, `VALUE_FOR_MONEY`, `COMFORT`) with a `rating` (1-5) roughly consistent with that review's `overall_rating`.

**Verify:** every `hotel_slug` in `hotel_rooms`/`hotel_images` matches a real row in `hotel`; every `facility_id` in `hotel_facility` matches a real row in `facility`; every `room_category_id` in `hotel_rooms` matches a real row in `room_category`; every `review_id` in `review_detail_rating` matches a real row in `review`; every image URL was confirmed to load in Step 1.

### Step 4 — Write the SQL seed script
Single file: `supabase/seed/seed_hotels.sql`. Structure:

```sql
-- 1. room_category (idempotent)
insert into room_category (id, name, slug) values
  (1, 'Standard', 'standard'),
  (2, 'Deluxe', 'deluxe'),
  (3, 'Suite', 'suite')
on conflict (id) do nothing;

-- 2. facility (idempotent, dedup'd list)
insert into facility (id, name, slug, icon) values
  (...)
on conflict (id) do nothing;

-- 3. location
insert into location (id, name, slug, thumbnail) values (...);

-- 4. hotel
insert into hotel (id, slug, name, address, location_slug, latitude, longitude,
  class, distance_from_haram, is_active, serve_breakfast, description, terms,
  payment_policies, phone_number, email, liscense_no) values (...);

-- 5. hotel_facility
insert into hotel_facility (hotel_id, facility_id) values (...);

-- 6. hotel_images
insert into hotel_images (hotel_slug, url, description, sort_order) values (...);

-- 7. hotel_rooms
insert into hotel_rooms (id, hotel_slug, room_category_id, room_number, name,
  description, beds, city_view, price_per_night, price_per_night_with_breakfast,
  status) values (...);

-- 8. room_images
insert into room_images (room_id, url) values (...);

-- 9. review
insert into review (id, hotel_id, booking_id, reviewer_name, reviewer_email,
  overall_rating, feedback) values (...);

-- 10. review_detail_rating
insert into review_detail_rating (id, review_id, service, rating) values (...);
```

Use `on conflict (slug) do nothing` (or the relevant unique key) on every insert block so the script can be re-run safely without duplicating rows.

### Step 5 — Run it
- Paste into the Supabase SQL editor (Dashboard → SQL Editor) and run once.
- **Before running:** confirm this is being run against a dev/staging project if one exists — several of these tables (`hotel`, `hotel_rooms`, `booking`, `payment`) have RLS disabled per the reference doc, meaning this seed data will be world-writable/readable just like everything else already in there. That's an existing condition, not something this script changes, but worth being aware of before pointing it at production.
- Spot-check in the Table Editor: pick 2-3 hotels, confirm rows landed correctly across `hotel`, `hotel_rooms`, `hotel_images`, `hotel_facility`.

### Step 6 — Flutter-side sanity check
Run the existing Supabase query (the one from `majestic_rooms_backend_reference.md` that joins `hotel_images`, `hotel_rooms`, `hotel_facility→facility`) against one seeded hotel slug and confirm `Hotel.fromJson()` parses it without null-cast errors — this catches any schema-shape mismatches (e.g. a field the model forgot, or an enum value typo) before wiring the whole app to it.

---

## 3. Deliverables checklist

- [ ] `research/hotels_raw.json` — raw researched facts for **all 23 hotels**, one object per hotel, including scraped image URLs and their source, with a `source` note per fact for traceability
- [ ] `supabase/seed/seed_hotels.sql` — final idempotent insert script containing **every** row (all 23 hotels, ~69 rooms, all images, facility links, and ~46-92 reviews with their detail ratings) — this is the actual data to be pushed, not a sample
- [ ] Confirmation that the script ran cleanly with no FK violations
- [ ] One real `Hotel.fromJson()` parse test against live seeded data, pasted output or screenshot
- [ ] One real `Review.fromJson()` parse test (via `supabase.from('review').select('*, review_detail_rating(*)').eq('hotel_id', ...)`) against a seeded hotel

## 4. Success criteria

1. All 23 hotels are real, verifiable properties (name + address resolve to an actual location), with real photo URLs that load.
2. Running `seed_hotels.sql` twice in a row produces no duplicate rows and no errors.
3. A `supabase.from('hotel').select('*, hotel_images(*), hotel_rooms(*, room_category(*), room_images(*)), hotel_facility(facility(*))')` call for any seeded hotel slug parses cleanly through the existing `Hotel.fromJson()` with no exceptions.
4. A `supabase.from('review').select('*, review_detail_rating(*)').eq('hotel_id', <id>)` call parses cleanly through `Review.fromJson()` for at least one seeded hotel.
5. No fabricated field (rooms, pricing, license numbers, reviews) is presented as if it were real research — the raw research file should make clear which parts came from search vs. were generated.
6. The delivered files contain the complete dataset (all 23 hotels), not a partial example intended to be extended later.