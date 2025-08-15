import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2E7D32); // Green 800
  static const Color primaryLight = Color(0xFF4CAF50); // Green 500
  static const Color primaryDark = Color(0xFF1B5E20); // Green 900
  static const Color primaryContainer = Color(0xFFA5D6A7); // Light Green 200

  // Secondary Colors
  static const Color secondary = Color(0xFF1976D2); // Blue 700
  static const Color secondaryLight = Color(0xFF2196F3); // Blue 500
  static const Color secondaryDark = Color(0xFF0D47A1); // Blue 900
  static const Color secondaryContainer = Color(0xFFBBDEFB); // Blue 200

  // Accent Colors
  static const Color accent = Color(0xFFF57C00); // Orange 700
  static const Color accentLight = Color(0xFFFF9800); // Orange 500
  static const Color accentDark = Color(0xFFE65100); // Orange 900
  static const Color accentContainer = Color(0xFFFFE0B2); // Orange 200

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Payment Status Colors
  static const Color paid = Color(0xFF4CAF50); // Green
  static const Color pending = Color(0xFFFF9800); // Orange
  static const Color overdue = Color(0xFFF44336); // Red
  static const Color partial = Color(0xFF9C27B0); // Purple

  // Property Status Colors
  static const Color occupied = Color(0xFF4CAF50); // Green
  static const Color vacant = Color(0xFF757575); // Grey
  static const Color maintenance = Color(0xFFFF9800); // Orange

  // Lease Status Colors
  static const Color active = Color(0xFF4CAF50); // Green
  static const Color expired = Color(0xFFF44336); // Red
  static const Color terminated = Color(0xFF757575); // Grey
  static const Color pendingLease = Color(0xFFFF9800); // Orange

  // Priority Colors
  static const Color highPriority = Color(0xFFF44336); // Red
  static const Color mediumPriority = Color(0xFFFF9800); // Orange
  static const Color lowPriority = Color(0xFF4CAF50); // Green

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Grey Shades
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF1C1B1F);

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF2E7D32), // Green
    Color(0xFF1976D2), // Blue
    Color(0xFFF57C00), // Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFFE91E63), // Pink
    Color(0xFF00BCD4), // Cyan
    Color(0xFF8BC34A), // Light Green
    Color(0xFFFF5722), // Deep Orange
    Color(0xFF607D8B), // Blue Grey
    Color(0xFF795548), // Brown
  ];

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors
  static const Color shadowLight = Color(0x1F000000);
  static const Color shadowMedium = Color(0x3F000000);
  static const Color shadowDark = Color(0x5F000000);

  // Overlay Colors
  static const Color overlayLight = Color(0x0A000000);
  static const Color overlayMedium = Color(0x1F000000);
  static const Color overlayDark = Color(0x3F000000);

  // Helper Methods
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return paid;
      case 'pending':
        return pending;
      case 'overdue':
        return overdue;
      case 'partial':
        return partial;
      case 'active':
        return active;
      case 'expired':
        return expired;
      case 'terminated':
        return terminated;
      case 'occupied':
        return occupied;
      case 'vacant':
        return vacant;
      case 'maintenance':
        return maintenance;
      case 'high':
        return highPriority;
      case 'medium':
        return mediumPriority;
      case 'low':
        return lowPriority;
      default:
        return grey500;
    }
  }

  static Color getPropertyTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'apartment':
        return Color(0xFF2196F3);
      case 'house':
        return Color(0xFF4CAF50);
      case 'villa':
        return Color(0xFF9C27B0);
      case 'commercial':
        return Color(0xFFFF9800);
      case 'office space':
        return Color(0xFF607D8B);
      case 'warehouse':
        return Color(0xFF795548);
      case 'shop':
        return Color(0xFFE91E63);
      case 'land':
        return Color(0xFF8BC34A);
      default:
        return grey500;
    }
  }

  static Color getChartColor(int index) {
    return chartColors[index % chartColors.length];
  }
}
