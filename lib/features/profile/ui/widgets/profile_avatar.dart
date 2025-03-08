import 'package:flutter/material.dart';
import '../../../../core/core.dart';

/// مكون صورة المستخدم المحسنة
class ProfileAvatar extends StatelessWidget {
  final String? profileImageUrl;
  final String fullName;
  final double radius;
  final bool isEditing;
  final VoidCallback? onImageTap;

  const ProfileAvatar({
    Key? key,
    this.profileImageUrl,
    required this.fullName,
    this.radius = 60,
    this.isEditing = false,
    this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey[200],
          backgroundImage: profileImageUrl != null
              ? NetworkImage(profileImageUrl!)
              : null,
          child: profileImageUrl == null
              ? Text(
                  _getAvatarText(fullName),
                  style: TextStyle(
                    fontSize: radius * 0.6,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                )
              : null,
        ),
        if (isEditing && onImageTap != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: AppColors.secondary,
                  size: 20,
                ),
                onPressed: onImageTap,
              ),
            ),
          ),
      ],
    );
  }

  String _getAvatarText(String fullName) {
    if (fullName.isEmpty) return '';

    final nameParts = fullName.split(' ');
    if (nameParts.length > 1) {
      return nameParts[0][0] + nameParts[1][0];
    }

    return fullName.substring(0, fullName.length > 2 ? 2 : fullName.length);
  }
}