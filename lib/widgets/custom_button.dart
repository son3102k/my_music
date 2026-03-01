import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, ghost, icon }
enum ButtonSize { sm, md, lg }

class CustomButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final ButtonVariant variant;
  final ButtonSize size;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    this.label,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  double get _iconSize {
    switch (widget.size) {
      case ButtonSize.sm:
        return 16;
      case ButtonSize.md:
        return 20;
      case ButtonSize.lg:
        return 24;
    }
  }

  double get _padding {
    switch (widget.size) {
      case ButtonSize.sm:
        return 8;
      case ButtonSize.md:
        return 12;
      case ButtonSize.lg:
        return 16;
    }
  }

  double get _containerSize {
    switch (widget.size) {
      case ButtonSize.sm:
        return 32;
      case ButtonSize.md:
        return 40;
      case ButtonSize.lg:
        return 48;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (widget.variant == ButtonVariant.icon) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: _isHovered ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: _containerSize,
              height: _containerSize,
              alignment: Alignment.center,
              child: Icon(widget.icon, size: _iconSize, color: colors.onSurface),
            ),
          ),
        ),
      );
    }

    Color bgColor;
    Color textColor;
    Color borderColor;

    switch (widget.variant) {
      case ButtonVariant.primary:
        bgColor = colors.primary;
        textColor = colors.onPrimary;
        borderColor = colors.primary;
        break;
      case ButtonVariant.secondary:
        bgColor = colors.secondary;
        textColor = colors.onSurface;
        borderColor = colors.secondary;
        break;
      case ButtonVariant.ghost:
        bgColor = Colors.transparent;
        textColor = theme.textTheme.bodyMedium?.color ?? colors.onSurface;
        borderColor = Colors.transparent;
        break;
      case ButtonVariant.icon:
        bgColor = Colors.transparent;
        textColor = colors.onSurface;
        borderColor = Colors.transparent;
        break;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: widget.label != null ? _padding * 2 : _padding,
            vertical: _padding,
          ),
          decoration: BoxDecoration(
            color: _isHovered && widget.variant != ButtonVariant.ghost
                ? bgColor.withOpacity(0.9)
                : bgColor,
            border: Border.all(
              color: widget.variant == ButtonVariant.ghost && _isHovered
                  ? colors.secondary
                  : borderColor,
            ),
            borderRadius: BorderRadius.circular(
              widget.variant == ButtonVariant.primary ? 9999 : 4,
            ),
            boxShadow: _isHovered && widget.variant == ButtonVariant.primary
                ? [
                    BoxShadow(
                      color: colors.primary.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: _iconSize, color: textColor),
                if (widget.label != null) const SizedBox(width: 8),
              ],
              if (widget.label != null)
                Text(
                  widget.label!,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
