import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class InfoItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isMultiLine;
  final Color? iconColor;
  final Color? containerColor;

  const InfoItemWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.isMultiLine = false,
    this.iconColor,
    this.containerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: containerColor ?? AppColors.darkSecondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon, 
            color: iconColor ?? Colors.white, 
            size: 16
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}