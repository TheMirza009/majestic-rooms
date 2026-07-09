-- 1. room_category
insert into room_category (name) values
  ('Standard'),
  ('Deluxe'),
  ('Suite')
on conflict do nothing;

-- 2. facility
insert into facility (name, icon) values
  ('Free WiFi', 'wifi'),
  ('Swimming Pool', 'pool'),
  ('Fitness Center', 'fitness_center'),
  ('Spa & Wellness', 'spa'),
  ('Restaurant', 'restaurant'),
  ('Room Service', 'room_service'),
  ('Parking', 'local_parking'),
  ('Airport Shuttle', 'airport_shuttle'),
  ('Prayer Room', 'mosque'),
  ('Business Center', 'business_center'),
  ('Family Rooms', 'family_restroom'),
  ('Concierge', 'support_agent')
on conflict do nothing;

-- 3. location
insert into location (name, thumbnail) values
  ('Mecca', 'https://images.unsplash.com/photo-1591147551069-79822a969f69?w=800&q=80'),
  ('Medina', 'https://images.unsplash.com/photo-1590846203004-954fca2ebdb2?w=800&q=80'),
  ('Jeddah', 'https://images.unsplash.com/photo-1570189917830-745a1c223c34?w=800&q=80'),
  ('Riyadh', 'https://images.unsplash.com/photo-1582560370836-e8892f398453?w=800&q=80'),
  ('Al Khobar', 'https://loremflickr.com/800/600/luxury,hotel,room?lock=1'),
  ('Dhahran', 'https://images.unsplash.com/photo-1580977695304-486134812a67?w=800&q=80'),
  ('Abha', 'https://images.unsplash.com/photo-1576402206680-928ccf1e1022?w=800&q=80')
on conflict do nothing;

-- 4. hotel
insert into hotel (id, name, address, location_slug, latitude, longitude, class, distance_from_haram, is_active, serve_breakfast, description, terms, payment_policies, phone_number, email, liscense_no) values
  ('11a11f51-2522-7c37-12da-86a78c49ea20', 'Pullman Zamzam Madina', 'Amr Bin Al Aas Street, Medina 41461', 'medina', 24.4673, 39.6095, 5, 150, true, true, 'Experience luxury and comfort at Pullman Zamzam Madina. Perfectly located for your stay.', 'Standard terms and conditions apply. Check-in from 14:00, check-out until 12:00.', 'All major credit cards accepted. Payment upon arrival.', '+966 14 821 0500', 'info@pullman-zamzam-madina.com', 'MOCK-480547'),
  ('419b1b67-3bd4-755d-05ad-7853c1f76eb9', 'Madinah Hilton', 'King Fahd Road, Medina 41411', 'medina', 24.4705, 39.61, 5, 200, true, true, 'Experience luxury and comfort at Madinah Hilton. Perfectly located for your stay.', 'Standard terms and conditions apply. Check-in from 14:00, check-out until 12:00.', 'All major credit cards accepted. Payment upon arrival.', '+966 14 820 1000', 'info@madinah-hilton.com', 'MOCK-860394'),
  ('529a2797-6401-7f2e-d6cf-c7403d75e173', 'Four Seasons Hotel Riyadh', 'Kingdom Centre, Riyadh 11321', 'riyadh', 24.7114, 46.6744, 5, null, true, true, 'Experience luxury and comfort at Four Seasons Hotel Riyadh. Perfectly located for your stay.', 'Standard terms and conditions apply. Check-in from 14:00, check-out until 12:00.', 'All major credit cards accepted. Payment upon arrival.', '+966 11 211 5000', 'info@four-seasons-hotel-riyadh.com', 'MOCK-478634'),
  ('6dc0cf0b-9cd7-f78d-f0ca-c5e40c02d4e5', 'DoubleTree by Hilton Dhahran', 'Al Qashlah Street, Dhahran 34232', 'dhahran', 26.299, 50.152, 4, null, true, true, 'Experience luxury and comfort at DoubleTree by Hilton Dhahran. Perfectly located for your stay.', 'Standard terms and conditions apply. Check-in from 14:00, check-out until 12:00.', 'All major credit cards accepted. Payment upon arrival.', '+966 13 331 1144', 'info@doubletree-by-hilton-dhahran.com', 'MOCK-52727')
on conflict do nothing;

