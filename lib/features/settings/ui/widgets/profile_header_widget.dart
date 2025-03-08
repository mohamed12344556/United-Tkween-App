import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../widgets/profile_avatar.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String? profileImageUrl;
  final String fullName;
  final String email;

  const ProfileHeaderWidget({
    Key? key,
    this.profileImageUrl,
    required this.fullName,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 32),
      decoration: const BoxDecoration(color: AppColors.darkBackground),
      child: Column(
        children: [
          ProfileAvatar(
            profileImageUrl: profileImageUrl,
            fullName: fullName,
            radius: 60,
            backgroundColor: AppColors.darkSecondary,
            textColor: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            email,
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}