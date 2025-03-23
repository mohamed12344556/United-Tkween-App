import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/settings/domain/entities/library_item_entity.dart';

import '../../../domain/usecases/get_library_items_usecase.dart';
import 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final GetLibraryItemsUseCase _getLibraryItemsUseCase;

  Timer? _refreshTimer;

  LibraryCubit({required GetLibraryItemsUseCase getLibraryItemsUseCase})
    : _getLibraryItemsUseCase = getLibraryItemsUseCase,
      super(const LibraryState());

  Future<void> loadLibraryItems() async {
    if (isClosed) return;
    emit(state.copyWith(status: LibraryStatus.loading));

    final result = await _getLibraryItemsUseCase();

    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          status: LibraryStatus.error,
          errorMessage: error.errorMessage ?? 'خطأ في تحميل المكتبة',
        ),
      ),
      (items) {
        // إذا كان هناك بحث مسبق، طبق البحث على العناصر الجديدة
        if (state.searchQuery.isNotEmpty) {
          final filteredItems = _filterItems(items, state.searchQuery);
          emit(
            state.copyWith(
              status: LibraryStatus.success,
              items: items,
              filteredItems: filteredItems,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: LibraryStatus.success,
              items: items,
              filteredItems: items,
            ),
          );
        }
      },
    );
  }

  void selectItem(String itemId) {
    final selectedItem = state.items.firstWhere(
      (item) => item.id == itemId,
      orElse: () => state.items.first,
    );

    emit(state.copyWith(selectedItem: selectedItem));
  }

  void clearSelectedItem() {
    emit(state.copyWith(selectedItem: null));
  }

  // تصفية العناصر بناءً على نص البحث
  List<LibraryItemEntity> _filterItems(
    List<LibraryItemEntity> items,
    String query,
  ) {
    return items.where((item) {
      return item.title.toLowerCase().contains(query.toLowerCase()) ||
          (item.author?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (item.description?.toLowerCase().contains(query.toLowerCase()) ??
              false);
    }).toList();
  }

  // وظيفة البحث في المكتبة
  void searchLibraryItems(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredItems: state.items, searchQuery: ''));
      return;
    }

    final filteredItems = _filterItems(state.items, query);
    emit(state.copyWith(filteredItems: filteredItems, searchQuery: query));
  }

  // مسح البحث
  void clearSearch() {
    emit(state.copyWith(filteredItems: state.items, searchQuery: ''));
  }

  // تنفيذ عملية تحميل ملف من المكتبة
  Future<void> downloadItem(String itemId) async {
    emit(state.copyWith(isDownloading: true, downloadProgress: 0.0));

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(downloadProgress: i / 10));
    }

    // إكمال التحميل
    emit(state.copyWith(isDownloading: false, downloadProgress: 1.0));
  }

  void _cancelAllTimers() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  @override
  Future<void> close() {
    _cancelAllTimers();
    return super.close();
  }
}
