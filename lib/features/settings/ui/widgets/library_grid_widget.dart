import 'package:flutter/material.dart';
import '../../domain/entities/library_item_entity.dart';
import '../cubits/library/library_state.dart';
import '../widgets/library_item_card.dart';

class LibraryGridWidget extends StatelessWidget {
  final LibraryState state;
  final Function(LibraryItemEntity) onItemTap;
  final Function(String) onDownloadItem;

  const LibraryGridWidget({
    super.key,
    required this.state,
    required this.onItemTap,
    required this.onDownloadItem,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: const PageStorageKey('library_items'),
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return LibraryItemCard(
          item: item,
          state: state,
          onTap: () => onItemTap(item),
          onDownload: () => onDownloadItem(item.id),
        );
      },
    );
  }
}