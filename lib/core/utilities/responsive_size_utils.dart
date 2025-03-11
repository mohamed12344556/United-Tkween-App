import 'package:flutter/material.dart';
import 'package:united_formation_app/core/utilities/enums/device_type.dart';

class ResponsiveSize {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  
  static late double textScaleFactor;
  
  // قيم افتراضية للتصميم
  static const double defaultDesignWidth = 375;
  static const double defaultDesignHeight = 812;
  
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    
    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
    
    textScaleFactor = _mediaQueryData.textScaleFactor;
  }
  
  // حجم متناسب أفقيًا
  static double adaptiveWidth(double size) {
    return (size / defaultDesignWidth) * screenWidth;
  }
  
  // حجم متناسب رأسيًا
  static double adaptiveHeight(double size) {
    return (size / defaultDesignHeight) * screenHeight;
  }
  
  // نص بحجم متناسب
  static double adaptiveText(double size) {
    double adaptiveSize = adaptiveWidth(size);
    return adaptiveSize;
  }
  
  // حجم متناسب (يأخذ النسبة الأصغر من العرض أو الطول)
  static double adaptiveSize(double size) {
    double widthRatio = screenWidth / defaultDesignWidth;
    double heightRatio = screenHeight / defaultDesignHeight;
    return size * (widthRatio < heightRatio ? widthRatio : heightRatio);
  }
  
  // التأكد من أن الحجم لا يتجاوز حدًا معينًا
  static double adaptiveConstrainedSize(double size, {double min = 0, double? max}) {
    double adaptedSize = adaptiveSize(size);
    if (adaptedSize < min) return min;
    if (max != null && adaptedSize > max) return max;
    return adaptedSize;
  }
  
  // معرفة إذا كان الجهاز بوضع أفقي
  static bool isLandscape() {
    return screenWidth > screenHeight;
  }
  
  // معرفة نوع الجهاز (هاتف، تابلت، الخ)
  static DeviceType getDeviceType() {
    final double shortestSide = (screenWidth < screenHeight) ? screenWidth : screenHeight;
    
    if (shortestSide < 600) {
      return DeviceType.phone;
    } else if (shortestSide < 900) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }
}

