import 'package:flutter/material.dart';

// Light Theme Colors
const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF2563EB), // Blue 600
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFDBEAFE), // Blue 100
  onPrimaryContainer: Color(0xFF1E3A8A), // Blue 900

  secondary: Color(0xFF059669), // Emerald 600
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD1FAE5), // Emerald 100
  onSecondaryContainer: Color(0xFF064E3B), // Emerald 900

  tertiary: Color(0xFF7C3AED), // Violet 600
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFEDE9FE), // Violet 100
  onTertiaryContainer: Color(0xFF4C1D95), // Violet 900

  error: Color(0xFFDC2626), // Red 600
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFEE2E2), // Red 100
  onErrorContainer: Color(0xFF991B1B), // Gray 900

  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF111827), // Gray 900
  surfaceContainerHighest: Color(0xFFF3F4F6), // Gray 100
  onSurfaceVariant: Color(0xFF6B7280), // Gray 500

  outline: Color(0xFFD1D5DB), // Gray 300
  outlineVariant: Color(0xFFE5E7EB), // Gray 200
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),

  inverseSurface: Color(0xFF111827), // Gray 900
  onInverseSurface: Color(0xFFF9FAFB), // Gray 50
  inversePrimary: Color(0xFF93C5FD), // Blue 300
);

// Dark Theme Colors
const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF3B82F6), // Blue 500
  onPrimary: Color(0xFF1E3A8A), // Blue 900
  primaryContainer: Color(0xFF1E40AF), // Blue 700
  onPrimaryContainer: Color(0xFFDBEAFE), // Blue 100

  secondary: Color(0xFF10B981), // Emerald 500
  onSecondary: Color(0xFF064E3B), // Emerald 900
  secondaryContainer: Color(0xFF047857), // Emerald 700
  onSecondaryContainer: Color(0xFFD1FAE5), // Emerald 100

  tertiary: Color(0xFF8B5CF6), // Violet 500
  onTertiary: Color(0xFF4C1D95), // Violet 900
  tertiaryContainer: Color(0xFF6D28D9), // Violet 700
  onTertiaryContainer: Color(0xFFEDE9FE), // Violet 100

  error: Color(0xFFEF4444), // Red 500
  onError: Color(0xFF991B1B), // Red 800
  errorContainer: Color(0xFFDC2626), // Red 600
  onErrorContainer: Color(0xFFFEE2E2), // Slate 100

  surface: Color(0xFF1E293B), // Slate 800
  onSurface: Color(0xFFF1F5F9), // Slate 100
  surfaceContainerHighest: Color(0xFF334155), // Slate 700
  onSurfaceVariant: Color(0xFF94A3B8), // Slate 400

  outline: Color(0xFF475569), // Slate 600
  outlineVariant: Color(0xFF64748B), // Slate 500
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),

  inverseSurface: Color(0xFFF1F5F9), // Slate 100
  onInverseSurface: Color(0xFF1E293B), // Slate 800
  inversePrimary: Color(0xFF1D4ED8), // Blue 700
);

// Custom color extensions
extension CustomColors on ColorScheme {
  Color get success =>
      brightness == Brightness.light
          ? const Color(0xFF059669) // Emerald 600
          : const Color(0xFF10B981); // Emerald 500

  Color get warning =>
      brightness == Brightness.light
          ? const Color(0xFFD97706) // Amber 600
          : const Color(0xFFF59E0B); // Amber 500

  Color get info =>
      brightness == Brightness.light
          ? const Color(0xFF0EA5E9) // Sky 500
          : const Color(0xFF38BDF8); // Sky 400

  Color get onSuccess => Colors.white;
  Color get onWarning => Colors.white;
  Color get onInfo => Colors.white;

  // Status colors for rent payments
  Color get paid => success;
  Color get pending => warning;
  Color get overdue => error;
  Color get partial => info;

  // Property status colors
  Color get occupied => success;
  Color get vacant => warning;
  Color get maintenance => error;
  Color get unavailable => outline;

  // Semantic colors for cards and backgrounds
  Color get cardBackground => surface;
  Color get cardShadow => shadow.withOpacity(0.1);
  Color get divider => outline.withOpacity(0.2);
  Color get disabled => onSurface.withOpacity(0.38);
  Color get disabledContainer => onSurface.withOpacity(0.12);

  // Gradient colors
  List<Color> get primaryGradient => [primary, primary.withOpacity(0.8)];

  List<Color> get secondaryGradient => [secondary, secondary.withOpacity(0.8)];

  List<Color> get backgroundGradient =>
      brightness == Brightness.light
          ? [const Color(0xFFFAFAFA), const Color(0xFFFFFFFF)]
          : [const Color(0xFF0F172A), const Color(0xFF1E293B)];
}
