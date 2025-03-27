import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class SupportMessageInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final bool isLoading;
  final VoidCallback onSend;
  final String hintText;
  final String sendButtonText;

  const SupportMessageInput({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.isLoading,
    required this.onSend,
    this.hintText = 'اكتب رسالتك هنا...',
    this.sendButtonText = 'إرسال',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: null,
                expands: true,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: AppColors.darkSurface,
                ),
                onChanged: onChanged,
                cursorColor: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSend,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.secondary,
              disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.secondary,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      sendButtonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
          ),
        ),
      ],
    );
  }
}