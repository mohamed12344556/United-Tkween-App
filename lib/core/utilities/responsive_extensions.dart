import 'package:flutter/material.dart';
import 'package:united_formation_app/core/utilities/enums/device_type.dart';
import 'responsive_size_utils.dart';

extension ResponsiveExtension on num {
  // عرض متجاوب
  double get w => ResponsiveSize.adaptiveWidth(toDouble());

  // ارتفاع متجاوب
  double get h => ResponsiveSize.adaptiveHeight(toDouble());

  // حجم عام متجاوب
  double get r => ResponsiveSize.adaptiveSize(toDouble());

  // حجم خط متجاوب
  double get sp => ResponsiveSize.adaptiveText(toDouble());

  // قيم padding و margin وفقًا للاتجاه
  EdgeInsets get paddingAll => EdgeInsets.all(r);
  EdgeInsets get paddingTop => EdgeInsets.only(top: h);
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: h);
  EdgeInsets get paddingLeft => EdgeInsets.only(left: w);
  EdgeInsets get paddingRight => EdgeInsets.only(right: w);
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: h);
  EdgeInsets get paddingHorizontal => EdgeInsets.symmetric(horizontal: w);

  EdgeInsets get marginAll => EdgeInsets.all(r);
  EdgeInsets get marginTop => EdgeInsets.only(top: h);
  EdgeInsets get marginBottom => EdgeInsets.only(bottom: h);
  EdgeInsets get marginLeft => EdgeInsets.only(left: w);
  EdgeInsets get marginRight => EdgeInsets.only(right: w);
  EdgeInsets get marginVertical => EdgeInsets.symmetric(vertical: h);
  EdgeInsets get marginHorizontal => EdgeInsets.symmetric(horizontal: w);
}

extension BuildContextResponsiveExtension on BuildContext {
  // استدعاء لتهيئة قيم المتجاوبة
  void initResponsive() {
    ResponsiveSize.init(this);
  }

  // إمكانية الوصول المباشر لأبعاد الشاشة
  double get screenWidth => ResponsiveSize.screenWidth;
  double get screenHeight => ResponsiveSize.screenHeight;

  // معرفة نوع الجهاز
  DeviceType get deviceType => ResponsiveSize.getDeviceType();

  // معرفة هل الجهاز هاتف
  bool get isPhone => deviceType == DeviceType.phone;

  // معرفة هل الجهاز تابلت
  bool get isTablet => deviceType == DeviceType.tablet;

  // معرفة هل الجهاز سطح مكتب
  bool get isDesktop => deviceType == DeviceType.desktop;

  // معرفة اتجاه الشاشة
  bool get isLandscape => ResponsiveSize.isLandscape();
  bool get isPortrait => !isLandscape;
}
