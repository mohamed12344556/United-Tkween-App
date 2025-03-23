// lib/core/helpers/url_helper.dart

import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static Future<void> launchPhoneUrl(String phoneNumber) async {
    // تنظيف رقم الهاتف من أي أحرف غير مسموح بها
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final url = 'tel:$cleanedNumber';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  static Future<void> launchMapUrl(String address) async {
    // تحويل العنوان إلى صيغة متوافقة مع URL
    final encodedAddress = Uri.encodeComponent(address);
    final url = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}