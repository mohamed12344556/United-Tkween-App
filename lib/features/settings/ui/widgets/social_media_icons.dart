import 'package:flutter/material.dart';
import 'package:united_formation_app/features/settings/ui/widgets/my_icons_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:united_formation_app/features/settings/ui/widgets/profile_social_icon.dart';

import '../../../../core/core.dart';

class SocialMediaIcons extends StatelessWidget {
  const SocialMediaIcons({super.key});

  // وظيفة لفتح الروابط الخارجية
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('لا يمكن فتح الرابط $url');
    }
  }

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
                icon: MyIcons.platform_tiktok__color_negative,
                onTap: () {
                  _launchURL('https://www.tiktok.com/@tkween.book');
                },
              ),
              ProfileSocialIcon(
                icon: MyIcons.platform_facebook__color_negative,
                onTap: () {
                  _launchURL('https://www.facebook.com/tkweenunited');
                },
              ),
              ProfileSocialIcon(
                icon: MyIcons.platform_instagram__color_negative,
                onTap: () {
                  _launchURL('https://www.instagram.com/tkween_store');
                },
              ),
              ProfileSocialIcon(
                icon: MyIcons.platform_x__twitter___color_negative,
                onTap: () {
                  _launchURL('https://x.com/tkween_store');
                },
              ),
              ProfileSocialIcon(
                icon: MyIcons.platform_snapchat__color_negative,
                onTap: () {
                  _launchURL(
                    'https://www.snapchat.com/add/tkween_book?share_id=Jvib5Uw3SLGh7GdGIaHYFA&locale=ar_SA@calendar=gregorian&sid=e50dbf147ff94306bfbbc7190c914e39',
                  );
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
