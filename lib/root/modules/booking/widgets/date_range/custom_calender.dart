import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// user for DateTime formatting
import 'package:intl/intl.dart';

/// `const CustomCalendar({
///   Key? key,
///   this.initialStartDate,
///   this.initialEndDate,
///   this.startEndDateChange,
///   this.minimumDate,
///   this.maximumDate,
///   required this.primaryColor,
///   this.rangeColor,
/// })`
class CustomCalendar extends StatefulWidget {
  /// The minimum date that can be selected on the calendar
  final DateTime? minimumDate;

  /// The maximum date that can be selected on the calendar
  final DateTime? maximumDate;

  /// The initial start date to be shown on the calendar
  final DateTime? initialStartDate;

  /// The initial end date to be shown on the calendar
  final DateTime? initialEndDate;

  /// The primary color to be used in the calendar's color scheme
  final Color primaryColor;

  /// The color used to paint the range streak between the start and end date.
  /// Defaults to [primaryColor] at 40% opacity when not provided.
  final Color? rangeColor;

  /// A function to be called when the selected date range changes
  final Function(DateTime?, DateTime?)? startEndDateChange;

  const CustomCalendar({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.startEndDateChange,
    this.minimumDate,
    this.maximumDate,
    required this.primaryColor,
    this.rangeColor,
  });

  @override
  CustomCalendarState createState() => CustomCalendarState();
}

class CustomCalendarState extends State<CustomCalendar> {
  // ── Control Panel ──────────────────────────────────────────────────────
  // All tuneable values live here. No need to dig into method bodies to adjust.

  // Shared implicit-animation timing for the streak, sliding circles, and
  // page swipe (kept identical so every transition feels like one motion).
  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Curve animationCurve = Curves.easeInOut;

  // Fallback paging window when minimumDate/maximumDate aren't provided.
  static const int pageBoundsYears = 10;

  // Fixed grid shape (leading/trailing padding days always fill 6 rows).
  static const int gridColumns = 7;
  static const int gridRows = 6;

  // ── Fields ────────────────────────────────────────────────────────────

  late final PageController pageController;
  late final DateTime baseMonth;
  late final int totalMonths;

  DateTime currentMonthDate = DateTime.now();

  DateTime? startDate;

  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;

    final DateTime today = DateTime.now();
    final DateTime minMonth = widget.minimumDate != null
        ? DateTime(widget.minimumDate!.year, widget.minimumDate!.month)
        : DateTime(today.year - pageBoundsYears, today.month);
    final DateTime maxMonth = widget.maximumDate != null
        ? DateTime(widget.maximumDate!.year, widget.maximumDate!.month)
        : DateTime(today.year + pageBoundsYears, today.month);

    baseMonth = minMonth;
    totalMonths = monthsBetween(minMonth, maxMonth) + 1;

