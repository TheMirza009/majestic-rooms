import 'package:majestic_rooms/root/modules/booking/widgets/date_range/custom_calender.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// user for DateTime formatting
import 'package:intl/intl.dart' hide TextDirection;

/// A custom date range picker widget that allows users to select a date range.
/// `const CustomDateRangePicker({
///   Key? key,
///   this.initialStartDate,
///   this.initialEndDate,
///   required this.primaryColor,
///   required this.backgroundColor,
///   this.rangeColor,
///   required this.onApplyClick,
///   this.barrierDismissible = true,
///   required this.minimumDate,
///   required this.maximumDate,
///   required this.onCancelClick,
/// })`
class CustomDateRangePicker extends StatefulWidget {
  /// The minimum date that can be selected in the calendar.
  final DateTime minimumDate;

  /// The maximum date that can be selected in the calendar.
  final DateTime maximumDate;

  /// Whether the widget can be dismissed by tapping outside of it.
  final bool barrierDismissible;

  /// The initial start date for the date range picker. If not provided, the calendar will default to the minimum date.
  final DateTime? initialStartDate;

  /// The initial end date for the date range picker. If not provided, the calendar will default to the maximum date.
  final DateTime? initialEndDate;

  /// The primary color used for the date range picker.
  final Color primaryColor;

  /// The background color used for the date range picker.
  final Color backgroundColor;

  /// The color used to paint the range streak between the start and end date.
  /// Defaults to [primaryColor] at 40% opacity when not provided.
  final Color? rangeColor;

  /// A callback function that is called when the user applies the selected date range.
  final Function(DateTime, DateTime) onApplyClick;

  /// A callback function that is called when the user cancels the selection of the date range.
  final Function() onCancelClick;

  const CustomDateRangePicker({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.primaryColor,
    required this.backgroundColor,
    this.rangeColor,
    required this.onApplyClick,
    this.barrierDismissible = true,
    required this.minimumDate,
    required this.maximumDate,
    required this.onCancelClick,
  });

  @override
  CustomDateRangePickerState createState() => CustomDateRangePickerState();
}

class CustomDateRangePickerState extends State<CustomDateRangePicker> with TickerProviderStateMixin {
  // ── Control Panel ──────────────────────────────────────────────────────
  static const Duration animationDuration = Duration(milliseconds: 250);

  AnimationController? animationController;

  DateTime? startDate;

  DateTime? endDate;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (widget.barrierDismissible) {
              Navigator.pop(context);
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: Colors.grey.withValues(alpha: 0.2), offset: const Offset(4, 4), blurRadius: 8.0),
                  ],
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          // FROM LABEL
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'From'.tr,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey.shade700),
                                ),
                                const SizedBox(height: 4),
                                AnimatedSwitcher(
                                  duration: animationDuration,
                                  child: Text(
                                    startDate != null ? DateFormat('EEE, dd MMM', Get.locale?.languageCode).format(startDate!) : '--/-- ',
                                    key: ValueKey<String>('from-${startDate?.toIso8601String()}'),
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(height: 74, width: 1, color: Colors.grey.shade200),
                          // TO LABEL
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'To'.tr,
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey.shade700),
                                ),
                                const SizedBox(height: 4),
                                AnimatedSwitcher(
                                  duration: animationDuration,
                                  child: Text(
                                    endDate != null ? DateFormat('EEE, dd MMM', Get.locale?.languageCode).format(endDate!) : '--/-- ',
                                    key: ValueKey<String>('to-${endDate?.toIso8601String()}'),
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade700),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(height: 1),
                      // CALENDAR
                      CustomCalendar(
                        minimumDate: widget.minimumDate,
                        maximumDate: widget.maximumDate,
                        initialEndDate: widget.initialEndDate,
                        initialStartDate: widget.initialStartDate,
                        primaryColor: widget.primaryColor,
                        rangeColor: widget.rangeColor,
                        startEndDateChange: (DateTime? startDateData, DateTime? endDateData) {
                          setState(() {
                            startDate = startDateData;
                            endDate = endDateData;
                          });
                        },
                      ),
                      // ACTION BUTTONS
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(24.0))),
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    side: WidgetStateProperty.all(BorderSide(color: widget.primaryColor)),
                                    shape: WidgetStateProperty.all(
                                      const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
                                    ),
                                    backgroundColor: WidgetStateProperty.all(widget.primaryColor),
                                  ),
                                  onPressed: onCancelPressed,
                                  child: Center(
                                    child: Text('Cancel'.tr, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(24.0))),
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    side: WidgetStateProperty.all(BorderSide(color: widget.primaryColor)),
                                    shape: WidgetStateProperty.all(
                                      const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
                                    ),
                                    backgroundColor: WidgetStateProperty.all(widget.primaryColor),
                                  ),
                                  onPressed: onApplyPressed,
                                  child: Center(
                                    child: Text('Apply'.tr, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Cancels the picker: notifies the caller, then closes the dialog.
  void onCancelPressed() {
    try {
      widget.onCancelClick();
      Navigator.pop(context);
    } catch (_) {}
  }

  // Applies the current range: notifies the caller, then closes the dialog.
  void onApplyPressed() {
    if (startDate == null) return;
    
    try {
      final end = endDate ?? startDate!;
      widget.onApplyClick(startDate!, end);
      Navigator.pop(context);
    } catch (_) {}
  }
}

/// Displays a custom date range picker dialog box.\
/// - `context` The context in which to show the dialog.\
/// - `dismissible` A boolean value indicating whether the dialog can be dismissed by tapping outside of it.\
/// - `minimumDate` A DateTime object representing the minimum allowable date that can be selected in the date range picker.\
/// - `maximumDate` A DateTime object representing the maximum allowable date that can be selected in the date range picker.\
/// - `startDate` A nullable DateTime object representing the initial start date of the date range selection.\
/// - `endDate` A nullable DateTime object representing the initial end date of the date range selection.\
/// - `onApplyClick` A function that takes two DateTime parameters representing the selected start and end dates, respectively, and is called when the user taps the "Apply" button.\
/// - `onCancelClick` A function that is called when the user taps the "Cancel" button.\
/// - `backgroundColor` The background color of the dialog.\
/// - `primaryColor` The primary color of the dialog.\
/// - `rangeColor` The color of the range streak between the start and end date. Defaults to `primaryColor` at 40% opacity.\
/// - `fontFamily` The font family to use for the text in the dialog.\

void showCustomDateRangePicker(
  BuildContext context, {
  required bool dismissible,
  required DateTime minimumDate,
  required DateTime maximumDate,
  DateTime? startDate,
  DateTime? endDate,
  required Function(DateTime startDate, DateTime endDate) onApplyClick,
  required Function() onCancelClick,
  required Color backgroundColor,
  required Color primaryColor,
  Color? rangeColor,
  String? fontFamily,
}) {
  /// Request focus to take it away from any input field that might be in focus
  FocusScope.of(context).requestFocus(FocusNode());

  /// Show the CustomDateRangePicker dialog box
  showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) => Directionality(
      textDirection: TextDirection.ltr,
      child: CustomDateRangePicker(
        barrierDismissible: true,
        backgroundColor: backgroundColor,
        primaryColor: primaryColor,
        rangeColor: rangeColor,
        minimumDate: minimumDate,
        maximumDate: maximumDate,
        initialStartDate: startDate,
        initialEndDate: endDate,
        onApplyClick: onApplyClick,
        onCancelClick: onCancelClick,
      ),
    ),
  );
}