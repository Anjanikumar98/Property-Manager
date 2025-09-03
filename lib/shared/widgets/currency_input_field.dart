import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final String currencySymbol;
  final int decimalPlaces;
  final Widget? prefixIcon;

  const CurrencyInputField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.currencySymbol = '\$',
    this.decimalPlaces = 2,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        _CurrencyInputFormatter(decimalPlaces: decimalPlaces),
      ],
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        prefixText: currencySymbol,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        filled: true,
        fillColor:
            enabled
                ? Theme.of(context).colorScheme.surface
                : Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  _CurrencyInputFormatter({required this.decimalPlaces});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty string
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove any non-digit and non-decimal point characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Handle multiple decimal points
    List<String> parts = newText.split('.');
    if (parts.length > 2) {
      newText = '${parts[0]}.${parts.sublist(1).join('')}';
    }

    // Limit decimal places
    if (parts.length == 2 && parts[1].length > decimalPlaces) {
      newText = '${parts[0]}.${parts[1].substring(0, decimalPlaces)}';
    }

    // Prevent starting with decimal point
    if (newText.startsWith('.')) {
      newText = '0$newText';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
