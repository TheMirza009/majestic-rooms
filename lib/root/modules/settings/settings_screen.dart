
import 'package:flutter/foundation.dart';
import 'package:majestic_rooms/core/theme/app_theme.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommonController>();

    return Scaffold(
      // backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        // backgroundColor: const Color(0xFFF7F7F9),
        // surfaceTintColor: const Color(0xFFF7F7F9),
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.textMainColor,
            ),
          ),
          const SizedBox(height: 16),
          Material(
            color: context.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              side: BorderSide(color: context.borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.attach_money_rounded,
                    color: context.textMainColor,
                  ),
                  title: Text(
                    'Currency'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.textMainColor,
                    ),
                  ),
                  trailing: Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getCurrencyName(controller.currencySymbol.value),
                          style: TextStyle(
                            fontSize: 14,
                            color: context.textMutedColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right,
                          color: context.textMutedColor,
                        ),
                      ],
                    ),
                  ),
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
                Divider(height: 1, thickness: 1, color: context.borderColor),
                ListTile(
                  leading: Icon(
                    Icons.language_rounded,
                    color: context.textMainColor,
                  ),
                  title: Text(
                    'Language'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.textMainColor,
                    ),
                  ),
                  trailing: Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getLanguageName(controller.languageCode.value),
                          style: TextStyle(
                            fontSize: 14,
                            color: context.textMutedColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right,
                          color: context.textMutedColor,
                        ),
                      ],
                    ),
                  ),
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
                            child: const Text('English'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              controller.changeLanguage('ar', 'SA');
                              Navigator.pop(context);
                            },
                            child: const Text('العربية'),
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
                if (kDebugMode) ...[
                  Divider(height: 1, thickness: 1, color: context.borderColor),
                  const ThemeDebuggerTile(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrencyName(String symbol) {
    switch (symbol) {
      case r'$':
        return 'USD (\$)'.tr;
      case 'SAR':
        return 'SAR (SAR)'.tr;
      case '€':
        return 'EUR (€)'.tr;
      default:
        return symbol;
    }
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }
}

class ThemeDebuggerTile extends StatelessWidget {
  const ThemeDebuggerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const Border(),
      leading: Icon(
        Icons.color_lens_outlined,
        color: context.textMainColor,
      ),
      title: Text(
        'Theme Debugger',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: context.textMainColor,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ThemeCircle(
                color: CustomColors.brandRed,
                onTap: () => Get.find<CommonController>().changeTheme(AppThemeSets.redTheme),
              ),
              _ThemeCircle(
                color: CustomColors.brandGreen,
                onTap: () => Get.find<CommonController>().changeTheme(AppThemeSets.greenTheme),
              ),
              _ThemeCircle(
                color: CustomColors.brandBlue,
                onTap: () => Get.find<CommonController>().changeTheme(AppThemeSets.blueTheme),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeCircle extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _ThemeCircle({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isActive = context.primaryColor.value == color.value;
    final double iconSize = 24.0;
    final double activeSize = iconSize * 1.15; // 27.6
    final double inactiveSize = iconSize; // 24.0
    final double innerSize = isActive ? activeSize : inactiveSize;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: isActive ? const EdgeInsets.all(3.0) : EdgeInsets.zero,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? context.primaryColor : context.primaryColor.withValues(alpha: 0.0),
          width: 2.0,
        ),
      ),
      child: Material(
        type: MaterialType.circle,
        color: color,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: innerSize,
            height: innerSize,
            color: Colors.transparent, 
          ),
        ),
      ),
    );
  }
}
