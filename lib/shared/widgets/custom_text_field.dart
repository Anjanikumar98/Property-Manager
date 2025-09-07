// lib/shared/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final TextStyle? style;
  final TextStyle? labelStyle;

  const CustomTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.style,
    this.labelStyle,
  }) : assert(
         !(obscureText && maxLines != 1),
         'ObscureText cannot be used with multiple lines.',
       );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      enabled: enabled,
      textCapitalization: textCapitalization,
      focusNode: focusNode,
      style: style,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixText: prefixText,
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


// class CustomTextField extends StatelessWidget {
//   final String? label;
//   final String? hint;
//   final String? errorText;
//   final TextEditingController? controller;
//   final ValueChanged<String>? onChanged;
//   final VoidCallback? onTap;
//   final TextInputType? keyboardType;
//   final bool obscureText;
//   final bool readOnly;
//   final IconData? prefixIcon;
//   final Widget? suffix;
//   final int? maxLines;
//   final String? Function(String?)? validator;
//   final bool isRequired;
//
//   const CustomTextField({
//     super.key,
//     this.label,
//     this.hint,
//     this.errorText,
//     this.controller,
//     this.onChanged,
//     this.onTap,
//     this.keyboardType,
//     this.obscureText = false,
//     this.readOnly = false,
//     this.prefixIcon,
//     this.suffix,
//     this.maxLines = 1,
//     this.validator,
//     this.isRequired = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label != null)
//           Padding(
//             padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
//             child: Text.rich(
//               TextSpan(
//                 text: label!,
//                 style: AppTheme.labelMedium.copyWith(
//                   color: theme.colorScheme.onSurface,
//                 ),
//                 children: [
//                   if (isRequired)
//                     TextSpan(
//                       text: ' *',
//                       style: TextStyle(color: theme.colorScheme.error),
//                     ),
//                 ],
//               ),
//             ),
//           ),

//         TextFormField(
//           controller: controller,
//           onChanged: onChanged,
//           onTap: onTap,
//           keyboardType: keyboardType,
//           obscureText: obscureText,
//           readOnly: readOnly,
//           maxLines: maxLines,
//           validator: validator,
//           decoration: InputDecoration(
//             hintText: hint,
//             prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
//             suffixIcon: suffix,
//             errorText: errorText,
//           ),
//         ),
//       ],
//     );
//   }
// }
