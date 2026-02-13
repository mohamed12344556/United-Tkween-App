import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final InternetConnection checker;

  NetworkInfoImpl(this.connectivity, this.checker);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    debugPrint('🌐 Connectivity result: $result');
    if (result.contains(ConnectivityResult.none) && result.length == 1) {
      return false;
    }
    return true;
  }
}
