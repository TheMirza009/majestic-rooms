import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/core/utils/helper.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final bool toUpperCaseText;
  final Color? btnColor;
  final Color? hoverColor;
  final Color? disabledColor;
  final double? width;
  final double borderRadius;
  final TextAlign? textAlign;
  final VoidCallback? onTap;
  final bool enabled;
  final Widget? icon;
  final Widget? trailingIcon;
  final double? iconGap;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.btnColor,
    this.hoverColor,
    this.disabledColor,
    this.width,
    this.textStyle,
    this.padding,
    this.toUpperCaseText = true,
    this.decoration,
    this.borderRadius = 24,
    this.textAlign,
    this.enabled = true,
    this.icon,
    this.trailingIcon,
    this.iconGap = 8.0,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = !widget.enabled;
    final effectiveColor = isDisabled
        ? (widget.disabledColor ?? Colors.grey[400])
        : (_isHovered ? widget.hoverColor : widget.btnColor);

    final label = Text(
      widget.toUpperCaseText ? widget.text.toUpperCase() : widget.text,
      textAlign: widget.textAlign ?? TextAlign.center,
      style:
          widget.textStyle?.copyWith(
            color: isDisabled ? Colors.grey[600] : widget.textStyle?.color,
          ) ??
          TextStyle(
            color: isDisabled ? Colors.grey[600] : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
    );

    final content = (widget.icon == null && widget.trailingIcon == null)
        ? label
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                SizedBox(width: widget.iconGap),
              ],
              label,
              if (widget.trailingIcon != null) ...[
                SizedBox(width: widget.iconGap),
                widget.trailingIcon!,
              ],
            ],
          );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isDisabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: context.dimens.durationFast,
          padding: widget.padding ?? context.dimens.paddingMedium,
          width: widget.width ?? double.infinity,
          decoration:
              widget.decoration ??
              BoxDecoration(
                color:
                    effectiveColor ??
                    (isDisabled ? Colors.grey[400] : context.primaryColor),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
          child: content,
        ),
      ),
    );
  }
}

class CustomButtonOutlined extends StatelessWidget {
  final String text;
  final Color color;
  final Color? borderColor;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final double borderRadius;

  const CustomButtonOutlined({
    super.key,
    required this.text,
    this.onTap,
    this.prefix,
    this.suffix,
    this.color = Colors.transparent,
    this.borderColor,
    this.textStyle,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return (kIsWeb || kIsWindows)
        ? MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(color: borderColor ?? context.borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    prefix ?? const SizedBox.shrink(),
                    const SizedBox(width: 10),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style:
                          textStyle ??
                          const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 10),
                    suffix ?? const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: borderColor ?? context.borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prefix ?? const SizedBox.shrink(),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style:
                        textStyle ??
                        const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 10),
                  suffix ?? const SizedBox.shrink(),
                ],
              ),
            ),
          );
  }
}
