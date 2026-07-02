import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/booking/booking_controller.dart';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _fmt(DateTime d) => '${_months[d.month - 1]} ${d.day}';

class DateRangeSelectionCard extends StatelessWidget {
  const DateRangeSelectionCard({super.key});

  // ── Control Panel ─────────────────────────────────────────────────────────
  static const double _radius = 18;
  static const double _iconBadgeSize = 44;
  static const double _iconBadgeRadius = 14;
  static const EdgeInsets _cardPadding = EdgeInsets.fromLTRB(16, 12, 16, 4);
  static const EdgeInsets _contentPadding = EdgeInsets.all(14);
  static const Color _borderColor = Color(0x14000000); // faint definition, no shadow

  static const TextStyle _titleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    fontFamily: 'Fustat',
    color: CustomColors.textMain,
  );
  static const TextStyle _subtitleIdleStyle = TextStyle(
    fontSize: 13,
    fontFamily: 'Fustat',
    fontWeight: FontWeight.w400,
    color: CustomColors.textMuted,
  );
  static const TextStyle _subtitleSetStyle = TextStyle(
    fontSize: 13,
    fontFamily: 'Fustat',
    fontWeight: FontWeight.w600,
    color: CustomColors.brandRed,
  );
  static const TextStyle _editStyle = TextStyle(
    fontSize: 13,
    fontFamily: 'Fustat',
    fontWeight: FontWeight.w700,
    color: CustomColors.brandRed,
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    return Padding(
      padding: _cardPadding,
      child: Obx(() {
        final range = controller.dateRange.value;
        final subtitle = range == null
            ? 'Tap to select'
            : '${_fmt(range.start)} → ${_fmt(range.end)}  ·  ${controller.nights} night${controller.nights == 1 ? '' : 's'}';

        return Container(
          decoration: BoxDecoration(
            color: CustomColors.cardSubtleBg,
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(color: _borderColor),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () => controller.selectDateRange(context),
              borderRadius: BorderRadius.circular(_radius),
              child: Padding(
                padding: _contentPadding,
                child: Row(
                  children: [
                    // ICON BADGE
                    Container(
                      width: _iconBadgeSize,
                      height: _iconBadgeSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: CustomColors.brandRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(_iconBadgeRadius),
                      ),
                      child: const Icon(
                        Icons.calendar_today_rounded,
                        color: CustomColors.brandRed,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // TITLE + SUBTITLE
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Stay Dates', style: _titleStyle),
                          const SizedBox(height: 3),
                          Text(
                            subtitle,
                            style:
                                range == null ? _subtitleIdleStyle : _subtitleSetStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // EDIT
                    const Text('Edit', style: _editStyle),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}