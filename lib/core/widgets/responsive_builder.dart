import 'package:flutter/material.dart';
import 'package:united_formation_app/core/utilities/enums/device_type.dart';
import 'package:united_formation_app/core/utilities/responsive_size_utils.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;
  
  // مكونات محددة لكل نوع جهاز
  final Widget? phoneBuilder;
  final Widget? tabletBuilder;
  final Widget? desktopBuilder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.phoneBuilder,
    this.tabletBuilder,
    this.desktopBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // تهيئة قيم المتجاوبة
    ResponsiveSize.init(context);
    
    final deviceType = ResponsiveSize.getDeviceType();
    
    // استخدام المكون المناسب لنوع الجهاز إذا تم توفيره
    if (deviceType == DeviceType.phone && phoneBuilder != null) {
      return phoneBuilder!;
    }
    
    if (deviceType == DeviceType.tablet && tabletBuilder != null) {
      return tabletBuilder!;
    }
    
    if (deviceType == DeviceType.desktop && desktopBuilder != null) {
      return desktopBuilder!;
    }
    
    // استخدام الـ builder الأساسي
    return builder(context, deviceType);
  }
}