import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';

/// Formats [amount] with the app-wide currency symbol from [CommonController].
/// Example: formatPrice(420) → "$420"
String formatPrice(num amount) {
  final symbol = Get.find<CommonController>().currencySymbol.value;
  return '$symbol${amount.toStringAsFixed(0)}';
}
