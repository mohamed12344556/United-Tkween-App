import 'package:flutter/material.dart';
import 'package:united_formation_app/core/utilities/enums/device_type.dart';
import 'package:united_formation_app/core/utilities/responsive_size_utils.dart';

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final EdgeInsets padding;
  
  // عدد الأعمدة حسب نوع الجهاز
  final int phoneColumns;
  final int tabletColumns;
  final int desktopColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.padding = EdgeInsets.zero,
    this.phoneColumns = 2,
    this.tabletColumns = 3,
    this.desktopColumns = 4,
  });

  @override
  Widget build(BuildContext context) {
    // تهيئة قيم المتجاوبة
    ResponsiveSize.init(context);
    
    final deviceType = ResponsiveSize.getDeviceType();
    
    // تحديد عدد الأعمدة بناءً على نوع الجهاز
    int columns;
    switch (deviceType) {
      case DeviceType.phone:
        columns = phoneColumns;
        break;
      case DeviceType.tablet:
        columns = tabletColumns;
        break;
      case DeviceType.desktop:
        columns = desktopColumns;
        break;
    }
    
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: 0.75, // يمكن جعل هذا متغيرًا أيضًا
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}