import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/profile/domain/entities/library_item_entity.dart';
import '../../../../core/core.dart';
import '../cubits/library/library_cubit.dart';
import '../cubits/library/library_state.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    // تحميل عناصر المكتبة عند فتح الصفحة
    context.read<LibraryCubit>().loadLibraryItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.isDarkMode ? AppColors.darkBackground : Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.secondary),
        title: const Text(
          'مكتبتي',
          style: TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? 'خطأ في تحميل المكتبة',
                    style: TextStyle(
                      color: context.isDarkMode ? Colors.white : AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<LibraryCubit>().loadLibraryItems(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (!state.hasItems) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 70,
                    color:
                        context.isDarkMode ? Colors.white60 : Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'مكتبتك فارغة حالياً',
                    style: TextStyle(
                      fontSize: 18,
                      color: context.isDarkMode ? Colors.white : AppColors.text,
                    ),
                  ),
                ],
              ),
            );
          }

          return Container(
            color: AppColors.primary,
            child: Column(
              children: [
                // Library Items in white container
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return _buildLibraryItem(context, item, state);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLibraryItem(
    BuildContext context,
    LibraryItemEntity item,
    LibraryState state,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book thumbnail
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                  ),
                  child:
                      item.thumbnailUrl != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.thumbnailUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                          : Icon(
                            _getIconForType(item.type),
                            size: 40,
                            color: Colors.grey,
                          ),
                ),

                const SizedBox(width: 16),

                // Library item details
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
                      Row(
                        children: [
                          const Text(
                            'تاريخ الطلب:',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.formattedDate,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'السعر:',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.price.toStringAsFixed(0)} جنيه',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
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
                              color: _getColorForType(
                                item.type,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _getColorForType(
                                  item.type,
                                ).withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              item.typeAsString,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _getColorForType(item.type),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Delivery status or Download button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color:
                  item.isDelivered
                      ? Colors.grey.shade100
                      : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display status text
                Row(
                  children: [
                    Icon(
                      item.isDelivered
                          ? Icons.check_circle
                          : Icons.local_shipping,
                      size: 16,
                      color:
                          item.isDelivered ? AppColors.success : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.deliveryStatus,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                            item.isDelivered
                                ? AppColors.success
                                : Colors.orange,
                      ),
                    ),
                  ],
                ),

                // Display download button if item is delivered and has fileUrl
                if (item.isDelivered && item.fileUrl != null)
                  _buildDownloadButton(context, item, state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(
    BuildContext context,
    LibraryItemEntity item,
    LibraryState state,
  ) {
    // Check if this item is currently being downloaded
    final isDownloadingThisItem =
        state.isDownloading && state.selectedItem?.id == item.id;

    return ElevatedButton.icon(
      onPressed:
          isDownloadingThisItem
              ? null
              : () {
                context.read<LibraryCubit>().downloadItem(item.id);
              },
      icon:
          isDownloadingThisItem
              ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator.adaptive(
                  value: state.downloadProgress,
                  strokeWidth: 2,
                  // color: Colors.white,
                  
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
