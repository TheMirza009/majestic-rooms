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
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
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
          const Text(
            'Preferences',
            style: TextStyle(
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
            child: ListTile(
              leading: const Icon(Icons.attach_money_rounded, color: CustomColors.textMain),
              title: const Text(
                'Currency',
                style: TextStyle(
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
                    title: const Text('Select Currency'),
                    actions: <CupertinoActionSheetAction>[
                      CupertinoActionSheetAction(
                        onPressed: () {
                          controller.currencySymbol.value = r'$';
                          Navigator.pop(context);
                        },
                        child: const Text('USD (\$)'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          controller.currencySymbol.value = 'SAR';
                          Navigator.pop(context);
                        },
                        child: const Text('SAR (SAR)'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          controller.currencySymbol.value = '€';
                          Navigator.pop(context);
                        },
                        child: const Text('EUR (€)'),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrencyName(String symbol) {
    switch (symbol) {
      case r'$': return 'USD (\$)';
      case 'SAR': return 'SAR (SAR)';
      case '€': return 'EUR (€)';
      default: return symbol;
    }
  }
}
