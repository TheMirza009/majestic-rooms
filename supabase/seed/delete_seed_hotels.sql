-- Script to delete all seeded hotels and their dependent data.
-- We use the `liscense_no LIKE 'MOCK-%'` pattern to safely identify our dummy data.

-- 1. Delete dependent ratings
DELETE FROM review_detail_rating 
WHERE review_id IN (
    SELECT id FROM review 
    WHERE hotel_id IN (SELECT id FROM hotel WHERE liscense_no LIKE 'MOCK-%')
);

-- 2. Delete reviews
DELETE FROM review 
WHERE hotel_id IN (SELECT id FROM hotel WHERE liscense_no LIKE 'MOCK-%');

-- 3. Delete room images
DELETE FROM room_images 
WHERE room_id IN (
    SELECT id FROM hotel_rooms 
    WHERE hotel_slug IN (SELECT slug FROM hotel WHERE liscense_no LIKE 'MOCK-%')
);

-- 4. Delete hotel rooms
DELETE FROM hotel_rooms 
WHERE hotel_slug IN (SELECT slug FROM hotel WHERE liscense_no LIKE 'MOCK-%');

-- 5. Delete hotel images
DELETE FROM hotel_images 
WHERE hotel_slug IN (SELECT slug FROM hotel WHERE liscense_no LIKE 'MOCK-%');

-- 6. Delete hotel facilities mapping
DELETE FROM hotel_facility 
WHERE hotel_id IN (SELECT id FROM hotel WHERE liscense_no LIKE 'MOCK-%');

-- 7. Finally, delete the hotels themselves
DELETE FROM hotel 
WHERE liscense_no LIKE 'MOCK-%';

-- NOTE: We intentionally do NOT delete from `location`, `facility`, or `room_category` 
-- as those are generic lookup tables (e.g. 'Mecca', 'Free WiFi', 'Standard') that 
-- might be referenced by other real data.
