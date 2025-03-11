import 'package:flutter/material.dart';
import 'package:united_formation_app/features/settings/ui/widgets/profile_social_icon.dart';

import '../../../../core/core.dart';

class SocialMediaIcons extends StatelessWidget {
  const SocialMediaIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Text(
            'تابعنا على وسائل التواصل',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileSocialIcon(
                icon: Icons.whatshot_outlined,
                onTap: () {
                  // TODO: تنفيذ الإجراء الخاص بمنصة التواصل الاجتماعي
                },
              ),
              ProfileSocialIcon(
                icon: Icons.facebook,
                onTap: () {
                  // TODO: تنفيذ الإجراء الخاص بفيسبوك
                },
              ),
              ProfileSocialIcon(
                icon: Icons.photo_camera,
                onTap: () {
                  // TODO: تنفيذ الإجراء الخاص بإنستجرام
                },
              ),
              ProfileSocialIcon(
                icon: Icons.chat_bubble,
                onTap: () {
                  // TODO: تنفيذ الإجراء الخاص بتويتر
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'إصدار التطبيق 1.0.0',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}