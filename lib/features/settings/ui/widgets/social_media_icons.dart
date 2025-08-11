import 'package:flutter/material.dart';
import 'package:united_formation_app/features/settings/ui/widgets/my_icons_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:united_formation_app/features/settings/ui/widgets/profile_social_icon.dart';

import '../../../../core/core.dart';
import '../../../../generated/l10n.dart';

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
        color: AppColors.lightGrey,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            S.of(context).followUs,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
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
                backgroundColor: Colors.white,
                color: AppColors.primary,
              ),
              ProfileSocialIcon(
                icon: MyIcons.platform_facebook__color_negative,
                onTap: () {
                  _launchURL('https://www.facebook.com/tkweenunited');
                },
                backgroundColor: Colors.white,
                color: AppColors.primary,
              ),
              ProfileSocialIcon(
                icon: MyIcons.platform_instagram__color_negative,
                onTap: () {
                  _launchURL('https://www.instagram.com/tkween_store');
                },
                backgroundColor: Colors.white,
                color: AppColors.primary,
              ),
              ProfileSocialIcon(
                icon: MyIcons.platform_x__twitter___color_negative,
                onTap: () {
                  _launchURL('https://x.com/tkween_store');
                },
                backgroundColor: Colors.white,
                color: AppColors.primary,
              ),
              ProfileSocialIcon(
                icon: MyIcons.platform_snapchat__color_negative,
                onTap: () {
                  _launchURL(
                    'https://www.snapchat.com/add/tkween_book?share_id=Jvib5Uw3SLGh7GdGIaHYFA&locale=ar_SA@calendar=gregorian&sid=e50dbf147ff94306bfbbc7190c914e39',
                  );
                },
                backgroundColor: Colors.white,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'إصدار التطبيق 1.0.0',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}