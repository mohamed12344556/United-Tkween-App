import 'package:flutter/material.dart';

import '../core.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final bool isOptional;

  const CustomFormField({
    super.key,
    required this.label,
    required this.controller,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.validator,
    this.maxLines = 1,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (isOptional)
              Text(
                ' (اختياري)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[400],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: controller,
          hintText: label,
          style: TextStyle(color: readOnly ? Colors.grey[400] : Colors.white),
          keyboardType: keyboardType,
          isPassword: false,
          validator: validator,
          maxLines: maxLines,
          readOnly: readOnly,
          borderSide: BorderSide.none,
          prefixIcon:
              prefixIcon != null
                  ? Icon(
                    prefixIcon,
                    color: readOnly ? Colors.grey[600] : AppColors.primary,
                    size: 20,
                  )
                  : null,
          filled: true,
          fillColor: AppColors.darkSurface,
          borderRadius: 16.0,
        ),
      ],
    );
  }
}