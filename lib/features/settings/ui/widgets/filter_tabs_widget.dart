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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 26), // 0.1
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: TabBar(
          controller: tabController,
          onTap: onTabChanged,
          indicator: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          labelColor: AppColors.secondary,
          unselectedLabelColor: Colors.white,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            return states.contains(WidgetState.pressed)
                ? Colors.transparent
                : null;
          }),
          tabs: tabTitles.map((title) => Tab(text: title, height: 30)).toList(),
        ),
      ),
    );
  }
}
