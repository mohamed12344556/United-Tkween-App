import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../domain/entities/library_item_entity.dart';
import '../cubits/library/library_cubit.dart';
import '../cubits/library/library_state.dart';

/// بطاقة عنصر المكتبة المحسنة
class LibraryItemCard extends StatelessWidget {
  final LibraryItemEntity item;
  final LibraryState state;

  const LibraryItemCard({
    Key? key,
    required this.item,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemHeader(context),
          _buildItemFooter(context),
        ],
      ),
    );
  }

  Widget _buildItemHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة مصغرة
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: item.thumbnailUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          _getIconForType(item.type),
                          size: 40,
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
                : Icon(
                    _getIconForType(item.type),
                    size: 40,
                    color: Colors.grey,
                  ),
          ),

          const SizedBox(width: 16),

          // تفاصيل العنصر
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                if (item.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                _buildInfoRow('تاريخ الطلب:', item.formattedDate),
                const SizedBox(height: 4),
                _buildInfoRow('السعر:', '${item.price.toStringAsFixed(0)} جنيه'),
                const SizedBox(height: 4),
                _buildTypeTag(item.type, item.typeAsString),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeTag(LibraryItemType type, String typeText) {
    return Row(
      children: [
        const Text(
          'النوع:',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: _getColorForType(type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _getColorForType(type).withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Text(
            typeText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _getColorForType(type),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: item.isDelivered
            ? Colors.grey.shade100
            : AppColors.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // عرض نص الحالة
          Row(
            children: [
              Icon(
                item.isDelivered ? Icons.check_circle : Icons.local_shipping,
                size: 16,
                color: item.isDelivered ? AppColors.success : Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                item.deliveryStatus,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: item.isDelivered ? AppColors.success : Colors.orange,
                ),
              ),
            ],
          ),

          // زر التنزيل إذا كان العنصر جاهزًا وله ملف
          if (item.isDelivered && item.fileUrl != null)
            _buildDownloadButton(context),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    // التحقق مما إذا كان هذا العنصر قيد التحميل حاليًا
    final isDownloadingThisItem =
        state.isDownloading && state.selectedItem?.id == item.id;

    return ElevatedButton.icon(
      onPressed: isDownloadingThisItem
          ? null
          : () {
              context.read<LibraryCubit>().downloadItem(item.id);
            },
      icon: isDownloadingThisItem
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator.adaptive(
                value: state.downloadProgress,
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.download, size: 16),
      label: Text(
        isDownloadingThisItem
            ? '${(state.downloadProgress * 100).toInt()}%'
            : 'تحميل',
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  IconData _getIconForType(LibraryItemType type) {
    switch (type) {
      case LibraryItemType.pdf:
        return Icons.picture_as_pdf;
      case LibraryItemType.word:
        return Icons.description;
      case LibraryItemType.video:
        return Icons.video_library;
      case LibraryItemType.audio:
        return Icons.audiotrack;
      case LibraryItemType.image:
        return Icons.image;
      case LibraryItemType.other:
        return Icons.folder;
    }
  }

  Color _getColorForType(LibraryItemType type) {
    switch (type) {
      case LibraryItemType.pdf:
        return Colors.red;
      case LibraryItemType.word:
        return Colors.blue;
      case LibraryItemType.video:
        return Colors.purple;
      case LibraryItemType.audio:
        return Colors.orange;
      case LibraryItemType.image:
        return Colors.green;
      case LibraryItemType.other:
        return Colors.grey;
    }
  }
}