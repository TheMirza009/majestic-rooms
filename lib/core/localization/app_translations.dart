import 'package:get/get.dart';
import 'package:majestic_rooms/core/localization/en_us.dart';
import 'package:majestic_rooms/core/localization/ar_sa.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'ar_SA': arSA};
}
