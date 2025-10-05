import 'package:flutter/cupertino.dart';

class AppLinksHandler {
  // Check if the route is a deep link
  static bool isDeepLink(String? routeName) {
    if (routeName == null) return false;

    return routeName.startsWith('tkween://product/') ||
        routeName.startsWith('https://tkweenstore.com/product/') ||
        routeName.startsWith('http://tkweenstore.com/product/') ||
        routeName.startsWith('/product/') ||
        RegExp(r'^/\d+$').hasMatch(routeName);
  }

  // Extract product ID from deep link
  static String? extractProductId(String routeName) {
    try {
      // Handle: tkween://product/{id}
      if (routeName.startsWith('tkween://product/')) {
        final uri = Uri.parse(routeName);
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
      }
      // Handle: https://tkweenstore.com/product/{id}
      else if (routeName.startsWith('https://tkweenstore.com/product/') ||
          routeName.startsWith('http://tkweenstore.com/product/')) {
        final uri = Uri.parse(routeName);
        if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'product') {
          return uri.pathSegments[1];
        }
      }
      // Handle: /product/{id}
      else if (routeName.startsWith('/product/')) {
        final uri = Uri.parse(routeName);
        if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'product') {
          return uri.pathSegments[1];
        }
      }
      // Handle: /{id} only numbers
      else if (RegExp(r'^/\d+$').hasMatch(routeName)) {
        return routeName.substring(1);
      }
    } catch (e) {
      print('Error extracting product ID: $e');
      return null;
    }

    return null;
  }

  // Generate deep link for sharing
  static String generateProductLink(String productId, {bool asWeb = false}) {
    if (asWeb) {
      return 'https://tkweenstore.com/product/$productId';
    } else {
      return 'tkween://product/$productId';
    }
  }

  // Optional: Extract query parameters if needed
  static Map<String, String>? extractQueryParams(String routeName) {
    try {
      final uri = Uri.parse(routeName);
      return uri.queryParameters.isNotEmpty ? uri.queryParameters : null;
    } catch (e) {
      debugPrint('Error extracting query params: $e');
      return null;
    }
  }
}
