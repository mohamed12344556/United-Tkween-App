import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:get_it/get_it.dart';
import 'package:united_formation_app/core/routes/routes.dart';
import 'package:united_formation_app/features/home/data/book_model.dart';
import 'package:united_formation_app/features/home/domain/home_repo.dart';
import 'package:united_formation_app/core/api/auth_interceptor.dart';

class DeepLinkService {
  static final _appLinks = AppLinks();
  static StreamSubscription<Uri>? _linkSubscription;

  // Initialize deep link handling
  static Future<void> initialize() async {
    try {
      // Handle app launch from deep link (when app is closed)
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        log('Initial deep link: $initialLink');
        await _handleDeepLink(initialLink.toString());
      }

      // Handle deep links when app is running
      _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
        log('Received deep link: $uri');
        _handleDeepLink(uri.toString());
      });
    } catch (e) {
      log('Error initializing deep links: $e');
    }
  }

  // Handle incoming deep link
  static Future<void> _handleDeepLink(String link) async {
    try {
      final uri = Uri.parse(link);

      // Handle tkween scheme or https scheme
      if (uri.scheme == 'tkween') {
        await _handleTkweenLink(uri);
      } else if (uri.scheme == 'https' && uri.host == 'tkweenstore.com') {
        await _handleHttpsLink(uri);
      }
    } catch (e) {
      log('Error handling deep link: $e');
    }
  }

  // Handle tkween deep links
  static Future<void> _handleTkweenLink(Uri uri) async {
    switch (uri.host) {
      case 'product':
        await _handleProductLink(uri);
        break;
      default:
        log('Unknown tkween link: ${uri.toString()}');
    }
  }

  // Handle https deep links
  static Future<void> _handleHttpsLink(Uri uri) async {
    try {
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty && pathSegments[0] == 'product') {
        await _handleProductLink(uri);
      }
    } catch (e) {
      log('Error handling https link: $e');
    }
  }

  // Handle product deep links
  static Future<void> _handleProductLink(Uri uri) async {
    try {
      final productId = uri.queryParameters['id'];

      if (productId != null) {
        log('Navigating to product: $productId');

        // Fetch the product data by ID
        final book = await _getProductById(productId);

        if (book != null) {
          // Navigate to product details with the fetched book
          NavigationService.navigatorKey.currentState?.pushNamed(
            Routes.productDetailsView,
            arguments: book,
          );
        } else {
          log('Product not found with ID: $productId');
          // Optionally show an error message or navigate to home
          NavigationService.navigatorKey.currentState?.pushNamed(
            Routes.hostView,
          );
        }
      } else {
        log('Product ID not found in deep link');
      }
    } catch (e) {
      log('Error handling product link: $e');
    }
  }

  // Get product by ID from the home repository
  static Future<BookModel?> _getProductById(String productId) async {
    try {
      final homeRepo = GetIt.instance<HomeRepo>();
      final result = await homeRepo.getHomeBooks();

      return result.fold(
        (failure) {
          log('Error fetching books: $failure');
          return null;
        },
        (books) {
          // Find book with matching ID
          final book = books.cast<BookModel?>().firstWhere(
            (book) => book?.id == productId,
            orElse: () => null,
          );
          return book;
        },
      );
    } catch (e) {
      log('Error getting product by ID: $e');
      return null;
    }
  }

  // Generate deep link for product sharing
  static String generateProductLink(String productId, {String? productName}) {
    return 'tkween://product?id=$productId${productName != null ? '&name=${Uri.encodeComponent(productName)}' : ''}';
  }

  // Dispose resources
  static void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
  }
}
