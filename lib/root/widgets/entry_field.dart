import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majestic_rooms/core/extensions/text_formatters.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/core/utils/helper.dart';

class LabeledEntryField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Widget? iconAsSuffix;
  final Widget? prefixIcon;
  final TextStyle? labelStyle;
  final FocusNode? focusNode;
  final String labelText;
  final bool enabled;
  final Color? textColor;
  final bool? filled;
  final Color? filledColor;
  final bool obscure;
  final TextInputAction? textInputAction;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final bool readOnly;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final String? errorText;
  final Widget? suffix;
  final InputDecoration? inputDecoration;
  final TextInputType? keyboardType;
  final void Function(PointerDownEvent)? onTapOutside;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final EdgeInsetsGeometry? contentPadding;
  final void Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final double borderRadius;
  final double fieldHeight;
  final double? gap;

  const LabeledEntryField({
    super.key,
    this.controller,
    this.iconAsSuffix,
    required this.hintText,
    required this.labelText,
    this.obscure = false,
    this.readOnly = false,
    this.errorText,
    this.suffixIconColor,
    this.suffixIcon,
    this.textColor,
    this.borderColor,
    this.focusedBorderColor,
    this.onChanged,
    this.enabled = true,
    this.keyboardType,
    this.suffix,
    this.inputDecoration,
    this.onSubmitted,
    this.focusNode,
    this.onTapOutside,
    this.prefixIcon,
    this.textInputAction,
    this.filled,
    this.filledColor,
    this.labelStyle,
    this.contentPadding,
    this.onEditingComplete,
    this.validator,
    this.borderRadius = 6,
    this.fieldHeight = 40,
    this.gap = 6,
  });

  @override
  Widget build(BuildContext context) {
    final _primaryColor = context.primaryColor;
    final _secondaryColor = context.hintColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style:
              labelStyle ??
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: gap ?? 6),
        // minHeight (not a tight height) so the field keeps its size and grows
        // downward to show validator errors instead of compressing the input.
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: fieldHeight),
          child: TextFormField(
            textInputAction: textInputAction,
            controller: controller,
            cursorColor: _primaryColor,
            textAlignVertical: TextAlignVertical.center,
            obscureText: obscure,
            readOnly: readOnly,
            keyboardType: keyboardType,
            onChanged: onChanged,
            validator: validator,
            onTapOutside: (event) =>
                onTapOutside ?? FocusManager.instance.primaryFocus?.unfocus(),
            onFieldSubmitted: onSubmitted,
            focusNode: focusNode,
            style: TextStyle(fontSize: 14, color: textColor ?? Colors.black),
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              filled: filled,
              fillColor: filledColor,
              counterText: '',
              contentPadding:
                  contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              // labelText: labelText,
              // labelStyle: TextStyle(color: _primaryColor),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(width: 1.5, color: Colors.grey),
              ),
              suffixIcon: suffixIcon == null
                  ? iconAsSuffix
                  : Icon(
                      suffixIcon,
                      color: suffixIconColor ?? _primaryColor,
                      size: 18,
                    ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color: borderColor ?? Colors.grey,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
                gapPadding: 2,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: _primaryColor),
                borderRadius: BorderRadius.circular(borderRadius),
                gapPadding: 2,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: _primaryColor),
                borderRadius: BorderRadius.circular(borderRadius),
                gapPadding: 2,
              ),
              hintText: hintText,
              errorText: errorText,
              suffix: suffix,
              enabled: enabled,
              errorStyle: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              hintStyle: TextStyle(color: _secondaryColor, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class EntryField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Widget? iconAsSuffix;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextStyle? formTextStyle;
  final String? labelText;
  final bool enabled;
  final Color? textColor;
  final bool? filled;
  final bool showSeparateLabel;
  final Color? filledColor;
  final bool obscure;
  final TextInputAction? textInputAction;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final bool readOnly;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final String? errorText;
  final Widget? suffix;
  final InputDecoration? inputDecoration;
  final TextInputType? keyboardType;
  final void Function(PointerDownEvent)? onTapOutside;
  final Function(String)? onChanged;
  final int? maxLines;
  final int? maxLength;
  final Function(String)? onSubmitted;
  final EdgeInsetsGeometry? contentPadding;
  final double? height;
  final bool? isDense;
  final bool? autofocus;
  final void Function()? onTap;
  final void Function()? onEditingComplete;

  const EntryField({
    Key? key,
    this.controller,
    this.iconAsSuffix,
    required this.hintText,
    this.labelText,
    this.obscure = false,
    this.readOnly = false,
    this.errorText,
    this.suffixIconColor,
    this.suffixIcon,
    this.textColor,
    this.borderColor,
    this.focusedBorderColor,
    this.onChanged,
    this.enabled = true,
    this.keyboardType,
    this.suffix,
    this.inputDecoration,
    this.onSubmitted,
    this.focusNode,
    this.onTapOutside,
    this.prefixIcon,
    this.textInputAction,
    this.filled,
    this.filledColor,
    this.maxLines = 1,
    this.maxLength,
    this.showSeparateLabel = false,
    this.contentPadding,
    this.height = 40,
    this.onTap,
    this.formTextStyle,
    this.isDense,
    this.autofocus,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _primaryColor = context.primaryColor;
    final _secondaryColor = context.hintColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (labelText != null && showSeparateLabel)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 2),
            child: Text(
              labelText!,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        SizedBox(
          height: height ?? 40,
          child: TextFormField(
            onEditingComplete: onEditingComplete,
            onTap: onTap,
            autofocus: autofocus ?? false,
            textInputAction: textInputAction,
            controller: controller,
            cursorColor: _primaryColor,
            textAlignVertical: TextAlignVertical.center,
            obscureText: obscure,
            readOnly: readOnly,
            keyboardType: keyboardType,
            onChanged: onChanged,
            maxLines: maxLines,
            maxLength: maxLength,
            onTapOutside: (event) =>
                onTapOutside ?? FocusManager.instance.primaryFocus?.unfocus(),
            onFieldSubmitted: onSubmitted,
            focusNode: focusNode,
            style:
                formTextStyle ??
                TextStyle(fontSize: 14, color: textColor ?? Colors.black),
            decoration:
                inputDecoration ??
                InputDecoration(
                  prefixIcon: prefixIcon,
                  filled: filled,
                  fillColor: filledColor,
                  counterText: '',
                  contentPadding:
                      contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  labelText: !showSeparateLabel ? labelText : null,
                  // labelStyle: TextStyle(color: _primaryColor),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 1.5,
                      color: Colors.grey,
                    ),
                  ),
                  suffixIcon: suffixIcon == null
                      ? iconAsSuffix
                      : Icon(
                          suffixIcon,
                          color: suffixIconColor ?? _primaryColor,
                          size: 18,
                        ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: borderColor ?? Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    gapPadding: 2,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: focusedBorderColor ?? _primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    gapPadding: 2,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: borderColor ?? _primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    gapPadding: 2,
                  ),
                  hintText: hintText,
                  errorText: errorText,
                  suffix: suffix,
                  enabled: enabled,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: TextStyle(color: _secondaryColor, fontSize: 14),
                  isDense: isDense,
                ),
          ),
        ),
      ],
    );
  }
}

class EntryFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Widget? iconAsSuffix;
  final String labelText;
  final bool enabled;
  final Color? textColor;
  final bool obscure;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final bool readOnly;
  final Color? borderColor;
  final String? errorText;
  final Widget? suffix;
  final InputDecoration? inputDecoration;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final int? maxLength;
  final FocusNode? focusNode;

  const EntryFormField({
    Key? key,
    this.controller,
    this.iconAsSuffix,
    required this.hintText,
    required this.labelText,
    this.obscure = false,
    this.readOnly = false,
    this.errorText,
    this.suffixIconColor,
    this.suffixIcon,
    this.textColor,
    this.borderColor,
    this.onChanged,
    this.enabled = true,
    this.keyboardType,
    this.suffix,
    this.inputDecoration,
    this.onSubmitted,
    this.maxLength,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _primaryColor = context.primaryColor;
    final _secondaryColor = context.hintColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            labelText,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 40,
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            cursorColor: _primaryColor,
            textAlignVertical: TextAlignVertical.center,
            obscureText: obscure,
            readOnly: readOnly,
            keyboardType: keyboardType,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            inputFormatters: maxLength != null
                ? [
                    DecimalTextInputFormatter(
                      decimalRange: maxLength!,
                      activatedNegativeValues: false,
                    ),
                  ]
                : null,
            style: TextStyle(fontSize: 14, color: textColor ?? Colors.black),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              // labelText: labelText,
              // labelStyle: TextStyle(color: _primaryColor),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(width: 1.5, color: Colors.grey),
              ),
              suffixIcon: suffixIcon == null
                  ? iconAsSuffix
                  : Icon(
                      suffixIcon,
                      color: suffixIconColor ?? _primaryColor,
                      size: 18,
                    ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color: borderColor ?? Colors.grey,
                ),
                borderRadius: BorderRadius.circular(6),
                gapPadding: 2,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: _primaryColor),
                borderRadius: BorderRadius.circular(6),
                gapPadding: 2,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: _primaryColor),
                borderRadius: BorderRadius.circular(6),
                gapPadding: 2,
              ),
              hintText: hintText,
              errorText: errorText,
              suffix: suffix,
              enabled: enabled,
              errorStyle: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              hintStyle: TextStyle(color: _secondaryColor, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

/// A keyboard-safe, desktop-styled text field.
///
/// Styling matches the original inline [field()] widget from ConfigurationScreen:
///   • borderRadius: 8
///   • contentPadding: symmetric(horizontal: 12, vertical: 14)  — visibly taller than EntryField
///   • Single [OutlineInputBorder] for all states, coloured via [_BorderPainter]
///   • No fixed-height SizedBox wrapper — sizes to content
///
/// On Windows it wraps itself in a [Focus] node that deduplicates modifier-key
/// events the Win32 embedder re-dispatches during syscalls, preventing the
/// HardwareKeyboard "physical key already pressed" assertion that breaks
/// Backspace and Ctrl shortcuts.
///
/// On other platforms the [Focus] wrapper is skipped entirely — zero overhead.
///
/// Drop-in for any form field that needs this style. All props are optional
/// except [hintText].
///
/// ```dart
/// WindowsEntryField(
///   controller: _ipCtrl,
///   focusNode: _ipFocus,
///   nextFocusNode: _portFocus,       // Enter/Tab moves focus here
///   hintText: 'IP Address',
///   labelText: 'IP Address',
///   prefixIcon: Icon(Icons.link_outlined, size: 18, color: _primaryColor),
/// )
/// ```

class WindowsEntryField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// When set and [onSubmitted] is null, Enter / Tab moves focus here.
  final FocusNode? nextFocusNode;

  final String hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon; // accepts any Widget (SvgPicture, Icon, etc.)
  final IconData? suffixIconData; // convenience — used when suffixIcon is null
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscure;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextStyle? textStyle;
  final String? errorText;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final bool filled;
  final EdgeInsetsGeometry? contentPadding;

  // Callbacks
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final void Function(PointerDownEvent)? onTapOutside;
  final TextAlign? textAlign;

  const WindowsEntryField({
    super.key,
    required this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconData,
    this.suffixIconColor,
    this.keyboardType,
    this.inputFormatters,
    this.obscure = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.textStyle,
    this.errorText,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.filled = false,
    this.contentPadding,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.onTapOutside,
    this.textAlign = TextAlign.start,
  });

  @override
  State<WindowsEntryField> createState() => _WindowsEntryFieldState();
}

