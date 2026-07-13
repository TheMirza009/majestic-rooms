import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommonController>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        surfaceTintColor: const Color(0xFFF7F7F9),
        centerTitle: true,
        title: Text(
          'Settings'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            'Preferences'.tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: CustomColors.textMain,
            ),
          ),
          const SizedBox(height: 16),
          Material(
            color: CustomColors.surfaceWhite,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              side: BorderSide(color: CustomColors.borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.attach_money_rounded, color: CustomColors.textMain),
                  title: Text(
                    'Currency'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.textMain,
                    ),
                  ),
                  trailing: Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getCurrencyName(controller.currencySymbol.value),
                        style: const TextStyle(fontSize: 14, color: CustomColors.textMuted),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, color: CustomColors.textMuted),
                    ],
                  )),
                  onTap: () {
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                        title: Text('Select Currency'.tr),
                        actions: <CupertinoActionSheetAction>[
                          CupertinoActionSheetAction(
                            onPressed: () {
                              controller.currencySymbol.value = r'$';
                              Navigator.pop(context);
                            },
                            child: Text('USD (\$)'.tr),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              controller.currencySymbol.value = 'SAR';
                              Navigator.pop(context);
                            },
                            child: Text('SAR (SAR)'.tr),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              controller.currencySymbol.value = '€';
                              Navigator.pop(context);
                            },
                            child: Text('EUR (€)'.tr),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'.tr),
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1, color: CustomColors.borderColor),
                ListTile(
                  leading: const Icon(Icons.language_rounded, color: CustomColors.textMain),
                  title: Text(
                    'Language'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.textMain,
                    ),
                  ),
                  trailing: Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getLanguageName(controller.languageCode.value),
                        style: const TextStyle(fontSize: 14, color: CustomColors.textMuted),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, color: CustomColors.textMuted),
                    ],
                  )),
                  onTap: () {
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                        title: Text('Select Language'.tr),
                        actions: <CupertinoActionSheetAction>[
                          CupertinoActionSheetAction(
                            onPressed: () {
                              controller.changeLanguage('en', 'US');
                              Navigator.pop(context);
                            },
                            child: Text('English'.tr),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              controller.changeLanguage('ar', 'SA');
                              Navigator.pop(context);
                            },
                            child: Text('Arabic'.tr),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'.tr),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrencyName(String symbol) {
    switch (symbol) {
      case r'$': return 'USD (\$)'.tr;
      case 'SAR': return 'SAR (SAR)'.tr;
      case '€': return 'EUR (€)'.tr;
      default: return symbol;
    }
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en': return 'English'.tr;
      case 'ar': return 'Arabic'.tr;
      default: return 'English'.tr;
    }
  }
}
