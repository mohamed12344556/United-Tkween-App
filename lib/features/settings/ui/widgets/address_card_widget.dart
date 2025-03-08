import 'package:flutter/material.dart';
import 'package:united_formation_app/core/widgets/app_card.dart';
import '../../../../core/core.dart';
import 'info_item_widget.dart';

class AddressCardWidget extends StatelessWidget {
  final String? address;
  
  const AddressCardWidget({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.darkSurface,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان البطاقة
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'العنوان',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          InfoItemWidget(
            icon: Icons.home,
            title: 'تفاصيل العنوان',
            value: address ?? 'غير محدد',
            isMultiLine: true,
          ),
        ],
      ),
    );
  }
}