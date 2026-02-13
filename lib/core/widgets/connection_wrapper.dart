import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../core.dart';
import '../helper/network_connection.dart';

class ConnectionWrapper extends StatefulWidget {
  final Widget child;

  const ConnectionWrapper({super.key, required this.child});

  @override
  State<ConnectionWrapper> createState() => _ConnectionWrapperState();
}

class _ConnectionWrapperState extends State<ConnectionWrapper> {
  bool hasConnection = true;
  bool isCheckingConnection = false;
  late final Connectivity _connectivity;
  late final InternetConnection _connectionChecker;
  late final NetworkInfoImpl _networkInfo;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectionChecker = InternetConnection();
    _networkInfo = NetworkInfoImpl(_connectivity, _connectionChecker);

    // التحقق من الاتصال عند بدء التطبيق
    _checkConnection();

    // الاستماع للتغييرات في حالة الاتصال
    _connectivity.onConnectivityChanged.listen((_) {
      _checkConnection();
    });
  }

  Future<void> _checkConnection() async {
    setState(() {
      isCheckingConnection = true;
    });

    final connected = await _networkInfo.isConnected;
    debugPrint('🌐 Connection check result: $connected');

    if (mounted) {
      setState(() {
        hasConnection = connected;
        isCheckingConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          if (!hasConnection)
            Positioned.fill(
              child: NoInternetConnectionScreen(
                onTryAgain: _checkConnection,
                isLoading: isCheckingConnection,
              ),
            ),
        ],
      ),
    );
  }
}

class NoInternetConnectionScreen extends StatelessWidget {
  final VoidCallback onTryAgain;
  final bool isLoading;

  const NoInternetConnectionScreen({
    super.key,
    required this.onTryAgain,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEF1FF),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // رسم السحابة والرموز المتعلقة بالإنترنت
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // دوائر صغيرة للزخرفة
                      Positioned(
                        top: 0,
                        right: 40,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD7D9FF),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 30,
                        bottom: 10,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD7D9FF),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 30,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFBDC3FF),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      // رمز السحابة مع الإنترنت
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // رمز السحابة
                            Icon(
                              Icons.cloud_outlined,
                              size: 60,
                              color: Colors.blue[300],
                            ),
                            // رمز البرق داخل السحابة
                            Positioned(
                              child: Icon(
                                Icons.flash_on,
                                size: 25,
                                color: Colors.blue[300],
                              ),
                            ),
                            // رمز الواي فاي فوق السحابة
                            Positioned(
                              top: 15,
                              left: 20,
                              child: Icon(
                                Icons.wifi,
                                size: 15,
                                color: Colors.blue[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  // العنوان
                  Text(
                    Locale("ar").languageCode == 'ar' ? 'اوباااا' : "Ooops!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // الرسالة
                  const Text(
                    "عامل مثقف انت على الله حكايتك 🙂 شوف اللي وقع منك",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // زر إعادة المحاولة
                  AppButton(
                    text:
                        Locale("ar").languageCode == 'ar'
                            ? 'حاول من تاني'
                            : "TRY AGAIN",
                    isLoading: isLoading,
                    onPressed: isLoading ? null : onTryAgain,
                    textColor: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),

                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    height: 55,
                    isFullWidth: false,
                    child:
                        isLoading
                            ? SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                backgroundColor: AppColors.secondary.withValues(
                                  alpha: 51,
                                ),
                                strokeWidth: context.isTablet ? 3.0 : 2.0,
                              ),
                            )
                            : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
