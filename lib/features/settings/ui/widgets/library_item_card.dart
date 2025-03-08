import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/entities/library_item_entity.dart';
import '../cubits/library/library_state.dart';

class LibraryItemCard extends StatelessWidget {
  final LibraryItemEntity item;
  final LibraryState state;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;

  const LibraryItemCard({
    Key? key,
    required this.item,
    required this.state,
    this.onTap,
    this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // التحقق مما إذا كان هذا العنصر قيد التحميل حاليًا
    final isDownloadingThisItem =
        state.isDownloading && state.selectedItem?.id == item.id;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thumbnail
              Expanded(
                flex: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Item thumbnail
                    item.thumbnailUrl != null
                        ? Image.network(
                            item.thumbnailUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.darkSecondary,
                                child: Center(
                                  child: Icon(
                                    _getIconForType(item.type),
                                    size: 40,
                                    color: _getColorForType(item.type),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: AppColors.darkSecondary,
                            child: Center(
                              child: Icon(
                                _getIconForType(item.type),
                                size: 40,
                                color: _getColorForType(item.type),
                              ),
                            ),
                          ),
                    
                    // Type badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getColorForType(item.type).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.typeAsString,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    // Delivery status indicator
                    if (item.isDelivered)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Item details
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.price.toStringAsFixed(0)} ج.م',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          if (item.isDelivered && item.fileUrl != null)
                            GestureDetector(
                              onTap: isDownloadingThisItem ? null : onDownload,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: isDownloadingThisItem
                                    ? SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          value: state.downloadProgress,
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      )
                                    : Icon(
                                        Icons.download,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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