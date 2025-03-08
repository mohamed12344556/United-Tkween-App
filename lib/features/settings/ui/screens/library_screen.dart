import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/filter_tabs_widget.dart';
import '../widgets/library_grid_widget.dart';
import '../../../../core/core.dart';
import '../cubits/library/library_cubit.dart';
import '../cubits/library/library_state.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late TabController _tabController;

  final List<String> _tabTitles = const ['الكل', 'الكتب', 'الوسائط'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    _tabController.addListener(_handleTabChange);

    context.read<LibraryCubit>().loadLibraryItems();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      final selectedTabIndex = _tabController.index;

      switch (selectedTabIndex) {
        case 0:
          context.read<LibraryCubit>().loadLibraryItems();
          break;
        case 1:
          //  context.read<LibraryCubit>().loadBookItems();
          break;
        case 2:
          //  context.read<LibraryCubit>().loadMediaItems();
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'مكتبتي',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.darkSecondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            onPressed: () {
              // TODO: تنفيذ الفلترة
            },
          ),
          const SizedBox(width: 8),
        ],
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: FilterTabsWidget(
            tabController: _tabController,
            tabTitles: _tabTitles,
            onTabChanged: (index) {},
          ),
        ),
      ),
      body: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          if (state.isLoading && !state.hasItems) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.secondary.withValues(
                  alpha: 51,
                ), // 0.2
              ),
            );
          }

          if (state.isError && !state.hasItems) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'خطأ في تحميل المكتبة',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed:
                          () => context.read<LibraryCubit>().loadLibraryItems(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (!state.hasItems) {
            return EmptyStateWidget(
              icon: Icons.library_books_outlined,
              title: 'مكتبتك فارغة حالياً',
              message: 'قم بشراء الكتب والمحتوى التعليمي لعرضها هنا',
              buttonText: 'تصفح المتجر',
              onButtonPressed: () {
                // التنقل إلى المتجر
              },
              iconColor: AppColors.primary,
            );
          }

          return RefreshIndicator(
            key: _refreshIndicatorKey,
            color: AppColors.primary,
            backgroundColor: AppColors.darkSurface,
            onRefresh: () async {
              if (mounted) {
                await context.read<LibraryCubit>().loadLibraryItems();
              }
            },
            child: LibraryGridWidget(
              state: state,
              onItemTap: (item) {
                // تنفيذ عرض تفاصيل العنصر
              },
              onDownloadItem: (itemId) {
                context.read<LibraryCubit>().downloadItem(itemId);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        onPressed: () {},
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
