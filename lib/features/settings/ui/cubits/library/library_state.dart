import 'package:equatable/equatable.dart';

import '../../../domain/entities/library_item_entity.dart';

enum LibraryStatus { initial, loading, success, error }

class LibraryState extends Equatable {
  final LibraryStatus status;
  final List<LibraryItemEntity> items;
  final List<LibraryItemEntity> filteredItems;
  final LibraryItemEntity? selectedItem;
  final String? errorMessage;
  final bool isDownloading;
  final double downloadProgress;
  final String searchQuery;

  const LibraryState({
    this.status = LibraryStatus.initial,
    this.items = const [],
    this.filteredItems = const [],
    this.selectedItem,
    this.errorMessage,
    this.isDownloading = false,
    this.downloadProgress = 0.0,
    this.searchQuery = '',
  });

  LibraryState copyWith({
    LibraryStatus? status,
    List<LibraryItemEntity>? items,
    List<LibraryItemEntity>? filteredItems,
    LibraryItemEntity? selectedItem,
    String? errorMessage,
    bool? isDownloading,
    double? downloadProgress,
    String? searchQuery,
  }) {
    return LibraryState(
      status: status ?? this.status,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedItem: selectedItem ?? this.selectedItem,
      errorMessage: errorMessage ?? this.errorMessage,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    filteredItems,
    selectedItem,
    errorMessage,
    isDownloading,
    downloadProgress,
    searchQuery,
  ];

  // Helper states
  bool get isInitial => status == LibraryStatus.initial;
  bool get isLoading => status == LibraryStatus.loading;
  bool get isSuccess => status == LibraryStatus.success;
  bool get isError => status == LibraryStatus.error;
  bool get hasItems => items.isNotEmpty;
  bool get hasFilteredItems => filteredItems.isNotEmpty;
  bool get isSearching => searchQuery.isNotEmpty;
}
