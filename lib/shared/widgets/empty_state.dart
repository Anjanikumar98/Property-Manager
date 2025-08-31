import 'package:flutter/material.dart';
import 'package:property_manager/app/theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;
  final String? illustration;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
    this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (illustration != null)
              Image.asset(illustration!, height: 120, width: 120)
            else
              Icon(
                icon ?? Icons.inbox_outlined,
                size: 80,
                color: colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            const SizedBox(height: AppTheme.spacing24),
            Text(
              title,
              style: AppTheme.titleMedium.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppTheme.spacing8),
              Text(
                subtitle!,
                style: AppTheme.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppTheme.spacing24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