class _WindowsEntryFieldState extends State<WindowsEntryField> {
  // ── Keyboard deduplicator ──────────────────────────────────────────────────
  // Tracks physically-held keys to swallow the duplicate KeyDownEvents the
  // Windows embedder re-dispatches for modifier keys during Win32 syscalls.
  // Prevents HardwareKeyboard "physical key already pressed" assertion that
  // breaks Backspace / Ctrl+A/C/V/X until the next key-up.
  final Set<PhysicalKeyboardKey> _heldKeys = {};

  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (_heldKeys.contains(event.physicalKey)) return KeyEventResult.handled;
      _heldKeys.add(event.physicalKey);
    } else if (event is KeyUpEvent) {
      _heldKeys.remove(event.physicalKey);
    }
    return KeyEventResult.ignored;
  }

  void _onSubmitted(String val) {
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(val);
    } else if (widget.nextFocusNode != null) {
      FocusScope.of(context).requestFocus(widget.nextFocusNode);
    }
  }

  void _onEditingComplete() {
    if (widget.onSubmitted != null) {
      // Let onSubmitted handle everything — do not unfocus
      return;
    }
    if (widget.nextFocusNode != null) {
      FocusScope.of(context).requestFocus(widget.nextFocusNode);
      return;
    }
    // Nothing configured — default unfocus is fine
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // ── Styling ────────────────────────────────────────────────────────────────
  // Matches the original field() exactly:
  //   radius  : 8   (EntryField uses 6)
  //   padding : symmetric(h:12, v:14)  — much taller than EntryField's only(l:8,t:4,b:4,r:8)
  //   border  : 1.5px, single declaration for all states (enabled / focused / error)

  static const _radius = 8.0;
  static const _padding = EdgeInsets.symmetric(horizontal: 12, vertical: 14);
  static const _borderWidth = 1.5;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(_radius),
    borderSide: BorderSide(width: _borderWidth, color: color),
  );

  @override
  Widget build(BuildContext context) {
    final _primaryColor = context.primaryColor;
    final _secondaryColor = context.hintColor;

    final enabledColor = widget.borderColor ?? Colors.grey;
    final focusedColor = widget.focusedBorderColor ?? _primaryColor;
    final disabledColor = Colors.grey.withOpacity(0.4);
    final errorColor = context.errorColor;

    final resolvedSuffixIcon =
        widget.suffixIcon ??
        (widget.suffixIconData != null
            ? Icon(
                widget.suffixIconData,
                color: widget.suffixIconColor ?? _primaryColor,
                size: 18,
              )
            : null);

    final textField = TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      obscureText: widget.obscure,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textAlign: widget.textAlign ?? TextAlign.start,
      textInputAction:
          widget.textInputAction ??
          (widget.nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done),
      style:
          widget.textStyle ??
          const TextStyle(fontSize: 14, color: Colors.black),
      cursorColor: _primaryColor,
      // Full desktop text interaction — select, copy, cut, paste, undo, right-click menu.
      enableInteractiveSelection: true,
      contextMenuBuilder: (_, state) =>
          AdaptiveTextSelectionToolbar.editableText(editableTextState: state),
      onChanged: widget.onChanged,
      onSubmitted: _onSubmitted,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete ?? _onEditingComplete,
      onTapOutside:
          widget.onTapOutside ??
          (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: resolvedSuffixIcon,
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
        filled: widget.filled,
        fillColor: widget.fillColor,
        counterText: '', // hides maxLength counter
        contentPadding: widget.contentPadding ?? _padding,
        hintStyle: TextStyle(color: _secondaryColor, fontSize: 14),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        // ── Borders — one per state, all using the same radius ──────────────
        border: _border(enabledColor),
        enabledBorder: _border(enabledColor),
        focusedBorder: _border(focusedColor),
        disabledBorder: _border(disabledColor),
        errorBorder: _border(errorColor),
        focusedErrorBorder: _border(errorColor),
      ),
    );

    // On non-Windows platforms skip the Focus wrapper — zero overhead.
    if (!kIsWindows) return textField;

    return Focus(onKeyEvent: _onKey, child: textField);
  }
}
