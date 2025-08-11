// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class TapPaymentScreen extends StatefulWidget {
//   final String tapPaymentUrl;
//   final VoidCallback? onPaymentComplete;
//   final VoidCallback? onPaymentCancel;

//   const TapPaymentScreen({
//     super.key,
//     required this.tapPaymentUrl,
//     this.onPaymentComplete,
//     this.onPaymentCancel,
//   });

//   @override
//   State<TapPaymentScreen> createState() => _TapPaymentScreenState();
// }

// class _TapPaymentScreenState extends State<TapPaymentScreen> {
//   late final WebViewController _controller;
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "إتمام الدفع",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.black,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             _showExitDialog();
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               _controller.reload();
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           if (_errorMessage != null)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     _errorMessage!,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _errorMessage = null;
//                       });
//                       _controller.reload();
//                     },
//                     child: const Text('إعادة المحاولة'),
//                   ),
//                 ],
//               ),
//             )
//           else
//             WebViewWidget(controller: _controller),

//           if (_isLoading)
//             const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text(
//                     'جاري تحميل صفحة الدفع...',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeWebView();
//   }

//   void _initializeWebView() {
//     _controller =
//         WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..setBackgroundColor(const Color(0x00000000))
//           ..setNavigationDelegate(
//             NavigationDelegate(
//               onProgress: (int progress) {
//                 // Update loading bar if needed
//               },
//               onPageStarted: (String url) {
//                 setState(() {
//                   _isLoading = true;
//                   _errorMessage = null;
//                 });
//               },
//               onPageFinished: (String url) {
//                 setState(() {
//                   _isLoading = false;
//                 });

//                 // Check if payment is complete based on URL
//                 if (url.contains('success') || url.contains('completed')) {
//                   widget.onPaymentComplete?.call();
//                 } else if (url.contains('cancel') || url.contains('failed')) {
//                   widget.onPaymentCancel?.call();
//                 }
//               },
//               onWebResourceError: (WebResourceError error) {
//                 setState(() {
//                   _isLoading = false;
//                   _errorMessage =
//                       'خطأ في تحميل صفحة الدفع: ${error.description}';
//                 });
//               },
//               onNavigationRequest: (NavigationRequest request) {
//                 // Allow all navigation requests
//                 return NavigationDecision.navigate;
//               },
//             ),
//           )
//           ..loadRequest(Uri.parse(widget.tapPaymentUrl));
//   }

//   void _showExitDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('تأكيد الخروج'),
//           content: const Text('هل تريد إلغاء عملية الدفع والعودة؟'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: const Text('لا'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//                 widget.onPaymentCancel?.call();
//                 Navigator.of(context).pop(); // Close payment screen
//               },
//               child: const Text('نعم'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

