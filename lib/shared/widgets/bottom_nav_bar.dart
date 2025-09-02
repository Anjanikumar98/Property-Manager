import 'package:flutter/material.dart';
import 'package:property_manager/app/theme/app_theme.dart';
import 'package:property_manager/app/theme/color_schemes.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final StatusType status;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    required this.status,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;

    switch (status) {
      case StatusType.success:
        backgroundColor = colorScheme.success.withOpacity(0.1);
        textColor = colorScheme.success;
        break;
      case StatusType.warning:
        backgroundColor = colorScheme.warning.withOpacity(0.1);
        textColor = colorScheme.warning;
        break;
      case StatusType.error:
        backgroundColor = colorScheme.error.withOpacity(0.1);
        textColor = colorScheme.error;
        break;
      case StatusType.info:
        backgroundColor = colorScheme.info.withOpacity(0.1);
        textColor = colorScheme.info;
        break;
      case StatusType.neutral:
        backgroundColor = colorScheme.surfaceContainerHighest;
        textColor = colorScheme.onSurfaceVariant;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing12,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: AppTheme.spacing4),
          ],
          Text(
            text,
            style: AppTheme.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum StatusType { success, warning, error, info, neutral }
