import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/settings/ui/widgets/library_item_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/filter_tabs_widget.dart';
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
    // تهيئة الأحجام المتجاوبة
    context.initResponsive();
    
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: _buildAppBar(),
      body: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          if (state.isLoading && !state.hasItems) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.secondary.withValues(
                  alpha: 51,
                ),
                strokeWidth: context.isTablet ? 3.0 : 2.0, // سمك متجاوب
              ),
            );
          }

          if (state.isError && !state.hasItems) {
            return _buildErrorState(state);
          }

          if (!state.hasItems) {
            return _buildEmptyState();
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
            // استخدام المكون المتجاوب بناءً على نوع الجهاز
            child: ResponsiveBuilder(
              builder: (context, deviceType) {
                switch (deviceType) {
                  case DeviceType.tablet:
                    return _buildLibraryGridWidget(state, columns: 3);
                  case DeviceType.desktop:
                    return _buildLibraryGridWidget(state, columns: 4);
                  default:
                    return _buildLibraryGridWidget(state, columns: 2);
                }
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
        child: Icon(Icons.add, size: context.isTablet ? 28.r : 24.r), // حجم متجاوب للأيقونة
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'مكتبتي',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: context.isTablet ? 20.sp : 18.sp, // حجم خط متجاوب
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      toolbarHeight: context.isTablet ? 64.h : 56.h, // ارتفاع متجاوب
      actions: [
        IconButton(
          icon: Container(
            padding: 8.paddingAll,
            decoration: BoxDecoration(
              color: AppColors.darkSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: context.isTablet ? 24.r : 20.r, // حجم أيقونة متجاوب
            ),
          ),
          onPressed: () {},
        ),
        SizedBox(width: 8.w), // مسافة متجاوبة
      ],
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(context.isTablet ? 110.h : 100.h), // ارتفاع متجاوب
        child: FilterTabsWidget(
          tabController: _tabController,
          tabTitles: _tabTitles,
          onTabChanged: (index) {},
        ),
      ),
    );
  }

  Widget _buildErrorState(LibraryState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline, 
            size: context.isTablet ? 70.r : 60.r, // حجم متجاوب للأيقونة
            color: AppColors.error
          ),
          SizedBox(height: 16.h), // مسافة متجاوبة
          Text(
            state.errorMessage ?? 'خطأ في تحميل المكتبة',
            style: TextStyle(
              color: Colors.white, 
              fontSize: context.isTablet ? 18.sp : 16.sp, // حجم خط متجاوب
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h), // مسافة متجاوبة
          SizedBox(
            width: context.isTablet ? 240.w : 200.w, // عرض متجاوب
            height: context.isTablet ? 54.h : 48.h, // ارتفاع متجاوب
            child: ElevatedButton.icon(
              onPressed: () => context.read<LibraryCubit>().loadLibraryItems(),
              icon: Icon(
                Icons.refresh, 
                size: context.isTablet ? 20.r : 16.r, // حجم متجاوب للأيقونة
              ),
              label: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontSize: context.isTablet ? 16.sp : 14.sp, // حجم خط متجاوب
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r), // نصف قطر حافة متجاوب
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h), // تباعد متجاوب
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.library_books_outlined,
      title: 'مكتبتك فارغة حالياً',
      message: 'قم بشراء الكتب والمحتوى التعليمي لعرضها هنا',
      buttonText: 'تصفح المتجر',
      onButtonPressed: () {},
      iconColor: AppColors.primary,
      iconSize: context.isTablet ? 70.r : 50.r, // حجم متجاوب للأيقونة
      titleSize: context.isTablet ? 24.sp : 20.sp, // حجم خط متجاوب للعنوان
      messageSize: context.isTablet ? 18.sp : 16.sp, // حجم خط متجاوب للرسالة
      buttonWidth: context.isTablet ? 240.w : 200.w, // عرض زر متجاوب
    );
  }

  Widget _buildLibraryGridWidget(LibraryState state, {required int columns}) {
    return GridView.builder(
      key: const PageStorageKey('library_items'),
      padding: EdgeInsets.all(context.isTablet ? 20.r : 16.r), // تباعد متجاوب
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: context.isTablet ? 16.w : 12.w, // تباعد متجاوب أفقي
        mainAxisSpacing: context.isTablet ? 16.h : 12.h, // تباعد متجاوب رأسي
        childAspectRatio: 0.75, // يمكن تعديله حسب الجهاز إذا لزم الأمر
      ),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return LibraryItemCard(
          item: item,
          state: state,
          onTap: () {},
          onDownload: () => context.read<LibraryCubit>().downloadItem(item.id),
          isResponsive: true, // إضافة خاصية للتجاوبية يتم استخدامها في المكون
        );
      },
    );
  }
}