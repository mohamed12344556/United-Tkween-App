import 'package:flutter/cupertino.dart';

class AppLinksHandler {
  // Check if the route is a deep link
  static bool isDeepLink(String? routeName) {
    if (routeName == null) return false;

    return routeName.startsWith('tkween://book') ||
        routeName.startsWith('https://tkweenstore.com/api/get_book.php') ||
        routeName.startsWith('http://tkweenstore.com/api/get_book.php') ||
        routeName.startsWith('https://www.tkweenstore.com/api/get_book.php') ||
        routeName.startsWith('http://www.tkweenstore.com/api/get_book.php') ||
        routeName.contains('/api/get_book.php') ||
        routeName.contains('?id=') || // NEW: Handle query params
        _isNumericPath(routeName);
  }

  // Helper: Check if route is just a number (product ID)
  static bool _isNumericPath(String routeName) {
    if (!routeName.startsWith('/')) return false;
    final pathWithoutSlash = routeName.substring(1);
    // Check if it's a number without query params
    final number = pathWithoutSlash.split('?').first;
    return int.tryParse(number) != null;
  }

  // Extract product ID from deep link
  static String? extractProductId(String routeName) {
    try {
      print('🔍 Extracting product ID from: "$routeName"');

      // ✅ Handle: /?id=45 (root path with query parameter)
      if (routeName.startsWith('/?id=') || routeName.startsWith('?id=')) {
        final uri = Uri.parse(
          'http://dummy.com$routeName',
        ); // Add dummy host for parsing
        final id = uri.queryParameters['id'];
        if (id != null) {
          print('✅ Extracted ID from root query parameter: $id');
          return id;
        }
      }

      // ✅ Handle direct numeric path: /45
      if (_isNumericPath(routeName)) {
        final id =
            routeName
                .substring(1)
                .split('?')
                .first; // Remove leading "/" and any query params
        print('✅ Extracted ID from numeric path: $id');
        return id;
      }

      // Try parsing as full URI
      Uri uri;
      if (routeName.startsWith('http') || routeName.startsWith('tkween://')) {
        uri = Uri.parse(routeName);
      } else {
        // Handle relative paths
        uri = Uri.parse('http://dummy.com$routeName');
      }

      // ✅ Handle: ?id=45 or /?id=45 (query parameter)
      if (uri.queryParameters.containsKey('id')) {
        final id = uri.queryParameters['id'];
        print('✅ Extracted ID from query parameter: $id');
        return id;
      }

      // ✅ Handle: /api/get_book.php/45 or /book/45 (path segments)
      if (uri.pathSegments.isNotEmpty) {
        final lastSegment = uri.pathSegments.last;
        if (int.tryParse(lastSegment) != null) {
          print('✅ Extracted ID from path segment: $lastSegment');
          return lastSegment;
        }
      }

      print('❌ Could not extract ID from: "$routeName"');
    } catch (e) {
      debugPrint('❌ Error extracting product ID: $e');
      return null;
    }

    return null;
  }

  // Generate deep link for sharing (Web format - matches API)
  static String generateProductLink(String productId) {
    return 'https://tkweenstore.com/api/get_book.php?id=$productId';
  }

  // Generate app-specific deep link (for internal use)
  static String generateAppLink(String productId) {
    return 'tkween://book?id=$productId';
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
