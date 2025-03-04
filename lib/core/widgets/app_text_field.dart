import 'package:flutter/material.dart';
import '../core.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool passwordVisible;
  final VoidCallback? onTogglePasswordVisibility;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool readOnly;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.isPassword = false,
    this.passwordVisible = false,
    this.onTogglePasswordVisibility,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.focusNode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground.withOpacity(0.7) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkSecondary.withOpacity(0.5) : AppColors.lightSecondary,
        ),
        boxShadow: isDark 
          ? [] 
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: isPassword && !passwordVisible,
        validator: validator,
        onChanged: onChanged,
        readOnly: readOnly,
        onTap: onTap,
        style: TextStyle(
          fontSize: context.screenWidth * 0.04,
          color: isDark ? AppColors.darkText : AppColors.text,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[500],
            fontSize: context.screenWidth * 0.04,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.screenWidth * 0.05,
            vertical: context.screenHeight * 0.02,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: isDark 
                      ? AppColors.darkText.withOpacity(0.7) 
                      : AppColors.text.withOpacity(0.7),
                    size: context.screenWidth * 0.055,
                  ),
                  onPressed: onTogglePasswordVisibility,
                )
              : null,
        ),
      ),
    );
  }
}