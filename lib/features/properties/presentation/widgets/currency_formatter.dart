import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    symbol: '₹', // Indian Rupee symbol
    locale: 'en_IN',
    decimalDigits: 0, // No decimal places for whole amounts
  );

  static final NumberFormat _formatterWithDecimals = NumberFormat.currency(
    symbol: '₹',
    locale: 'en_IN',
    decimalDigits: 2,
  );

  /// Formats a number as currency (₹1,00,000)
  static String format(dynamic amount) {
    if (amount == null) return '₹0';

    final double value =
        amount is String
            ? double.tryParse(amount) ?? 0.0
            : (amount as num).toDouble();

    return _formatter.format(value);
  }

  /// Formats a number as currency with decimals (₹1,00,000.50)
  static String formatWithDecimals(dynamic amount) {
    if (amount == null) return '₹0.00';

    final double value =
        amount is String
            ? double.tryParse(amount) ?? 0.0
            : (amount as num).toDouble();

    return _formatterWithDecimals.format(value);
  }

  /// Formats compact currency (₹1L for 1,00,000)
  static String formatCompact(dynamic amount) {
    if (amount == null) return '₹0';

    final double value =
        amount is String
            ? double.tryParse(amount) ?? 0.0
            : (amount as num).toDouble();

    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
    } else if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(1)}L';
    } else if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹${value.toStringAsFixed(0)}';
    }
  }

  /// Parses a currency string to double
  static double parse(String currencyString) {
    // Remove currency symbol and commas
    final cleanString = currencyString.replaceAll(RegExp(r'[₹,\s]'), '');
    return double.tryParse(cleanString) ?? 0.0;
  }

  /// Validates if a string is a valid currency amount
  static bool isValid(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[₹,\s]'), '');
    final parsedValue = double.tryParse(cleanValue);
    return parsedValue != null && parsedValue >= 0;
  }
}
