import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/entities/library_item_entity.dart';
import '../cubits/library/library_state.dart';

class LibraryItemCard extends StatelessWidget {
  final LibraryItemEntity item;
  final LibraryState state;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;
  final bool isResponsive;

  const LibraryItemCard({
    super.key,
    required this.item,
    required this.state,
    this.onTap,
    this.onDownload,
    this.isResponsive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDownloadingThisItem =
        state.isDownloading && state.selectedItem?.id == item.id;

    final cardBorderRadius = isResponsive ? 16.r : 16.0;
    final shadowBlur = isResponsive ? 10.r : 10.0;
    final shadowOffset = isResponsive ? Offset(0, 4.h) : const Offset(0, 4);
    final badgePadding =
        isResponsive
            ? EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h)
            : const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    final badgeBorderRadius = isResponsive ? 8.r : 8.0;
    final badgeFontSize = isResponsive ? 10.sp : 10.0;
    final contentPadding = isResponsive ? 12.r : 12.0;
    final titleFontSize = isResponsive ? 14.sp : 14.0;
    final dateFontSize = isResponsive ? 12.sp : 12.0;
    final priceFontSize = isResponsive ? 14.sp : 14.0;
    final iconButtonSize = isResponsive ? 32.r : 32.0;
    final iconSize = isResponsive ? 18.r : 18.0;
    final progressIndicatorSize = isResponsive ? 16.r : 16.0;
    final spacerHeight = isResponsive ? 4.h : 4.0;
    final thumbnailIcon = isResponsive ? 40.r : 40.0;
    final checkIconSize = isResponsive ? 12.r : 12.0;

    // تعديل ارتفاع البطاقة حسب نوع الجهاز
    final tabletScale = (context.isTablet && isResponsive) ? 1.15 : 1.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: shadowBlur,
            offset: shadowOffset,
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
                                  size: thumbnailIcon * tabletScale,
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
                              size: thumbnailIcon * tabletScale,
                              color: _getColorForType(item.type),
                            ),
                          ),
                        ),

                    // Type badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: badgePadding,
                        decoration: BoxDecoration(
                          color: _getColorForType(item.type).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(
                            badgeBorderRadius,
                          ),
                        ),
                        child: Text(
                          item.typeAsString,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: badgeFontSize,
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
                          padding: EdgeInsets.all(4 * tabletScale),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: checkIconSize * tabletScale,
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
                  padding: EdgeInsets.all(contentPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: titleFontSize * tabletScale,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacerHeight),
                      Text(
                        item.formattedDate,
                        style: TextStyle(
                          fontSize: dateFontSize * tabletScale,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.price.toStringAsFixed(0)} ج.م',
                            style: TextStyle(
                              fontSize: priceFontSize * tabletScale,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          if (item.isDelivered && item.fileUrl != null)
                            GestureDetector(
                              onTap: isDownloadingThisItem ? null : onDownload,
                              child: Container(
                                width: iconButtonSize * tabletScale,
                                height: iconButtonSize * tabletScale,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child:
                                    isDownloadingThisItem
                                        ? SizedBox(
                                          width:
                                              progressIndicatorSize *
                                              tabletScale,
                                          height:
                                              progressIndicatorSize *
                                              tabletScale,
                                          child: CircularProgressIndicator(
                                            value: state.downloadProgress,
                                            strokeWidth: 2,
                                            color: AppColors.primary,
                                          ),
                                        )
                                        : Icon(
                                          Icons.download,
                                          size: iconSize * tabletScale,
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