-- 5. hotel_facility
insert into hotel_facility (hotel_id, facility_id) values
  ('11a11f51-2522-7c37-12da-86a78c49ea20', (SELECT id FROM facility WHERE name = 'Parking')),
  ('11a11f51-2522-7c37-12da-86a78c49ea20', (SELECT id FROM facility WHERE name = 'Airport Shuttle')),
  ('11a11f51-2522-7c37-12da-86a78c49ea20', (SELECT id FROM facility WHERE name = 'Free WiFi')),
  ('11a11f51-2522-7c37-12da-86a78c49ea20', (SELECT id FROM facility WHERE name = 'Room Service')),
  ('11a11f51-2522-7c37-12da-86a78c49ea20', (SELECT id FROM facility WHERE name = 'Prayer Room')),
  ('419b1b67-3bd4-755d-05ad-7853c1f76eb9', (SELECT id FROM facility WHERE name = 'Restaurant')),
  ('419b1b67-3bd4-755d-05ad-7853c1f76eb9', (SELECT id FROM facility WHERE name = 'Prayer Room')),
  ('419b1b67-3bd4-755d-05ad-7853c1f76eb9', (SELECT id FROM facility WHERE name = 'Swimming Pool')),
  ('419b1b67-3bd4-755d-05ad-7853c1f76eb9', (SELECT id FROM facility WHERE name = 'Room Service')),
  ('419b1b67-3bd4-755d-05ad-7853c1f76eb9', (SELECT id FROM facility WHERE name = 'Business Center')),
  ('529a2797-6401-7f2e-d6cf-c7403d75e173', (SELECT id FROM facility WHERE name = 'Free WiFi')),
  ('529a2797-6401-7f2e-d6cf-c7403d75e173', (SELECT id FROM facility WHERE name = 'Swimming Pool')),
  ('529a2797-6401-7f2e-d6cf-c7403d75e173', (SELECT id FROM facility WHERE name = 'Concierge')),
  ('529a2797-6401-7f2e-d6cf-c7403d75e173', (SELECT id FROM facility WHERE name = 'Family Rooms')),
  ('6dc0cf0b-9cd7-f78d-f0ca-c5e40c02d4e5', (SELECT id FROM facility WHERE name = 'Free WiFi')),
  ('6dc0cf0b-9cd7-f78d-f0ca-c5e40c02d4e5', (SELECT id FROM facility WHERE name = 'Concierge')),
  ('6dc0cf0b-9cd7-f78d-f0ca-c5e40c02d4e5', (SELECT id FROM facility WHERE name = 'Swimming Pool'))
on conflict do nothing;

