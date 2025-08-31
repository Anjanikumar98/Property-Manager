import 'package:flutter/material.dart';
import 'package:property_manager/app/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = _buildButton(context);

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return AnimatedContainer(duration: AppTheme.fastAnimation, child: button);
  }

  Widget _buildButton(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return _buildLoadingButton(theme);
    }

    switch (type) {
      case ButtonType.primary:
        return _buildElevatedButton();
      case ButtonType.secondary:
        return _buildOutlinedButton();
      case ButtonType.text:
        return _buildTextButton();
    }
  }

  Widget _buildElevatedButton() {
    return ElevatedButton(onPressed: onPressed, child: _buildButtonContent());
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(onPressed: onPressed, child: _buildButtonContent());
  }

  Widget _buildTextButton() {
    return TextButton(onPressed: onPressed, child: _buildButtonContent());
  }

  Widget _buildLoadingButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: null,
      child: SizedBox(
        height: _getButtonHeight(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: AppTheme.spacing8),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: AppTheme.spacing8),
          Text(text),
        ],
      );
    }
    return Text(text);
  }

  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return 32.0;
      case ButtonSize.medium:
        return 40.0;
      case ButtonSize.large:
        return 48.0;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.medium:
        return 18.0;
      case ButtonSize.large:
        return 20.0;
    }
  }
}

enum ButtonType { primary, secondary, text }

enum ButtonSize { small, medium, large }
