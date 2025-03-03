import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final IconData? icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool? isPasswordVisible;
  final VoidCallback? onTogglePasswordVisibility;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onFieldSubmitted;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.label,
    this.icon,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.isPasswordVisible,
    this.onTogglePasswordVisibility,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !(isPasswordVisible ?? false),
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        readOnly: readOnly,
        onTap: onTap,
        onFieldSubmitted: (value) {
          FocusScope.of(context).unfocus(); // Retain this behavior
          if (onFieldSubmitted != null) {
            onFieldSubmitted!(value); // Invoke parent's callback
          }
        },
        inputFormatters: isPassword
            ? [
                FilteringTextInputFormatter.allow(RegExp(
                    r'[a-zA-Z0-9!@#$%^&*]')), // Only allow specific characters
              ]
            : null,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).iconTheme.color,
            size: 22,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ?? false
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Theme.of(context).iconTheme.color,
                    size: 22,
                  ),
                  onPressed: onTogglePasswordVisibility,
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
