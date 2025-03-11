import 'package:flutter/material.dart';
import '../core.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool passwordVisible;
  final VoidCallback? onTogglePasswordVisibility;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool? filled; // إضافة خاصية للتحكم في تعبئة الخلفية
  final Color? fillColor; // إضافة خاصية للون الخلفية
  final double? borderRadius; // إضافة خاصية لتخصيص زوايا الحدود
  final AutovalidateMode? autovalidateMode ;

  const AppTextField({
    Key? key,
    this.autovalidateMode,
    this.controller,
    required this.hintText,
     this.labelText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.passwordVisible = false,
    this.onTogglePasswordVisibility,
    this.validator,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.contentPadding,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.filled,
    this.fillColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    
    // حجم النص المتجاوب مع الشاشة
    final fontSize = context.screenWidth * 0.04;
    final hintSize = context.screenWidth * 0.035;
    final iconSize = context.screenWidth * 0.05;
    // تحديد زوايا الحدود
    final radius = borderRadius ?? 12.0;
    
    // ألوان محسنة بناءً على وضع السمة
    final textFieldFillColor = fillColor ?? 
                                (isDark ? AppColors.darkSecondary : Colors.white);
    
    // خلفية مملوءة بشكل افتراضي ما لم يتم تحديد خلاف ذلك
    final shouldFill = filled ?? true;
    
    // حساب المسافات الداخلية بشكل متجاوب
    final defaultPadding = contentPadding ?? 
                       EdgeInsets.symmetric(
                         horizontal: context.screenWidth * 0.04,
                         vertical: context.screenHeight * 0.018
                       );

    return TextFormField(
      autovalidateMode: autovalidateMode,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && !passwordVisible,
      validator: validator,
      focusNode: focusNode,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: isPassword ? 1 : maxLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(
        fontSize: fontSize,
        color: isDark ? Colors.white : Colors.black87,
        fontWeight: FontWeight.normal,
      ),
      cursorColor: AppColors.primary,
      cursorWidth: 1.5,
      cursorRadius: const Radius.circular(2),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[500],
          fontSize: hintSize,
        ),
        filled: shouldFill,
        fillColor: textFieldFillColor,
        contentPadding: defaultPadding,
        prefixIcon: prefixIcon,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  passwordVisible ? Icons.visibility_off : Icons.visibility,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  size: iconSize,
                ),
                splashRadius: iconSize * 0.9,
                onPressed: onTogglePasswordVisibility,
              )
            : suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: isDark ? Colors.transparent : Colors.grey[300]!,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: isDark ? Colors.transparent : Colors.grey[300]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
        errorStyle: TextStyle(
          color: AppColors.error,
          fontSize: fontSize * 0.75, // حجم نص الخطأ متناسب مع حجم النص الرئيسي
        ),
        counterText: "",
        // تحسين أيقونات الحقل
        prefixIconColor: isDark ? Colors.grey[400] : Colors.grey[600],
        suffixIconColor: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
    );
  }
}