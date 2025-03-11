import 'package:equatable/equatable.dart';

import '../../../domain/entities/library_item_entity.dart';

enum LibraryStatus { initial, loading, success, error }


class LibraryState extends Equatable {
  final LibraryStatus status;
  final List<LibraryItemEntity> items;
  final LibraryItemEntity? selectedItem;
  final String? errorMessage;
  final bool isDownloading;
  final double downloadProgress;

  const LibraryState({
    this.status = LibraryStatus.initial,
    this.items = const [],
    this.selectedItem,
    this.errorMessage,
    this.isDownloading = false,
    this.downloadProgress = 0.0,
  });

  LibraryState copyWith({
    LibraryStatus? status,
    List<LibraryItemEntity>? items,
    LibraryItemEntity? selectedItem,
    String? errorMessage,
    bool? isDownloading,
    double? downloadProgress,
  }) {
    return LibraryState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedItem: selectedItem ?? this.selectedItem,
      errorMessage: errorMessage ?? this.errorMessage,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        selectedItem,
        errorMessage,
        isDownloading,
        downloadProgress,
      ];

  // Helper states
  bool get isInitial => status == LibraryStatus.initial;
  bool get isLoading => status == LibraryStatus.loading;
  bool get isSuccess => status == LibraryStatus.success;
  bool get isError => status == LibraryStatus.error;
  bool get hasItems => items.isNotEmpty;
}