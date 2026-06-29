import 'package:majestic_rooms/root/modules/tabs/explore/models/hotel.dart';

/// Placeholder hotels for UI development. Cities match
/// `ExploreController.categories` so the category chips can filter them.
const List<Hotel> kDummyHotels = [

  // ── Mecca ───────────────────────────────────────────────────────────────
  Hotel(name: 'Makkah Clock Royal Tower', address: 'Abraj Al Bait, King Abdul Aziz Endowment', city: 'Mecca', imageUrl: 'https://picsum.photos/seed/mecca1/600/400', rate: 420, rating: 4.8),
  Hotel(name: 'Hilton Suites Makkah', address: 'Jabal Al Kaaba, Central Area', city: 'Mecca', imageUrl: 'https://picsum.photos/seed/mecca2/600/400', rate: 310, rating: 4.6),
  Hotel(name: 'Conrad Makkah', address: 'Jabal Omar Development, Ibrahim Al Khalil Rd', city: 'Mecca', imageUrl: 'https://picsum.photos/seed/mecca3/600/400', rate: 360, rating: 4.7),
  Hotel(name: 'Swissôtel Al Maqam', address: 'Abraj Al Bait Complex', city: 'Mecca', imageUrl: 'https://picsum.photos/seed/mecca4/600/400', rate: 290, rating: 4.5),
  Hotel(name: 'Pullman ZamZam Makkah', address: 'Abraj Al Bait, Haram Boundary', city: 'Mecca', imageUrl: 'https://picsum.photos/seed/mecca5/600/400', rate: 340, rating: 4.6),

  // ── Medina ──────────────────────────────────────────────────────────────
  Hotel(name: 'Anwar Al Madinah Mövenpick', address: 'Central Area, Near Prophet\'s Mosque', city: 'Medina', imageUrl: 'https://picsum.photos/seed/medina1/600/400', rate: 280, rating: 4.7),
  Hotel(name: 'The Oberoi Madina', address: 'King Fahd Road, Central Zone', city: 'Medina', imageUrl: 'https://picsum.photos/seed/medina2/600/400', rate: 350, rating: 4.9),
  Hotel(name: 'Dar Al Taqwa Hotel', address: 'Central Area, Al Haram', city: 'Medina', imageUrl: 'https://picsum.photos/seed/medina3/600/400', rate: 300, rating: 4.6),
  Hotel(name: 'Pullman Zamzam Madina', address: 'King Fahd Road', city: 'Medina', imageUrl: 'https://picsum.photos/seed/medina4/600/400', rate: 270, rating: 4.5),
  Hotel(name: 'Crowne Plaza Madinah', address: 'Eastern Central Area', city: 'Medina', imageUrl: 'https://picsum.photos/seed/medina5/600/400', rate: 320, rating: 4.7),

  // ── Jeddah ──────────────────────────────────────────────────────────────
  Hotel(name: 'Jeddah Hilton', address: 'North Corniche Road', city: 'Jeddah', imageUrl: 'https://picsum.photos/seed/jeddah1/600/400', rate: 240, rating: 4.5),
  Hotel(name: 'Rosewood Jeddah', address: 'Al Shati District, Corniche', city: 'Jeddah', imageUrl: 'https://picsum.photos/seed/jeddah2/600/400', rate: 390, rating: 4.8),
  Hotel(name: 'Park Hyatt Jeddah', address: 'Al Hamra District, Corniche', city: 'Jeddah', imageUrl: 'https://picsum.photos/seed/jeddah3/600/400', rate: 410, rating: 4.9),
  Hotel(name: 'Waldorf Astoria Jeddah', address: 'Qasr Khozam', city: 'Jeddah', imageUrl: 'https://picsum.photos/seed/jeddah4/600/400', rate: 370, rating: 4.7),
  Hotel(name: 'Shangri-La Jeddah', address: 'Al Shati, North Corniche', city: 'Jeddah', imageUrl: 'https://picsum.photos/seed/jeddah5/600/400', rate: 330, rating: 4.6),

  // ── Riyadh ──────────────────────────────────────────────────────────────
  Hotel(name: 'Four Seasons Riyadh', address: 'Kingdom Centre, Al Olaya', city: 'Riyadh', imageUrl: 'https://picsum.photos/seed/riyadh1/600/400', rate: 410, rating: 4.9),
  Hotel(name: 'Hyatt Regency Riyadh', address: 'Olaya Street, Al Murooj', city: 'Riyadh', imageUrl: 'https://picsum.photos/seed/riyadh2/600/400', rate: 300, rating: 4.6),
  Hotel(name: 'The Ritz-Carlton Riyadh', address: 'Al Hada Area, Mekkah Road', city: 'Riyadh', imageUrl: 'https://picsum.photos/seed/riyadh3/600/400', rate: 450, rating: 4.9),
  Hotel(name: 'Burj Rafal Kempinski', address: 'King Fahd Road, Al Mughrizat', city: 'Riyadh', imageUrl: 'https://picsum.photos/seed/riyadh4/600/400', rate: 360, rating: 4.7),
  Hotel(name: 'Narcissus Hotel & Spa', address: 'Olaya Street', city: 'Riyadh', imageUrl: 'https://picsum.photos/seed/riyadh5/600/400', rate: 280, rating: 4.5),

  // ── Khobar ──────────────────────────────────────────────────────────────
  Hotel(name: 'Sofitel Al Khobar', address: 'Corniche Road, Al Khobar', city: 'Khobar', imageUrl: 'https://picsum.photos/seed/khobar1/600/400', rate: 260, rating: 4.5),
  Hotel(name: 'Le Méridien Al Khobar', address: 'King Faisal Bin Abdul Aziz Road', city: 'Khobar', imageUrl: 'https://picsum.photos/seed/khobar2/600/400', rate: 230, rating: 4.4),
  Hotel(name: 'Mövenpick Al Khobar', address: 'Prince Turkey Street, Corniche', city: 'Khobar', imageUrl: 'https://picsum.photos/seed/khobar3/600/400', rate: 250, rating: 4.5),
  Hotel(name: 'Park Inn by Radisson', address: 'King Fahd Road', city: 'Khobar', imageUrl: 'https://picsum.photos/seed/khobar4/600/400', rate: 190, rating: 4.2),
  Hotel(name: 'Boudl Gardenia Resort', address: 'Half Moon Bay', city: 'Khobar', imageUrl: 'https://picsum.photos/seed/khobar5/600/400', rate: 300, rating: 4.6),

  // ── Dhahran ─────────────────────────────────────────────────────────────
  Hotel(name: 'Carlton Almoaibed', address: 'King Saud Street, Dhahran', city: 'Dhahran', imageUrl: 'https://picsum.photos/seed/dhahran1/600/400', rate: 210, rating: 4.3),
  Hotel(name: 'Sadaf Dhahran Hotel', address: 'Dhahran Street', city: 'Dhahran', imageUrl: 'https://picsum.photos/seed/dhahran2/600/400', rate: 180, rating: 4.1),
  Hotel(name: 'Ramada by Wyndham', address: 'King Abdul Aziz Road', city: 'Dhahran', imageUrl: 'https://picsum.photos/seed/dhahran3/600/400', rate: 200, rating: 4.2),
  Hotel(name: 'Aloft Dhahran', address: 'Dhahran Towers', city: 'Dhahran', imageUrl: 'https://picsum.photos/seed/dhahran4/600/400', rate: 240, rating: 4.4),
  Hotel(name: 'Courtyard by Marriott', address: 'Doha District', city: 'Dhahran', imageUrl: 'https://picsum.photos/seed/dhahran5/600/400', rate: 230, rating: 4.3),

  // ── Abha ────────────────────────────────────────────────────────────────
  Hotel(name: 'Blue Inn Boutique', address: 'Al Faisaliyah District, Abha', city: 'Abha', imageUrl: 'https://picsum.photos/seed/abha1/600/400', rate: 180, rating: 4.4),
  Hotel(name: 'Abha Palace Hotel', address: 'Al Saad Lake, Abha', city: 'Abha', imageUrl: 'https://picsum.photos/seed/abha2/600/400', rate: 220, rating: 4.5),
  Hotel(name: 'Mountain Top Resort', address: 'Al Soudah Heights', city: 'Abha', imageUrl: 'https://picsum.photos/seed/abha3/600/400', rate: 260, rating: 4.6),
  Hotel(name: 'Aloft Abha', address: 'King Fahd Road', city: 'Abha', imageUrl: 'https://picsum.photos/seed/abha4/600/400', rate: 200, rating: 4.3),
  Hotel(name: 'Qasr Al Azizia', address: 'Downtown Abha', city: 'Abha', imageUrl: 'https://picsum.photos/seed/abha5/600/400', rate: 170, rating: 4.2),
];
