import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({
    required int? decimalRange,
    required bool activatedNegativeValues,
  }) : assert(
         decimalRange == null || decimalRange >= 0,
         'DecimalTextInputFormatter declaretion error',
       ) {
    String dp = (decimalRange != null && decimalRange > 0)
        ? "([.][0-9]{0,$decimalRange}){0,1}"
        : "";
    String num = "[0-9]*$dp";

    if (activatedNegativeValues) {
      _exp = RegExp("^((((-){0,1})|((-){0,1}[0-9]$num))){0,1}\$");
    } else {
      _exp = RegExp("^($num){0,1}\$");
    }
  }

  late RegExp _exp;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}
