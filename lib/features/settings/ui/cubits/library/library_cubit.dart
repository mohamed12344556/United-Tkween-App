import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

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
          errorMessage: error.errorMessage?? 'خطأ في تحميل المكتبة',
        ),
      ),
      (items) =>
          emit(state.copyWith(status: LibraryStatus.success, items: items)),
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