-- 6. hotel_images
insert into hotel_images (hotel_slug, url, description, sort_order) values
  ('pullman-zamzam-madina', 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAHKUochPLH_2x8a3RtYjxbWMoVciCbuk7QcnVfJfh0HRovrqBoWYwbXY_MFFH-jUcyvWOXuDKhYj7xpGphQ7AZD9GeaNTah6XUXTVvXMhUMf5_hpqa2DaeDlOUGsrGDoR9W3Reh=s1360-w1360-h1020-rw', 'Image 1 of Pullman Zamzam Madina', 0),
  ('pullman-zamzam-madina', 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAHk1ost6j6hYYM1qT6VVMNPpFyBsU7riFCZD-pKif-sZH-FseZ2fqcDsdFTW5KTreEcmAtHWo40nXXJ3Wswauf4OrCiMQBJ4ma2psoSXDR-nMzQU1QsWWYJvjXmYg14XePxIlaL=s1360-w1360-h1020-rw', 'Image 2 of Pullman Zamzam Madina', 1),
  ('pullman-zamzam-madina', 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAHEwCuXJXqSz7TWXGJv76YlE3UJ63zqwC44nluVTC7oJalMA-pQlqogJ_3kbmQhRpXuZNTbOg7AdS-iX_RWzw_GQt1gx-QOAPgFzTMDJJGMP5fNC2bNzdJ-dHzhYa8iAibccl0=s1360-w1360-h1020-rw', 'Image 3 of Pullman Zamzam Madina', 2),
  ('madinah-hilton', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/716206105.jpg?k=462875a29fc22e3ff2145e06d61709731d1818d63628599620f8c300b1beb621&o=', 'Image 1 of Madinah Hilton', 0),
  ('madinah-hilton', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/492628892.jpg?k=a0d54c5a424774de0ea1d8146b45aed032f56a7d22a719fb25088126862292cb&o=', 'Image 2 of Madinah Hilton', 1),
  ('madinah-hilton', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/492628915.jpg?k=e9beda33ad88e07f809326ee2eb5d5d25d4feb8db5519ac65c7e99241c07cfbf&o=', 'Image 3 of Madinah Hilton', 2),
  ('four-seasons-hotel-riyadh', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/113857950.jpg?k=93e381e54edcf9147ff2dc5664e869daa49e68d515cc793afb16ba28690f50e3&o=', 'Image 1 of Four Seasons Hotel Riyadh', 0),
  ('four-seasons-hotel-riyadh', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/768527061.jpg?k=a270032f7361dceebb983367d9dd771ed88b8d8a9f1f10968200f9c21a361f54&o=', 'Image 2 of Four Seasons Hotel Riyadh', 1),
  ('four-seasons-hotel-riyadh', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/390162795.jpg?k=fa0f24b0fa98efe09d6622a4a7462b4758133118cbf41d9b6c95c03a64bd1685&o=', 'Image 3 of Four Seasons Hotel Riyadh', 2),
  ('doubletree-by-hilton-dhahran', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/483731622.jpg?k=8ec963b1cdadf7106c06c3165a7ef45ff59a6a0da57efd446e383508fa2aaeb5&o=', 'Image 1 of DoubleTree by Hilton Dhahran', 0),
  ('doubletree-by-hilton-dhahran', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/491880730.jpg?k=d19dfcf8ebda266ed4d658bd5f20ddbfd3c436bffb863cf3000c76a5bce27551&o=', 'Image 2 of DoubleTree by Hilton Dhahran', 1),
  ('doubletree-by-hilton-dhahran', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/491880728.jpg?k=0ae4d8069c521250453a8241f884dd1f88bfe61d8a9f77261c9cd1ad3ca7ac83&o=', 'Image 3 of DoubleTree by Hilton Dhahran', 2);

-- 7. hotel_rooms
insert into hotel_rooms (id, hotel_slug, room_category_id, room_number, name, description, beds, city_view, price_per_night, price_per_night_with_breakfast, status) values
  (200000, 'pullman-zamzam-madina', (SELECT id FROM room_category WHERE name = 'Standard'), '100', 'Standard Room', 'Spacious Standard room with elegant decor.', 1, true, 518, 568, 'AVAILABLE'),
  (200001, 'pullman-zamzam-madina', (SELECT id FROM room_category WHERE name = 'Deluxe'), '101', 'Deluxe Room', 'Spacious Deluxe room with elegant decor.', 2, true, 684, 734, 'AVAILABLE'),
  (200002, 'pullman-zamzam-madina', (SELECT id FROM room_category WHERE name = 'Suite'), '102', 'Suite Room', 'Spacious Suite room with elegant decor.', 1, true, 841, 891, 'AVAILABLE'),
  (200003, 'madinah-hilton', (SELECT id FROM room_category WHERE name = 'Standard'), '100', 'Standard Room', 'Spacious Standard room with elegant decor.', 1, true, 501, 551, 'AVAILABLE'),
  (200004, 'madinah-hilton', (SELECT id FROM room_category WHERE name = 'Deluxe'), '101', 'Deluxe Room', 'Spacious Deluxe room with elegant decor.', 2, true, 661, 711, 'AVAILABLE'),
  (200005, 'madinah-hilton', (SELECT id FROM room_category WHERE name = 'Suite'), '102', 'Suite Room', 'Spacious Suite room with elegant decor.', 2, true, 806, 856, 'AVAILABLE'),
  (200006, 'four-seasons-hotel-riyadh', (SELECT id FROM room_category WHERE name = 'Standard'), '100', 'Standard Room', 'Spacious Standard room with elegant decor.', 2, true, 547, 597, 'AVAILABLE'),
  (200007, 'four-seasons-hotel-riyadh', (SELECT id FROM room_category WHERE name = 'Deluxe'), '101', 'Deluxe Room', 'Spacious Deluxe room with elegant decor.', 1, true, 666, 716, 'AVAILABLE'),
  (200008, 'four-seasons-hotel-riyadh', (SELECT id FROM room_category WHERE name = 'Suite'), '102', 'Suite Room', 'Spacious Suite room with elegant decor.', 2, true, 817, 867, 'AVAILABLE'),
  (200009, 'doubletree-by-hilton-dhahran', (SELECT id FROM room_category WHERE name = 'Standard'), '100', 'Standard Room', 'Spacious Standard room with elegant decor.', 1, true, 430, 480, 'AVAILABLE'),
  (200010, 'doubletree-by-hilton-dhahran', (SELECT id FROM room_category WHERE name = 'Deluxe'), '101', 'Deluxe Room', 'Spacious Deluxe room with elegant decor.', 1, true, 584, 634, 'AVAILABLE'),
  (200011, 'doubletree-by-hilton-dhahran', (SELECT id FROM room_category WHERE name = 'Suite'), '102', 'Suite Room', 'Spacious Suite room with elegant decor.', 1, true, 714, 764, 'AVAILABLE')
on conflict do nothing;

-- 8. room_images
insert into room_images (room_id, url) values
  (200000, 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAHk1ost6j6hYYM1qT6VVMNPpFyBsU7riFCZD-pKif-sZH-FseZ2fqcDsdFTW5KTreEcmAtHWo40nXXJ3Wswauf4OrCiMQBJ4ma2psoSXDR-nMzQU1QsWWYJvjXmYg14XePxIlaL=s1360-w1360-h1020-rw'),
  (200001, 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAHEwCuXJXqSz7TWXGJv76YlE3UJ63zqwC44nluVTC7oJalMA-pQlqogJ_3kbmQhRpXuZNTbOg7AdS-iX_RWzw_GQt1gx-QOAPgFzTMDJJGMP5fNC2bNzdJ-dHzhYa8iAibccl0=s1360-w1360-h1020-rw'),
  (200002, 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAHEwCuXJXqSz7TWXGJv76YlE3UJ63zqwC44nluVTC7oJalMA-pQlqogJ_3kbmQhRpXuZNTbOg7AdS-iX_RWzw_GQt1gx-QOAPgFzTMDJJGMP5fNC2bNzdJ-dHzhYa8iAibccl0=s1360-w1360-h1020-rw'),
  (200003, 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/492628892.jpg?k=a0d54c5a424774de0ea1d8146b45aed032f56a7d22a719fb25088126862292cb&o='),
  (200004, 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/716206105.jpg?k=462875a29fc22e3ff2145e06d61709731d1818d63628599620f8c300b1beb621&o='),
  (200005, 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/492628892.jpg?k=a0d54c5a424774de0ea1d8146b45aed032f56a7d22a719fb25088126862292cb&o='),
  (200006, 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/768527061.jpg?k=a270032f7361dceebb983367d9dd771ed88b8d8a9f1f10968200f9c21a361f54&o='),
  (200007, 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/390162795.jpg?k=fa0f24b0fa98efe09d6622a4a7462b4758133118cbf41d9b6c95c03a64bd1685&o='),
  (200008, 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/390162795.jpg?k=fa0f24b0fa98efe09d6622a4a7462b4758133118cbf41d9b6c95c03a64bd1685&o='),
  (200009, 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/491880728.jpg?k=0ae4d8069c521250453a8241f884dd1f88bfe61d8a9f77261c9cd1ad3ca7ac83&o='),
  (200010, 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/491880730.jpg?k=d19dfcf8ebda266ed4d658bd5f20ddbfd3c436bffb863cf3000c76a5bce27551&o='),
  (200011, 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/491880728.jpg?k=0ae4d8069c521250453a8241f884dd1f88bfe61d8a9f77261c9cd1ad3ca7ac83&o=');

-- 9. review
insert into review (id, hotel_id, booking_id, reviewer_name, reviewer_email, overall_rating, feedback) values
  (1000, '11a11f51-2522-7c37-12da-86a78c49ea20', null, 'Ali R.', 'user1000@test.com', 5, 'Great stay at Pullman Zamzam Madina! The staff were welcoming and the room was clean.'),
  (1001, '11a11f51-2522-7c37-12da-86a78c49ea20', null, 'Fatima Y.', 'user1001@test.com', 5, 'Great stay at Pullman Zamzam Madina! The staff were welcoming and the room was clean.'),
  (1002, '11a11f51-2522-7c37-12da-86a78c49ea20', null, 'Ali R.', 'user1002@test.com', 3, 'Great stay at Pullman Zamzam Madina! The staff were welcoming and the room was clean.'),
  (1003, '11a11f51-2522-7c37-12da-86a78c49ea20', null, 'Nour D.', 'user1003@test.com', 5, 'Great stay at Pullman Zamzam Madina! The staff were welcoming and the room was clean.'),
  (1004, '419b1b67-3bd4-755d-05ad-7853c1f76eb9', null, 'Sara H.', 'user1004@test.com', 4, 'Great stay at Madinah Hilton! The staff were welcoming and the room was clean.'),
  (1005, '419b1b67-3bd4-755d-05ad-7853c1f76eb9', null, 'Sara H.', 'user1005@test.com', 4, 'Great stay at Madinah Hilton! The staff were welcoming and the room was clean.'),
  (1006, '419b1b67-3bd4-755d-05ad-7853c1f76eb9', null, 'Tariq M.', 'user1006@test.com', 5, 'Great stay at Madinah Hilton! The staff were welcoming and the room was clean.'),
  (1007, '419b1b67-3bd4-755d-05ad-7853c1f76eb9', null, 'Ali R.', 'user1007@test.com', 4, 'Great stay at Madinah Hilton! The staff were welcoming and the room was clean.'),
  (1008, '529a2797-6401-7f2e-d6cf-c7403d75e173', null, 'Ali R.', 'user1008@test.com', 4, 'Great stay at Four Seasons Hotel Riyadh! The staff were welcoming and the room was clean.'),
  (1009, '529a2797-6401-7f2e-d6cf-c7403d75e173', null, 'Fatima Y.', 'user1009@test.com', 4, 'Great stay at Four Seasons Hotel Riyadh! The staff were welcoming and the room was clean.'),
  (1010, '6dc0cf0b-9cd7-f78d-f0ca-c5e40c02d4e5', null, 'Mohammed A.', 'user1010@test.com', 3, 'Great stay at DoubleTree by Hilton Dhahran! The staff were welcoming and the room was clean.'),
  (1011, '6dc0cf0b-9cd7-f78d-f0ca-c5e40c02d4e5', null, 'Omar S.', 'user1011@test.com', 4, 'Great stay at DoubleTree by Hilton Dhahran! The staff were welcoming and the room was clean.')
on conflict do nothing;

-- 10. review_detail_rating
insert into review_detail_rating (id, review_id, service, rating) values
  (10000, 1000, 'FOOD', 5),
  (10001, 1000, 'COMFORT', 4),
  (10002, 1000, 'VALUE_FOR_MONEY', 4),
  (10003, 1001, 'CLEANLINESS', 4),
  (10004, 1001, 'VALUE_FOR_MONEY', 4),
  (10005, 1001, 'COMFORT', 5),
  (10006, 1001, 'STAFF', 5),
  (10007, 1001, 'FOOD', 4),
  (10008, 1002, 'VALUE_FOR_MONEY', 3),
  (10009, 1002, 'STAFF', 3),
  (10010, 1002, 'COMFORT', 3),
  (10011, 1003, 'STAFF', 5),
  (10012, 1003, 'FOOD', 5),
  (10013, 1003, 'COMFORT', 4),
  (10014, 1003, 'CLEANLINESS', 5),
  (10015, 1003, 'VALUE_FOR_MONEY', 4),
  (10016, 1004, 'FOOD', 4),
  (10017, 1004, 'VALUE_FOR_MONEY', 3),
  (10018, 1004, 'STAFF', 4),
  (10019, 1004, 'CLEANLINESS', 4),
  (10020, 1005, 'COMFORT', 4),
  (10021, 1005, 'STAFF', 3),
  (10022, 1005, 'VALUE_FOR_MONEY', 3),
  (10023, 1005, 'FOOD', 3),
  (10024, 1005, 'CLEANLINESS', 3),
  (10025, 1006, 'COMFORT', 4),
  (10026, 1006, 'VALUE_FOR_MONEY', 5),
  (10027, 1006, 'CLEANLINESS', 4),
  (10028, 1006, 'STAFF', 4),
  (10029, 1006, 'FOOD', 5),
  (10030, 1007, 'CLEANLINESS', 3),
  (10031, 1007, 'COMFORT', 3),
  (10032, 1007, 'FOOD', 4),
  (10033, 1007, 'VALUE_FOR_MONEY', 3),
  (10034, 1008, 'VALUE_FOR_MONEY', 3),
  (10035, 1008, 'STAFF', 4),
  (10036, 1008, 'COMFORT', 4),
  (10037, 1008, 'FOOD', 4),
  (10038, 1009, 'FOOD', 3),
  (10039, 1009, 'VALUE_FOR_MONEY', 3),
  (10040, 1009, 'CLEANLINESS', 3),
  (10041, 1009, 'COMFORT', 4),
  (10042, 1010, 'COMFORT', 3),
  (10043, 1010, 'VALUE_FOR_MONEY', 3),
  (10044, 1010, 'FOOD', 3),
  (10045, 1011, 'COMFORT', 4),
  (10046, 1011, 'FOOD', 4),
  (10047, 1011, 'VALUE_FOR_MONEY', 4),
  (10048, 1011, 'STAFF', 3)
on conflict do nothing;
