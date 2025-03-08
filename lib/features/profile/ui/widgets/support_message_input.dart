import 'package:flutter/material.dart';
import '../../../../core/core.dart';

/// مكون إدخال رسالة الدعم المحسن
class SupportMessageInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final bool isLoading;
  final VoidCallback onSend;

  const SupportMessageInput({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.isLoading,
    required this.onSend,
  }) : super(key: key);

  @override
/*************  ✨ Codeium Command ⭐  *************/
/// Builds a widget tree to display a profile avatar with optional editing
/// capabilities.
/// 
/// The widget displays a circular avatar using the `CircleAvatar` widget. If
/// `profileImageUrl` is provided, it displays the image from the network;
/// otherwise, it shows the initials derived from the `fullName`. 
///
/// If `isEditing` is `true` and `onImageTap` is provided, an editable icon 

/******  cfef2bb1-b9e2-4554-b900-8281ab096581  *******/  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: 10,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              decoration: const InputDecoration.collapsed(
                hintText: 'اكتب رسالتك هنا...',
                hintTextDirection: TextDirection.rtl,
              ),
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.text,
                height: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading ? null : onSend,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'إرسال',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ],
    );
  }
}