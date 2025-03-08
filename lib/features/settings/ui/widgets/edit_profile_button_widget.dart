import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class EditProfileButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  
  const EditProfileButtonWidget({
    super.key,
    required this.onPressed,
    this.buttonText = 'تعديل الملف الشخصي',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.edit),
          label: Text(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}