//!

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class TapPaymentScreen extends StatefulWidget {
//   final String tapPaymentUrl;
//   final List<Map<String, dynamic>>? cartData; // إضافة بيانات السلة
//   final VoidCallback? onPaymentComplete;
//   final VoidCallback? onPaymentCancel;

//   const TapPaymentScreen({
//     super.key,
//     required this.tapPaymentUrl,
//     this.cartData,
//     this.onPaymentComplete,
//     this.onPaymentCancel,
//   });

//   @override
//   State<TapPaymentScreen> createState() => _TapPaymentScreenState();
// }

// class _TapPaymentScreenState extends State<TapPaymentScreen> {
//   late final WebViewController _controller;
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "إتمام الدفع",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             _showExitDialog();
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               _controller.reload();
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           if (_errorMessage != null)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     _errorMessage!,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _errorMessage = null;
//                       });
//                       _controller.reload();
//                     },
//                     child: const Text('إعادة المحاولة'),
//                   ),
//                 ],
//               ),
//             )
//           else
//             WebViewWidget(controller: _controller),

//           if (_isLoading)
//             const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text(
//                     'جاري تحميل صفحة الدفع...',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeWebView();
//   }

//   // دالة لحذف بيانات السلة من localStorage
//   Future<void> _clearCartData() async {
//     try {
//       await _controller.runJavaScript('''
//         try {
//           localStorage.removeItem("cart");
//           console.log("Cart data cleared from localStorage");

//           // إطلاق حدث مخصص لإعلام الصفحة بأن بيانات السلة تم حذفها
//           window.dispatchEvent(new CustomEvent('cartDataCleared'));
//         } catch (error) {
//           console.error("Error clearing cart data:", error);
//         }
//       ''');

//       print("Cart data cleared from WebView localStorage");
//     } catch (e) {
//       print("Error clearing cart data: $e");
//     }
//   }

//   void _initializeWebView() {
//     _controller =
//         WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..setBackgroundColor(const Color(0x00000000))
//           ..setNavigationDelegate(
//             NavigationDelegate(
//               onProgress: (int progress) {
//                 // Update loading bar if needed
//               },
//               onPageStarted: (String url) {
//                 setState(() {
//                   _isLoading = true;
//                   _errorMessage = null;
//                 });
//               },
//               onPageFinished: (String url) async {
//                 setState(() {
//                   _isLoading = false;
//                 });

//                 // حقن بيانات السلة في localStorage بعد تحميل الصفحة
//                 if (widget.cartData != null && widget.cartData!.isNotEmpty) {
//                   await _injectCartData();
//                 }

//                 // Check if payment is complete based on URL
//                 if (url.contains('success') || url.contains('completed')) {
//                   // حذف بيانات السلة من localStorage عند نجاح العملية
//                   await _clearCartData();
//                   widget.onPaymentComplete?.call();
//                 } else if (url.contains('cancel') || url.contains('failed')) {
//                   // حذف بيانات السلة من localStorage عند الإلغاء أو الفشل
//                   await _clearCartData();
//                   widget.onPaymentCancel?.call();
//                 }
//               },
//               onWebResourceError: (WebResourceError error) {
//                 setState(() {
//                   _isLoading = false;
//                   _errorMessage =
//                       'خطأ في تحميل صفحة الدفع: ${error.description}';
//                 });
//               },
//               onNavigationRequest: (NavigationRequest request) {
//                 // Allow all navigation requests
//                 return NavigationDecision.navigate;
//               },
//             ),
//           )
//           ..loadRequest(Uri.parse(widget.tapPaymentUrl));
//   }

//   // دالة لحقن بيانات السلة في localStorage
//   Future<void> _injectCartData() async {
//     try {
//       final cartJson = jsonEncode(widget.cartData);

//       await _controller.runJavaScript('''
//         try {
//           localStorage.setItem("cart", '$cartJson');
//           console.log("Cart data injected successfully");

//           // إطلاق حدث مخصص لإعلام الصفحة بأن بيانات السلة متاحة
//           window.dispatchEvent(new CustomEvent('cartDataReady', {
//             detail: JSON.parse('$cartJson')
//           }));
//         } catch (error) {
//           console.error("Error injecting cart data:", error);
//         }
//       ''');

//       print("Cart data injected into WebView localStorage");
//     } catch (e) {
//       print("Error injecting cart data: $e");
//     }
//   }

//   void _showExitDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('تأكيد الخروج'),
//           content: const Text('هل تريد إلغاء عملية الدفع والعودة؟'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: const Text('لا'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop(); // Close dialog

//                 // حذف بيانات السلة عند الخروج من الصفحة
//                 await _clearCartData();

//                 widget.onPaymentCancel?.call();
//                 Navigator.of(context).pop(); // Close payment screen
//               },
//               child: const Text('نعم'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// //!

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// import '../../../../core/core.dart';

// class TapPaymentScreen extends StatefulWidget {
//   final String tapPaymentUrl;
//   final List<Map<String, dynamic>>? cartData; // إضافة بيانات السلة
//   final Map<String, String>? customerData; // إضافة بيانات العميل
//   final VoidCallback? onPaymentComplete;
//   final VoidCallback? onPaymentCancel;

//   const TapPaymentScreen({
//     super.key,
//     required this.tapPaymentUrl,
//     this.cartData,
//     this.customerData,
//     this.onPaymentComplete,
//     this.onPaymentCancel,
//   });

//   @override
//   State<TapPaymentScreen> createState() => _TapPaymentScreenState();
// }

// class _TapPaymentScreenState extends State<TapPaymentScreen> {
//   late final WebViewController _controller;
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = context.isDarkMode;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "إتمام الدفع",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? Colors.white : AppColors.primary,
//           ),
//         ),
//         backgroundColor: isDarkMode ? AppColors.primary : Colors.white,
//         foregroundColor: isDarkMode ? Colors.white : Colors.black,
//         elevation: 1,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: isDarkMode ? Colors.white : AppColors.primary,
//           ),
//           onPressed: () {
//             _showExitDialog();
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.refresh,
//               color: isDarkMode ? Colors.white : AppColors.primary,
//             ),
//             onPressed: () {
//               _controller.reload();
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           if (_errorMessage != null)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     _errorMessage!,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _errorMessage = null;
//                       });
//                       _controller.reload();
//                     },
//                     child: const Text('إعادة المحاولة'),
//                   ),
//                 ],
//               ),
//             )
//           else
//             WebViewWidget(controller: _controller),

//           if (_isLoading)
//             const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text(
//                     'جاري تحميل صفحة الدفع...',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeWebView();
//   }

//   // دالة لحذف جميع البيانات من localStorage
//   Future<void> _clearAllData() async {
//     try {
//       await _controller.runJavaScript('''
//         try {
//           localStorage.removeItem("cart");
//           localStorage.removeItem("customer_data");
//           console.log("All data cleared from localStorage");

//           // إطلاق حدث مخصص لإعلام الصفحة بأن جميع البيانات تم حذفها
//           window.dispatchEvent(new CustomEvent('allDataCleared'));
//         } catch (error) {
//           console.error("Error clearing all data:", error);
//         }
//       ''');

//       print("All data cleared from WebView localStorage");
//     } catch (e) {
//       print("Error clearing all data: $e");
//     }
//   }

//   // دالة لحذف بيانات السلة من localStorage
//   Future<void> _clearCartData() async {
//     try {
//       await _controller.runJavaScript('''
//         try {
//           localStorage.removeItem("cart");
//           console.log("Cart data cleared from localStorage");

//           // إطلاق حدث مخصص لإعلام الصفحة بأن بيانات السلة تم حذفها
//           window.dispatchEvent(new CustomEvent('cartDataCleared'));
//         } catch (error) {
//           console.error("Error clearing cart data:", error);
//         }
//       ''');

//       print("Cart data cleared from WebView localStorage");
//     } catch (e) {
//       print("Error clearing cart data: $e");
//     }
//   }

//   void _initializeWebView() {
//     _controller =
//         WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..setBackgroundColor(const Color(0x00000000))
//           ..setNavigationDelegate(
//             NavigationDelegate(
//               onProgress: (int progress) {
//                 // Update loading bar if needed
//               },
//               onPageStarted: (String url) {
//                 setState(() {
//                   _isLoading = true;
//                   _errorMessage = null;
//                 });
//               },
//               onPageFinished: (String url) async {
//                 setState(() {
//                   _isLoading = false;
//                 });

//                 // حقن بيانات السلة وبيانات العميل في localStorage بعد تحميل الصفحة
//                 if (widget.cartData != null && widget.cartData!.isNotEmpty) {
//                   await _injectCartData();
//                 }

//                 if (widget.customerData != null &&
//                     widget.customerData!.isNotEmpty) {
//                   await _injectCustomerData();
//                 }

//                 // Check if payment is complete based on URL
//                 if (url.contains('success') || url.contains('completed')) {
//                   // حذف بيانات السلة وبيانات العميل من localStorage عند نجاح العملية
//                   await _clearAllData();
//                   widget.onPaymentComplete?.call();
//                 } else if (url.contains('cancel') || url.contains('failed')) {
//                   // حذف بيانات السلة وبيانات العميل من localStorage عند الإلغاء أو الفشل
//                   await _clearAllData();
//                   widget.onPaymentCancel?.call();
//                 }
//               },
//               onWebResourceError: (WebResourceError error) {
//                 setState(() {
//                   _isLoading = false;
//                   _errorMessage =
//                       'خطأ في تحميل صفحة الدفع: ${error.description}';
//                 });
//               },
//               onNavigationRequest: (NavigationRequest request) {
//                 // Allow all navigation requests
//                 return NavigationDecision.navigate;
//               },
//             ),
//           )
//           ..loadRequest(Uri.parse(widget.tapPaymentUrl));
//   }

//   // دالة لحقن بيانات السلة في localStorage
//   Future<void> _injectCartData() async {
//     try {
//       final cartJson = jsonEncode(widget.cartData);

//       await _controller.runJavaScript('''
//         try {
//           localStorage.setItem("cart", '$cartJson');
//           console.log("Cart data injected successfully");

//           // إطلاق حدث مخصص لإعلام الصفحة بأن بيانات السلة متاحة
//           window.dispatchEvent(new CustomEvent('cartDataReady', {
//             detail: JSON.parse('$cartJson')
//           }));
//         } catch (error) {
//           console.error("Error injecting cart data:", error);
//         }
//       ''');

//       print("Cart data injected into WebView localStorage");
//     } catch (e) {
//       print("Error injecting cart data: $e");
//     }
//   }

//   // دالة لحقن بيانات العميل في localStorage
//   Future<void> _injectCustomerData() async {
//     try {
//       final customerJson = jsonEncode(widget.customerData);

//       await _controller.runJavaScript('''
//         try {
//           localStorage.setItem("customer_data", '$customerJson');
//           console.log("Customer data injected successfully");

//           // إطلاق حدث مخصص لإعلام الصفحة بأن بيانات العميل متاحة
//           window.dispatchEvent(new CustomEvent('customerDataReady', {
//             detail: JSON.parse('$customerJson')
//           }));

//           // ملء الحقول تلقائياً إذا كانت موجودة
//           const customerData = JSON.parse('$customerJson');

//           // البحث عن حقول الإدخال وملؤها
//           const fullNameField = document.querySelector('input[name="full_name"], input[id="full_name"], input[placeholder*="اسم"], input[placeholder*="name"]');
//           if (fullNameField && customerData.full_name) {
//             fullNameField.value = customerData.full_name;
//             fullNameField.dispatchEvent(new Event('input', { bubbles: true }));
//           }

//           const emailField = document.querySelector('input[name="email"], input[id="email"], input[placeholder*="البريد"], input[placeholder*="email"]');
//           if (emailField && customerData.email) {
//             emailField.value = customerData.email;
//             emailField.dispatchEvent(new Event('input', { bubbles: true }));
//           }

//           const phoneField = document.querySelector('input[name="phone"], input[id="phone"], input[type="tel"], input[placeholder*="هاتف"], input[placeholder*="phone"]');
//           if (phoneField && customerData.phone) {
//             phoneField.value = customerData.phone;
//             phoneField.dispatchEvent(new Event('input', { bubbles: true }));
//           }

//           const addressField = document.querySelector('input[name="address"], textarea[name="address"], input[id="address"], input[placeholder*="عنوان"], input[placeholder*="address"]');
//           if (addressField && customerData.address) {
//             addressField.value = customerData.address;
//             addressField.dispatchEvent(new Event('input', { bubbles: true }));
//           }

//         } catch (error) {
//           console.error("Error injecting customer data:", error);
//         }
//       ''');

//       print("Customer data injected into WebView localStorage");
//     } catch (e) {
//       print("Error injecting customer data: $e");
//     }
//   }

//   void _showExitDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('تأكيد الخروج'),
//           content: const Text('هل تريد إلغاء عملية الدفع والعودة؟'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: const Text('لا'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop(); // Close dialog

//                 // حذف جميع البيانات عند الخروج من الصفحة
//                 await _clearAllData();

//                 widget.onPaymentCancel?.call();
//                 Navigator.of(context).pop(); // Close payment screen
//               },
//               child: const Text('نعم'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// import '../../../../core/core.dart';

// class TapPaymentScreen extends StatefulWidget {
//   final String tapPaymentUrl;
//   final List<Map<String, dynamic>>? cartData; // إضافة بيانات السلة
//   final Map<String, String>? customerData; // إضافة بيانات العميل
//   final VoidCallback? onPaymentComplete;
//   final VoidCallback? onPaymentCancel;

//   const TapPaymentScreen({
//     super.key,
//     required this.tapPaymentUrl,
//     this.cartData,
//     this.customerData,
//     this.onPaymentComplete,
//     this.onPaymentCancel,
//   });

//   @override
//   State<TapPaymentScreen> createState() => _TapPaymentScreenState();
// }

// class _TapPaymentScreenState extends State<TapPaymentScreen> {
//   late final WebViewController _controller;
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = context.isDarkMode;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "إتمام الدفع",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? Colors.white : AppColors.primary,
//           ),
//         ),
//         backgroundColor: isDarkMode ? AppColors.primary : Colors.white,
//         foregroundColor: isDarkMode ? Colors.white : Colors.black,
//         elevation: 1,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: isDarkMode ? Colors.white : AppColors.primary,
//           ),
//           onPressed: () {
//             _showExitDialog();
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.refresh,
//               color: isDarkMode ? Colors.white : AppColors.primary,
//             ),
//             onPressed: () {
//               _controller.reload();
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           if (_errorMessage != null)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     _errorMessage!,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _errorMessage = null;
//                       });
//                       _controller.reload();
//                     },
//                     child: const Text('إعادة المحاولة'),
//                   ),
//                 ],
//               ),
//             )
//           else
//             WebViewWidget(controller: _controller),

//           if (_isLoading)
//             const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text(
//                     'جاري تحميل صفحة الدفع...',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeWebView();
//   }

//   // دالة لحذف جميع البيانات من localStorage
//   Future<void> _clearAllData() async {
//     try {
//       await _controller.runJavaScript('''
//         try {
//           localStorage.removeItem("cart");
//           localStorage.removeItem("customer_data");
//           console.log("All data cleared from localStorage");

//           // إطلاق حدث مخصص لإعلام الصفحة بأن جميع البيانات تم حذفها
//           window.dispatchEvent(new CustomEvent('allDataCleared'));
//         } catch (error) {
//           console.error("Error clearing all data:", error);
//         }
//       ''');

//       print("All data cleared from WebView localStorage");
//     } catch (e) {
//       print("Error clearing all data: $e");
//     }
//   }

//   // دالة لحذف بيانات السلة من localStorage
//   Future<void> _clearCartData() async {
//     try {
//       await _controller.runJavaScript('''
//         try {
//           localStorage.removeItem("cart");
//           console.log("Cart data cleared from localStorage");

//           // إطلاق حدث مخصص لإعلام الصفحة بأن بيانات السلة تم حذفها
//           window.dispatchEvent(new CustomEvent('cartDataCleared'));
//         } catch (error) {
//           console.error("Error clearing cart data:", error);
//         }
//       ''');

//       print("Cart data cleared from WebView localStorage");
//     } catch (e) {
//       print("Error clearing cart data: $e");
//     }
//   }

//   void _initializeWebView() {
//     _controller =
//         WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..setBackgroundColor(const Color(0x00000000))
//           ..setNavigationDelegate(
//             NavigationDelegate(
//               onProgress: (int progress) {
//                 // Update loading bar if needed
//               },
//               onPageStarted: (String url) {
//                 setState(() {
//                   _isLoading = true;
//                   _errorMessage = null;
//                 });
//               },
//               onPageFinished: (String url) async {
//                 setState(() {
//                   _isLoading = false;
//                 });

//                 // انتظار قليل للتأكد من تحميل DOM والـ JavaScript
//                 await Future.delayed(const Duration(milliseconds: 1500));

//                 // حقن بيانات السلة وبيانات العميل في localStorage بعد تحميل الصفحة
//                 await _injectDataWithRetry();

//                 // Check if payment is complete based on URL
//                 if (url.contains('success') || url.contains('completed')) {
//                   // حذف بيانات السلة وبيانات العميل من localStorage عند نجاح العملية
//                   await _clearAllData();
//                   widget.onPaymentComplete?.call();
//                 } else if (url.contains('cancel') || url.contains('failed')) {
//                   // حذف بيانات السلة وبيانات العميل من localStorage عند الإلغاء أو الفشل
//                   await _clearAllData();
//                   widget.onPaymentCancel?.call();
//                 }
//               },
//               onWebResourceError: (WebResourceError error) {
//                 setState(() {
//                   _isLoading = false;
//                   _errorMessage =
//                       'خطأ في تحميل صفحة الدفع: ${error.description}';
//                 });
//               },
//               onNavigationRequest: (NavigationRequest request) {
//                 // Allow all navigation requests
//                 return NavigationDecision.navigate;
//               },
//             ),
//           )
//           ..loadRequest(Uri.parse(widget.tapPaymentUrl));
//   }

//   // دالة لحقن البيانات مع إعادة المحاولة
//   Future<void> _injectDataWithRetry({int maxRetries = 3}) async {
//     for (int i = 0; i < maxRetries; i++) {
//       try {
//         // التحقق من جاهزية الصفحة
//         final isReady = await _checkPageReadiness();

//         if (isReady) {
//           // حقن بيانات السلة
//           if (widget.cartData != null && widget.cartData!.isNotEmpty) {
//             await _injectCartData();
//           }

//           // حقن بيانات العميل
//           if (widget.customerData != null && widget.customerData!.isNotEmpty) {
//             await _injectCustomerData();
//           }

//           // إطلاق تحديث الصفحة بعد حقن البيانات
//           await _triggerPageUpdate();

//           print("Data injection completed successfully");
//           break;
//         } else {
//           print("Page not ready, retrying... (${i + 1}/$maxRetries)");
//           await Future.delayed(Duration(milliseconds: 1000 * (i + 1)));
//         }
//       } catch (e) {
//         print("Error in data injection attempt ${i + 1}: $e");
//         if (i < maxRetries - 1) {
//           await Future.delayed(Duration(milliseconds: 1000 * (i + 1)));
//         }
//       }
//     }
//   }

//   // التحقق من جاهزية الصفحة
//   Future<bool> _checkPageReadiness() async {
//     try {
//       final result = await _controller.runJavaScriptReturningResult('''
//         (function() {
//           return document.readyState === 'complete' &&
//                  typeof localStorage !== 'undefined' &&
//                  document.body !== null;
//         })()
//       ''');

//       return result == true;
//     } catch (e) {
//       print("Error checking page readiness: $e");
//       return false;
//     }
//   }

//   // إطلاق تحديث الصفحة بعد حقن البيانات
//   Future<void> _triggerPageUpdate() async {
//     try {
//       await _controller.runJavaScript('''
//         try {
//           // إطلاق أحداث مختلفة لتحديث الصفحة
//           window.dispatchEvent(new Event('resize'));
//           window.dispatchEvent(new Event('storage'));
//           window.dispatchEvent(new CustomEvent('dataInjected'));

//           // محاولة تحديث المكونات الشائعة
//           if (typeof window.updateCart === 'function') {
//             window.updateCart();
//           }

//           if (typeof window.refreshPage === 'function') {
//             window.refreshPage();
//           }

//           // البحث عن أزرار التحديث وتفعيلها
//           const refreshButtons = document.querySelectorAll('[data-refresh], .refresh-btn, .update-btn');
//           refreshButtons.forEach(btn => {
//             if (btn.click) btn.click();
//           });

//           console.log("Page update triggered");
//         } catch (error) {
//           console.error("Error triggering page update:", error);
//         }
//       ''');
//     } catch (e) {
//       print("Error triggering page update: $e");
//     }
//   }

//   // دالة لحقن بيانات السلة في localStorage مع تحسينات
//   Future<void> _injectCartData() async {
//     try {
//       final cartJson = jsonEncode(widget.cartData);
//       // تنظيف النص من الأحرف الخاصة
//       final escapedCartJson = cartJson
//           .replaceAll("'", "\\'")
//           .replaceAll('\n', '\\n');

//       await _controller.runJavaScript('''
//         try {
//           const cartData = $cartJson;
//           localStorage.setItem("cart", JSON.stringify(cartData));
//           console.log("Cart data injected successfully:", cartData);

//           // إطلاق أحداث متعددة لضمان التحديث
//           window.dispatchEvent(new CustomEvent('cartDataReady', {
//             detail: cartData
//           }));

//           window.dispatchEvent(new StorageEvent('storage', {
//             key: 'cart',
//             newValue: JSON.stringify(cartData)
//           }));

//           // محاولة تحديث السلة إذا كانت الدالة موجودة
//           if (typeof window.loadCartData === 'function') {
//             window.loadCartData();
//           }

//         } catch (error) {
//           console.error("Error injecting cart data:", error);
//         }
//       ''');

//       print("Cart data injected into WebView localStorage");
//     } catch (e) {
//       print("Error injecting cart data: $e");
//     }
//   }

//   // دالة لحقن بيانات العميل في localStorage مع تحسينات
//   Future<void> _injectCustomerData() async {
//     try {
//       final customerJson = jsonEncode(widget.customerData);

//       await _controller.runJavaScript('''
//         try {
//           const customerData = $customerJson;
//           localStorage.setItem("customer_data", JSON.stringify(customerData));
//           console.log("Customer data injected successfully:", customerData);

//           // إطلاق أحداث متعددة لضمان التحديث
//           window.dispatchEvent(new CustomEvent('customerDataReady', {
//             detail: customerData
//           }));

//           window.dispatchEvent(new StorageEvent('storage', {
//             key: 'customer_data',
//             newValue: JSON.stringify(customerData)
//           }));

//           // انتظار قصير ثم ملء الحقول
//           setTimeout(() => {
//             try {
//               // البحث عن حقول الإدخال وملؤها
//               const fillField = (selectors, value) => {
//                 for (const selector of selectors) {
//                   const field = document.querySelector(selector);
//                   if (field && value) {
//                     field.value = value;
//                     field.dispatchEvent(new Event('input', { bubbles: true }));
//                     field.dispatchEvent(new Event('change', { bubbles: true }));
//                     return true;
//                   }
//                 }
//                 return false;
//               };

//               // ملء الحقول بالترتيب
//               fillField([
//                 'input[name="full_name"]',
//                 'input[id="full_name"]',
//                 'input[placeholder*="اسم"]',
//                 'input[placeholder*="name"]'
//               ], customerData.full_name);

//               fillField([
//                 'input[name="email"]',
//                 'input[id="email"]',
//                 'input[placeholder*="البريد"]',
//                 'input[placeholder*="email"]'
//               ], customerData.email);

//               fillField([
//                 'input[name="phone"]',
//                 'input[id="phone"]',
//                 'input[type="tel"]',
//                 'input[placeholder*="هاتف"]',
//                 'input[placeholder*="phone"]'
//               ], customerData.phone);

//               fillField([
//                 'input[name="address"]',
//                 'textarea[name="address"]',
//                 'input[id="address"]',
//                 'input[placeholder*="عنوان"]',
//                 'input[placeholder*="address"]'
//               ], customerData.address);

//               console.log("Customer fields auto-filled");
//             } catch (error) {
//               console.error("Error filling customer fields:", error);
//             }
//           }, 500);

//         } catch (error) {
//           console.error("Error injecting customer data:", error);
//         }
//       ''');

//       print("Customer data injected into WebView localStorage");
//     } catch (e) {
//       print("Error injecting customer data: $e");
//     }
//   }

//   void _showExitDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('تأكيد الخروج'),
//           content: const Text('هل تريد إلغاء عملية الدفع والعودة؟'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: const Text('لا'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop(); // Close dialog

//                 // حذف جميع البيانات عند الخروج من الصفحة
//                 await _clearAllData();

//                 widget.onPaymentCancel?.call();
//                 Navigator.of(context).pop(); // Close payment screen
//               },
//               child: const Text('نعم'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

//!

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/core.dart';
import '../../../../generated/l10n.dart';

class TapPaymentScreen extends StatefulWidget {
  final String tapPaymentUrl;
  final List<Map<String, dynamic>>? cartData; // إضافة بيانات السلة
  final Map<String, String>? customerData; // إضافة بيانات العميل
  final VoidCallback? onPaymentComplete;
  final VoidCallback? onPaymentCancel;

  const TapPaymentScreen({
    super.key,
    required this.tapPaymentUrl,
    this.cartData,
    this.customerData,
    this.onPaymentComplete,
    this.onPaymentCancel,
  });

  @override
  State<TapPaymentScreen> createState() => _TapPaymentScreenState();
}

class _TapPaymentScreenState extends State<TapPaymentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).payment_title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : AppColors.primary,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.primary : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDarkMode ? Colors.white : AppColors.primary,
          ),
          onPressed: () {
            _showExitDialog();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: isDarkMode ? Colors.white : AppColors.primary,
            ),
            onPressed: () {
              _refreshWebView();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_errorMessage != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _errorMessage = null;
                      });
                      _refreshWebView();
                    },
                    child: Text(S.of(context).retry_button),
                  ),
                ],
              ),
            )
          else
            WebViewWidget(controller: _controller),

          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    S.of(context).loading_payment,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeWebView();

    // عرض dialog التحديث بعد تحميل الصفحة
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _showRefreshDialog();
      }
    });
  }

  // دالة منفصلة لعمل refresh للـ WebView
  void _refreshWebView() {
    _controller.reload();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
  }

  // دالة لحذف جميع البيانات من localStorage
  Future<void> _clearAllData() async {
    try {
      await _controller.runJavaScript('''
        try {
          localStorage.removeItem("cart");
          localStorage.removeItem("customer_data");
          console.log("All data cleared from localStorage");
          
          // إطلاق حدث مخصص لإعلام الصفحة بأن جميع البيانات تم حذفها
          window.dispatchEvent(new CustomEvent('allDataCleared'));
        } catch (error) {
          console.error("Error clearing all data:", error);
        }
      ''');

      print("All data cleared from WebView localStorage");
    } catch (e) {
      print("Error clearing all data: $e");
    }
  }

  // دالة لحذف بيانات السلة من localStorage
  Future<void> _clearCartData() async {
    try {
      await _controller.runJavaScript('''
        try {
          localStorage.removeItem("cart");
          console.log("Cart data cleared from localStorage");
          
          // إطلاق حدث مخصص لإعلام الصفحة بأن بيانات السلة تم حذفها
          window.dispatchEvent(new CustomEvent('cartDataCleared'));
        } catch (error) {
          console.error("Error clearing cart data:", error);
        }
      ''');

      print("Cart data cleared from WebView localStorage");
    } catch (e) {
      print("Error clearing cart data: $e");
    }
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar if needed
              },
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
              },
              onPageFinished: (String url) async {
                setState(() {
                  _isLoading = false;
                });

                // انتظار قليل للتأكد من تحميل DOM والـ JavaScript
                await Future.delayed(const Duration(milliseconds: 1500));

                // حقن بيانات السلة وبيانات العميل في localStorage بعد تحميل الصفحة
                await _injectDataWithRetry();

                // Check if payment is complete based on URL
                if (url.contains('success') || url.contains('completed')) {
                  // حذف بيانات السلة وبيانات العميل من localStorage عند نجاح العملية
                  await _clearAllData();
                  widget.onPaymentComplete?.call();
                } else if (url.contains('cancel') || url.contains('failed')) {
                  // حذف بيانات السلة وبيانات العميل من localStorage عند الإلغاء أو الفشل
                  await _clearAllData();
                  widget.onPaymentCancel?.call();
                }
              },
              onWebResourceError: (WebResourceError error) {
                setState(() {
                  _isLoading = false;
                  _errorMessage =
                      '${S.of(context).payment_error}   ${error.description}';
                });
              },
              onNavigationRequest: (NavigationRequest request) {
                // Allow all navigation requests
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.tapPaymentUrl));

    // إزالة الـ reload التلقائي من هنا لأننا سنستخدم الـ dialog
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   _refreshWebView();
    // });
  }

  // دالة لحقن البيانات مع إعادة المحاولة
  Future<void> _injectDataWithRetry({int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        // التحقق من جاهزية الصفحة
        final isReady = await _checkPageReadiness();

        if (isReady) {
          // حقن بيانات السلة
          if (widget.cartData != null && widget.cartData!.isNotEmpty) {
            await _injectCartData();
          }

          // حقن بيانات العميل
          if (widget.customerData != null && widget.customerData!.isNotEmpty) {
            await _injectCustomerData();
          }

          // إطلاق تحديث الصفحة بعد حقن البيانات
          await _triggerPageUpdate();

          print("Data injection completed successfully");
          break;
        } else {
          print("Page not ready, retrying... (${i + 1}/$maxRetries)");
          await Future.delayed(Duration(milliseconds: 1000 * (i + 1)));
        }
      } catch (e) {
        print("Error in data injection attempt ${i + 1}: $e");
        if (i < maxRetries - 1) {
          await Future.delayed(Duration(milliseconds: 1000 * (i + 1)));
        }
      }
    }
  }

  // التحقق من جاهزية الصفحة
  Future<bool> _checkPageReadiness() async {
    try {
      final result = await _controller.runJavaScriptReturningResult('''
        (function() {
          return document.readyState === 'complete' && 
                 typeof localStorage !== 'undefined' &&
                 document.body !== null;
        })()
      ''');

      return result == true;
    } catch (e) {
      print("Error checking page readiness: $e");
      return false;
    }
  }

  // إطلاق تحديث الصفحة بعد حقن البيانات
  Future<void> _triggerPageUpdate() async {
    try {
      await _controller.runJavaScript('''
        try {
          // إطلاق أحداث مختلفة لتحديث الصفحة
          window.dispatchEvent(new Event('resize'));
          window.dispatchEvent(new Event('storage'));
          window.dispatchEvent(new CustomEvent('dataInjected'));
          
          // محاولة تحديث المكونات الشائعة
          if (typeof window.updateCart === 'function') {
            window.updateCart();
          }
          
          if (typeof window.refreshPage === 'function') {
            window.refreshPage();
          }
          
          // البحث عن أزرار التحديث وتفعيلها
          const refreshButtons = document.querySelectorAll('[data-refresh], .refresh-btn, .update-btn');
          refreshButtons.forEach(btn => {
            if (btn.click) btn.click();
          });
          
          console.log("Page update triggered");
        } catch (error) {
          console.error("Error triggering page update:", error);
        }
      ''');
    } catch (e) {
      print("Error triggering page update: $e");
    }
  }

  // دالة لحقن بيانات السلة في localStorage مع تحسينات
  Future<void> _injectCartData() async {
    try {
      final cartJson = jsonEncode(widget.cartData);
      // تنظيف النص من الأحرف الخاصة
      final escapedCartJson = cartJson
          .replaceAll("'", "\\'")
          .replaceAll('\n', '\\n');

      await _controller.runJavaScript('''
        try {
          const cartData = $cartJson;
          localStorage.setItem("cart", JSON.stringify(cartData));
          console.log("Cart data injected successfully:", cartData);
          
          // إطلاق أحداث متعددة لضمان التحديث
          window.dispatchEvent(new CustomEvent('cartDataReady', {
            detail: cartData
          }));
          
          window.dispatchEvent(new StorageEvent('storage', {
            key: 'cart',
            newValue: JSON.stringify(cartData)
          }));
          
          // محاولة تحديث السلة إذا كانت الدالة موجودة
          if (typeof window.loadCartData === 'function') {
            window.loadCartData();
          }
          
        } catch (error) {
          console.error("Error injecting cart data:", error);
        }
      ''');

      print("Cart data injected into WebView localStorage");
    } catch (e) {
      print("Error injecting cart data: $e");
    }
  }

  // دالة لحقن بيانات العميل في localStorage مع تحسينات
  Future<void> _injectCustomerData() async {
    try {
      final customerJson = jsonEncode(widget.customerData);

      await _controller.runJavaScript('''
        try {
          const customerData = $customerJson;
          localStorage.setItem("customer_data", JSON.stringify(customerData));
          console.log("Customer data injected successfully:", customerData);
          
          // إطلاق أحداث متعددة لضمان التحديث
          window.dispatchEvent(new CustomEvent('customerDataReady', {
            detail: customerData
          }));
          
          window.dispatchEvent(new StorageEvent('storage', {
            key: 'customer_data',
            newValue: JSON.stringify(customerData)
          }));
          
          // انتظار قصير ثم ملء الحقول
          setTimeout(() => {
            try {
              // البحث عن حقول الإدخال وملؤها
              const fillField = (selectors, value) => {
                for (const selector of selectors) {
                  const field = document.querySelector(selector);
                  if (field && value) {
                    field.value = value;
                    field.dispatchEvent(new Event('input', { bubbles: true }));
                    field.dispatchEvent(new Event('change', { bubbles: true }));
                    return true;
                  }
                }
                return false;
              };

              // ملء الحقول بالترتيب
              fillField([
                'input[name="full_name"]', 
                'input[id="full_name"]', 
                'input[placeholder*="اسم"]', 
                'input[placeholder*="name"]'
              ], customerData.full_name);

              fillField([
                'input[name="email"]', 
                'input[id="email"]', 
                'input[placeholder*="البريد"]', 
                'input[placeholder*="email"]'
              ], customerData.email);
              
              fillField([
                'input[name="phone"]', 
                'input[id="phone"]', 
                'input[type="tel"]', 
                'input[placeholder*="هاتف"]', 
                'input[placeholder*="phone"]'
              ], customerData.phone);
              
              fillField([
                'input[name="address"]', 
                'textarea[name="address"]', 
                'input[id="address"]', 
                'input[placeholder*="عنوان"]', 
                'input[placeholder*="address"]'
              ], customerData.address);
              
              console.log("Customer fields auto-filled");
            } catch (error) {
              console.error("Error filling customer fields:", error);
            }
          }, 500);
          
        } catch (error) {
          console.error("Error injecting customer data:", error);
        }
      ''');

      print("Customer data injected into WebView localStorage");
    } catch (e) {
      print("Error injecting customer data: $e");
    }
  }

  // عرض dialog لطيف للتحديث
  void _showRefreshDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        bool isDarkMode = context.isDarkMode;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors:
                    isDarkMode
                        ? [
                          AppColors.primary.withOpacity(0.1),
                          Colors.grey[900]!,
                        ]
                        : [Colors.white, AppColors.primary.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // أيقونة جميلة
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.refresh_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),

                // عنوان
                Text(
                  S.of(context).refresh_title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // وصف
                Text(
                  S.of(context).refresh_description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // الأزرار
                Row(
                  children: [
                    // زر إلغاء
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // زر التحديث
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _refreshWebView();

                          // عرض رسالة تأكيد لطيفة
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(S.of(context).refreshing_page),
                                ],
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, size: 18),
                            SizedBox(width: 6),
                            Text(
                              S.of(context).refresh_now,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).exit_title),
          content: Text(S.of(context).exit_message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(S.of(context).no),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog

                // حذف جميع البيانات عند الخروج من الصفحة
                await _clearAllData();

                widget.onPaymentCancel?.call();
                Navigator.of(context).pop(); // Close payment screen
              },
              child: Text(S.of(context).yes),
            ),
          ],
        );
      },
    );
  }
}
