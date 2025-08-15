import '../constants/app_constants.dart';
import 'package:flutter/material.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredField;
    }

    if (!RegExp(AppConstants.emailPattern).hasMatch(value)) {
      return AppConstants.invalidEmail;
    }

    return null;
  }

  // Phone validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredField;
    }

    if (!RegExp(AppConstants.phonePattern).hasMatch(value)) {
      return AppConstants.invalidPhone;
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredField;
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!RegExp(AppConstants.passwordPattern).hasMatch(value)) {
      return AppConstants.weakPassword;
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredField;
    }

    if (value != password) {
      return AppConstants.passwordMismatch;
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : AppConstants.requiredField;
    }
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredField;
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }

    if (value.trim().length > 50) {
      return 'Name cannot exceed 50 characters';
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value.trim())) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  // Amount validation
  static String? validateAmount(
    String? value, {
    double? minAmount,
    double? maxAmount,
  }) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredField;
    }

    final double? amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount < 0) {
      return 'Amount cannot be negative';
    }

    if (minAmount != null && amount < minAmount) {
      return 'Amount must be at least ${AppConstants.currencySymbol}$minAmount';
    }

    if (maxAmount != null && amount > maxAmount) {
      return 'Amount cannot exceed ${AppConstants.currencySymbol}$maxAmount';
    }

    return null;
  }

  // Rent amount validation
  static String? validateRentAmount(String? value) {
    return validateAmount(value, minAmount: 1000, maxAmount: 1000000);
  }

  // Security deposit validation
  static String? validateSecurityDeposit(String? value, {double? rentAmount}) {
    if (value == null || value.isEmpty) {
      return null; // Security deposit is optional
    }

    final double? deposit = double.tryParse(value);
    if (deposit == null) {
      return 'Please enter a valid amount';
    }

    if (deposit < 0) {
      return 'Amount cannot be negative';
    }

    if (rentAmount != null && deposit > (rentAmount * 12)) {
      return 'Security deposit cannot exceed 12 months rent';
    }

    return null;
  }

  // Area validation
  static String? validateArea(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredField;
    }

    final double? area = double.tryParse(value);
    if (area == null) {
      return 'Please enter a valid area';
    }

    if (area <= 0) {
      return 'Area must be greater than 0';
    }

    if (area > 100000) {
      return 'Area cannot exceed 100,000 sq ft';
    }

    return null;
  }

  // Pin code validation
  static String? validatePinCode(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredField;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Please enter a valid 6-digit pin code';
    }

    return null;
  }

  // Number validation
  static String? validateNumber(
    String? value, {
    int? min,
    int? max,
    bool required = true,
  }) {
    if (value == null || value.isEmpty) {
      return required ? AppConstants.requiredField : null;
    }

    final int? number = int.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (min != null && number < min) {
      return 'Value must be at least $min';
    }

    if (max != null && number > max) {
      return 'Value cannot exceed $max';
    }

    return null;
  }

  // Bedrooms validation
  static String? validateBedrooms(String? value) {
    return validateNumber(value, min: 0, max: 20);
  }

  // Bathrooms validation
  static String? validateBathrooms(String? value) {
    return validateNumber(value, min: 0, max: 20);
  }

  // Date validation
  static String? validateDate(
    DateTime? date, {
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    if (date == null) {
      return AppConstants.requiredField;
    }

    if (minDate != null && date.isBefore(minDate)) {
      return 'Date cannot be before ${_formatDate(minDate)}';
    }

    if (maxDate != null && date.isAfter(maxDate)) {
      return 'Date cannot be after ${_formatDate(maxDate)}';
    }

    return null;
  }

  // Date range validation
  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return AppConstants.requiredField;
    }

    if (startDate.isAfter(endDate)) {
      return 'Start date cannot be after end date';
    }

    if (startDate.isBefore(
      DateTime.now().subtract(const Duration(days: 365)),
    )) {
      return 'Start date cannot be more than a year in the past';
    }

    if (endDate.isAfter(DateTime.now().add(const Duration(days: 365 * 10)))) {
      return 'End date cannot be more than 10 years in the future';
    }

    return null;
  }

  // Age validation
  static String? validateAge(DateTime? birthDate) {
    if (birthDate == null) {
      return AppConstants.requiredField;
    }

    final now = DateTime.now();
    final age = now.year - birthDate.year;

    if (birthDate.isAfter(now)) {
      return 'Birth date cannot be in the future';
    }

    if (age < 18) {
      return 'Age must be at least 18 years';
    }

    if (age > 120) {
      return 'Please enter a valid birth date';
    }

    return null;
  }

  // URL validation
  static String? validateUrl(String? value, {bool required = false}) {
    if (value == null || value.isEmpty) {
      return required ? AppConstants.requiredField : null;
    }

    if (!RegExp(
      r'^https?:\/\/[\w\-]+(\.[\w\-]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$',
    ).hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // Address validation
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredField;
    }

    if (value.trim().length < 10) {
      return 'Address must be at least 10 characters long';
    }

    if (value.trim().length > 200) {
      return 'Address cannot exceed 200 characters';
    }

    return null;
  }

  // Description validation
  static String? validateDescription(
    String? value, {
    bool required = false,
    int? maxLength,
  }) {
    if (value == null || value.trim().isEmpty) {
      return required ? AppConstants.requiredField : null;
    }

    final length = maxLength ?? 500;
    if (value.trim().length > length) {
      return 'Description cannot exceed $length characters';
    }

    return null;
  }

  // Helper method to format date
  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
