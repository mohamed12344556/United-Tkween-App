import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class FilterTabsWidget extends StatelessWidget {
  final TabController tabController;
  final List<String> tabTitles;
  final ValueChanged<int>? onTabChanged;

  const FilterTabsWidget({
    super.key,
    required this.tabController,
    required this.tabTitles,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.isTablet ? 24.w : 16.w,
        vertical: context.isTablet ? 16.h : 12.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 26), // 0.1
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Padding(
        padding: 4.paddingAll,
        child: TabBar(
          controller: tabController,
          onTap: onTabChanged,
          indicator: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12.r),
          ),
          labelColor: AppColors.secondary,
          unselectedLabelColor: Colors.white,
          labelStyle: TextStyle(
            fontSize: context.isTablet ? 16.sp : 14.sp,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: context.isTablet ? 16.sp : 14.sp,
            fontWeight: FontWeight.normal,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelPadding: EdgeInsets.symmetric(
            vertical: context.isTablet ? 16.h : 12.h,
            horizontal: context.isTablet ? 12.w : 8.w,
          ),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            return states.contains(WidgetState.pressed)
                ? Colors.transparent
                : null;
          }),
          tabs: tabTitles.map((title) => Tab(
            text: title, 
            height: context.isTablet ? 40.h : 30.h,
          )).toList(),
        ),
      ),
    );
  }
}