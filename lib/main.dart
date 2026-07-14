import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/app_binding.dart';
import 'package:majestic_rooms/core/localization/app_translations.dart';
import 'package:majestic_rooms/core/routes/app_pages.dart';
import 'package:majestic_rooms/core/supabase/environment.dart';
import 'package:majestic_rooms/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:majestic_rooms/core/routes/app_routes.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Environment.supabaseUrl,
    publishableKey: Environment.supabaseAnonKey,
  );

  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('language_code') ?? 'en';
  final countryCode = prefs.getString('country_code') ?? 'US';
  final locale = Locale(langCode, countryCode);

  await initializeDateFormatting(locale.languageCode, null);

  // Option A (Current): Direct Navigation.
  // Since `Supabase.initialize` synchronously restores the session from local
  // storage, we can instantly determine the route before the first frame is drawn.
  // This bypasses any fake delays and shows the correct screen immediately.
  //
  // Option B (Future): If you ever need a dedicated Flutter Splash Screen
  // (e.g., to run a logo animation or do heavy data prefetching), change this
  // back to `const MyApp(initialRoute: AppRoutes.splash)` and let the
  // SplashController handle the navigation check after a delay.
  final session = Supabase.instance.client.auth.currentSession;
  final initialRoute = session != null ? AppRoutes.home : AppRoutes.login;

  runApp(MyApp(initialRoute: initialRoute, locale: locale));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final Locale locale;

  const MyApp({super.key, required this.initialRoute, required this.locale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Majestic Rooms',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: AppBinding(),
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
