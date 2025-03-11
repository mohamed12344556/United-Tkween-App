import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class ProfileAvatar extends StatelessWidget {
  final String? profileImageUrl;
  final String fullName;
  final double radius;
  final bool isEditing;
  final VoidCallback? onImageTap;
  final Color? backgroundColor;
  final Color? textColor;
  final File? imageFile;

  const ProfileAvatar({
    super.key,
    this.profileImageUrl,
    required this.fullName,
    this.radius = 60,
    this.isEditing = false,
    this.onImageTap,
    this.backgroundColor,
    this.textColor,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    final finalBackgroundColor = backgroundColor ?? Colors.grey[200];
    final finalTextColor = textColor ?? Colors.grey[800];

    return Stack(
      children: [
        // Avatar without border
        CircleAvatar(
          radius: radius,
          backgroundColor: finalBackgroundColor,
          backgroundImage: _getBackgroundImage(),
          child:
              _showInitials()
                  ? Text(
                    _getAvatarText(fullName),
                    style: TextStyle(
                      fontSize: radius * 0.5,
                      fontWeight: FontWeight.bold,
                      color: finalTextColor,
                    ),
                  )
                  : null,
        ),

        // Edit button overlay if in editing mode
        if (isEditing && onImageTap != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: onImageTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.darkBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
      ],
    );
  }

  ImageProvider? _getBackgroundImage() {
    if (imageFile != null) {
      return FileImage(imageFile!);
    }
    else if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      return NetworkImage(profileImageUrl!);
    }

    return null;
  }

  bool _showInitials() {
    return imageFile == null &&
        (profileImageUrl == null || profileImageUrl!.isEmpty);
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
