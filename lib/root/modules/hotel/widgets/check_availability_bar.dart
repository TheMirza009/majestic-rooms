import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';

class CheckAvailabilityBar extends StatelessWidget {
  final List<num> rates;
  final void Function() onTap;
  const CheckAvailabilityBar({
    super.key,
    required this.rates,
    required this.onTap,
  });

  num _getLowestPrice() {
    if (rates.isEmpty) return 0;
    return rates.reduce((curr, next) => curr < next ? curr : next);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  foregroundColor: context.textLightColor,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  minimumSize: const Size(0, 54),
                ),
                child: Text('Check Availability'.tr),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (rates.length > 1)
                    Text(
                      'Starting from'.tr,
                      style: TextStyle(
                        fontSize: 10,
                        color: context.textMutedColor,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$${_getLowestPrice()}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: context.textMainColor,
                        ),
                      ),
                      Text(
                        ' /night'.tr,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.textMutedColor,
                        ),
                      ),
                      SizedBox(width: 12),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