    final DateTime anchorDate = startDate ?? today;
    final int initialPage = monthsBetween(baseMonth, DateTime(anchorDate.year, anchorDate.month)).clamp(0, totalMonths - 1);
    pageController = PageController(initialPage: initialPage);
    currentMonthDate = monthAtPage(initialPage);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // MONTH HEADER — arrows animate the PageView instead of jump-cutting the grid
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 4),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                      onTap: goToPreviousMonth,
                      child: const Icon(Icons.keyboard_arrow_left, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: animationDuration,
                    child: Text(
                      DateFormat('MMMM, yyyy', Get.locale?.languageCode).format(currentMonthDate),
                      key: ValueKey<String>(DateFormat('yyyy-MM').format(currentMonthDate)),
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.grey.shade700),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                      onTap: goToNextMonth,
                      child: const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // DAY NAMES ROW
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
          child: Row(
            children: <Widget>[
              for (int weekday = 0; weekday < gridColumns; weekday++)
                Expanded(
                  child: Center(
                    child: Text(
                      DateFormat('EEE', Get.locale?.languageCode).format(DateTime(2024, 1, 1 + weekday)),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: widget.primaryColor),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // MONTH PAGES — swipeable grid, one page per month
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: SizedBox(
            height: MediaQuery.of(context).size.width * (gridRows / gridColumns),
            child: PageView.builder(
              controller: pageController,
              itemCount: totalMonths,
              onPageChanged: (int page) => setState(() => currentMonthDate = monthAtPage(page)),
              itemBuilder: (BuildContext context, int page) => monthGrid(monthAtPage(page)),
            ),
          ),
        ),
      ],
    );
  }

  // ── Paging helpers ───────────────────────────────────────────────────

  // Number of whole calendar months between two month-truncated DateTimes.
  int monthsBetween(DateTime from, DateTime to) => (to.year - from.year) * 12 + (to.month - from.month);

  DateTime monthAtPage(int page) => DateTime(baseMonth.year, baseMonth.month + page);

  // Animates the PageView one month back; onPageChanged updates currentMonthDate.
  void goToPreviousMonth() {
    pageController.previousPage(duration: animationDuration, curve: animationCurve);
  }

  // Animates the PageView one month forward; onPageChanged updates currentMonthDate.
  void goToNextMonth() {
    pageController.nextPage(duration: animationDuration, curve: animationCurve);
  }

  // ── Date helpers ─────────────────────────────────────────────────────

  bool isSameDate(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  /// Builds the fixed 6x7 (42-cell) day list for [monthDate], padded with the
  /// trailing days of the previous month and leading days of the next month.
  List<DateTime> datesForMonth(DateTime monthDate) {
    final List<DateTime> dates = <DateTime>[];
    final DateTime lastDayOfPreviousMonth = DateTime(monthDate.year, monthDate.month, 0);
    int previousMonthDays = 0;
    if (lastDayOfPreviousMonth.weekday < 7) {
      previousMonthDays = lastDayOfPreviousMonth.weekday;
      for (int i = 1; i <= previousMonthDays; i++) {
        dates.add(lastDayOfPreviousMonth.subtract(Duration(days: previousMonthDays - i)));
      }
    }
    for (int i = 0; i < (gridRows * gridColumns - previousMonthDays); i++) {
      dates.add(lastDayOfPreviousMonth.add(Duration(days: i + 1)));
    }
    return dates;
  }

  bool isDateSelectable(DateTime date) {
    if (widget.minimumDate != null && date.isBefore(DateTime(widget.minimumDate!.year, widget.minimumDate!.month, widget.minimumDate!.day))) {
      return false;
    }
    if (widget.maximumDate != null && date.isAfter(DateTime(widget.maximumDate!.year, widget.maximumDate!.month, widget.maximumDate!.day))) {
      return false;
    }
    return true;
  }

  // Fractional grid alignment (-1..1 on both axes) for a 0-based cell index.
  Alignment alignmentForIndex(int index) {
    final int row = index ~/ gridColumns;
    final int col = index % gridColumns;
    return Alignment(-1 + col * (2 / (gridColumns - 1)), -1 + row * (2 / (gridRows - 1)));
  }

  // Handles taps in priority order: first pick, deselect toggles, then range
  // moves (rules 4/5). Crossing before the current low date swaps handles
  // instead of collapsing the range, so exactly one circle slides per tap.
  void onDateClick(DateTime date) {
    if (!isDateSelectable(date)) return;

    if (startDate == null && endDate == null) {
      setState(() {
        startDate = date;
      });
      widget.startEndDateChange?.call(startDate, endDate);
      return;
    }
    if (startDate != null && endDate == null) {
      setState(() {
        if (isSameDate(date, startDate!)) {
          startDate = null;
        } else {
          endDate = date;
        }
      });
      widget.startEndDateChange?.call(startDate, endDate);
      return;
    }
    setState(() {
      if (isSameDate(date, endDate!)) {
        endDate = null;
      } else if (date.isBefore(startDate!)) {
        endDate = startDate;
        startDate = date;
      } else {
        endDate = date;
      }
      widget.startEndDateChange?.call(startDate, endDate);
    });
  }

  // ── Month grid ───────────────────────────────────────────────────────

  Widget monthGrid(DateTime monthDate) {
    final List<DateTime> dates = datesForMonth(monthDate);

    final DateTime? lowDate =
        startDate == null ? null : (endDate == null || startDate!.isBefore(endDate!) ? startDate : endDate);
    final DateTime? highDate =
        endDate == null ? null : (startDate == null || startDate!.isBefore(endDate!) ? endDate : startDate);

    final int lowIndex = lowDate == null ? -1 : dates.indexWhere((DateTime d) => isSameDate(d, lowDate));
    final int highIndex = highDate == null ? -1 : dates.indexWhere((DateTime d) => isSameDate(d, highDate));

    final Color rangeColor = widget.rangeColor ?? widget.primaryColor.withValues(alpha: 0.4);

    return Stack(
      children: <Widget>[
        // RANGE STREAK — fades in/out per cell instead of appearing instantly
        IgnorePointer(
          child: Column(
            children: <Widget>[
              for (int row = 0; row < gridRows; row++)
                Expanded(
                  child: Row(
                    children: <Widget>[
                      for (int col = 0; col < gridColumns; col++)
                        streakCell(dates[row * gridColumns + col], lowDate, highDate, rangeColor),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // SELECTION CIRCLES — slide between cells within the visible month
        if (lowIndex != -1)
          selectionCircle(alignmentForIndex(lowIndex)),
        if (highIndex != -1)
          selectionCircle(alignmentForIndex(highIndex)),

        // DAY NUMBERS + TAP TARGETS
        Column(
          children: <Widget>[
            for (int row = 0; row < gridRows; row++)
              Expanded(
                child: Row(
                  children: <Widget>[
                    for (int col = 0; col < gridColumns; col++)
                      dayCell(dates[row * gridColumns + col], monthDate, lowDate, highDate),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget streakCell(DateTime date, DateTime? lowDate, DateTime? highDate, Color rangeColor) {
    final bool inStreak = lowDate != null &&
        highDate != null &&
        !date.isBefore(lowDate) &&
        !date.isAfter(highDate);
    final bool isLowEdge = lowDate != null && isSameDate(date, lowDate);
    final bool isHighEdge = highDate != null && isSameDate(date, highDate);

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: EdgeInsets.only(top: 3, bottom: 3, left: isLowEdge ? 4 : 0, right: isHighEdge ? 4 : 0),
          child: AnimatedContainer(
            duration: animationDuration,
            curve: animationCurve,
            decoration: BoxDecoration(
              color: inStreak ? rangeColor : rangeColor.withValues(alpha: 0),
              borderRadius: BorderRadius.only(
                bottomLeft: isLowEdge ? const Radius.circular(24.0) : Radius.zero,
                topLeft: isLowEdge ? const Radius.circular(24.0) : Radius.zero,
                topRight: isHighEdge ? const Radius.circular(24.0) : Radius.zero,
                bottomRight: isHighEdge ? const Radius.circular(24.0) : Radius.zero,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectionCircle(Alignment alignment) {
    return IgnorePointer(
      child: AnimatedAlign(
        duration: animationDuration,
        curve: animationCurve,
        alignment: alignment,
        child: FractionallySizedBox(
          widthFactor: 1 / gridColumns,
          heightFactor: 1 / gridRows,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: AnimatedContainer(
              duration: animationDuration,
              curve: animationCurve,
              decoration: BoxDecoration(
                color: widget.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: <BoxShadow>[
                  BoxShadow(color: Colors.grey.withValues(alpha: 0.6), blurRadius: 4, offset: const Offset(0, 0)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dayCell(DateTime date, DateTime monthDate, DateTime? lowDate, DateTime? highDate) {
    final bool isCurrentMonth = date.month == monthDate.month;
    final bool isSelected = (lowDate != null && isSameDate(date, lowDate)) || (highDate != null && isSameDate(date, highDate));
    final bool isToday = isSameDate(date, DateTime.now());
    final bool inStreak = lowDate != null && highDate != null && !date.isBefore(lowDate) && !date.isAfter(highDate);

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                onTap: isCurrentMonth ? () => onDateClick(date) : null,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: animationDuration,
                      curve: animationCurve,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : isCurrentMonth
                                ? widget.primaryColor
                                : Colors.grey.withValues(alpha: 0.6),
                        fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      child: Text('${date.day}'),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 9,
              right: 0,
              left: 0,
              child: Container(
                height: 6,
                width: 6,
                decoration: BoxDecoration(
                  color: isToday ? (inStreak ? Colors.white : widget.primaryColor) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}