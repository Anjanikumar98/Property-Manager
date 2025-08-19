import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final ButtonType type;

  const CustomButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.minimumSize,
    this.borderRadius,
    this.isLoading = false,
    this.type = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(context),
        foregroundColor: _getForegroundColor(context),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: minimumSize ?? const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          side:
              type == ButtonType.outline
                  ? BorderSide(color: Theme.of(context).colorScheme.primary)
                  : BorderSide.none,
        ),
        elevation: type == ButtonType.text ? 0 : 2,
      ),
      child:
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getForegroundColor(context),
                  ),
                ),
              )
              : child,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;

    switch (type) {
      case ButtonType.primary:
        return Theme.of(context).colorScheme.primary;
      case ButtonType.secondary:
        return Theme.of(context).colorScheme.secondary;
      case ButtonType.outline:
        return Colors.transparent;
      case ButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(BuildContext context) {
    if (foregroundColor != null) return foregroundColor!;

    switch (type) {
      case ButtonType.primary:
        return Theme.of(context).colorScheme.onPrimary;
      case ButtonType.secondary:
        return Theme.of(context).colorScheme.onSecondary;
      case ButtonType.outline:
      case ButtonType.text:
        return Theme.of(context).colorScheme.primary;
    }
  }
}

enum ButtonType { primary, secondary, outline, text }
