import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';

class CheckAvailabilityBar extends StatelessWidget {
  final List<num> rates;
  final void Function() onTap;
  const CheckAvailabilityBar({super.key, required this.rates, required this.onTap});

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
          color: CustomColors.surfaceWhite,
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
                  backgroundColor: CustomColors.brandRed,
                  foregroundColor: CustomColors.textLight,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  minimumSize: const Size(0, 54),
                ),
                child: const Text("Check Availability"),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (rates.length > 1)
                    const Text(
                      "Starting from",
                      style: TextStyle(
                        fontSize: 10,
                        color: CustomColors.textMuted,
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
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.textMain,
                        ),
                      ),
                      const Text(
                        ' /night',
                        style: TextStyle(
                          fontSize: 11,
                          color: CustomColors.textMuted,
                        ),
                      ),
                      SizedBox(width: 12)
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