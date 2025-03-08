import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/profile/ui/widgets/content_container.dart';
import 'package:united_formation_app/features/profile/ui/widgets/empty_state_widget.dart';
import 'package:united_formation_app/features/profile/ui/widgets/error_retry_widget.dart';
import 'package:united_formation_app/features/profile/ui/widgets/library_item_card.dart';
import '../../../../core/core.dart';
import '../cubits/library/library_cubit.dart';
import '../cubits/library/library_state.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = 
      GlobalKey<RefreshIndicatorState>();

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
          if (state.isLoading && !state.hasItems) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state.isError && !state.hasItems) {
            return ErrorRetryWidget(
              message: state.errorMessage ?? 'خطأ في تحميل المكتبة',
              onRetry: () => context.read<LibraryCubit>().loadLibraryItems(),
            );
          }

          if (!state.hasItems) {
            return EmptyStateWidget(
              icon: Icons.library_books_outlined,
              message: 'مكتبتك فارغة حالياً',
            );
          }

          return ContentContainer(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: AppColors.secondary,
              backgroundColor: AppColors.primary,
              onRefresh: () async {
                await context.read<LibraryCubit>().loadLibraryItems();
              },
              child: ListView.builder(
                key: const PageStorageKey('library_items'),
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return LibraryItemCard(
                    item: item,
                    state: state,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}