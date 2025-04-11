import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final InternetConnectionChecker checker;

  NetworkInfoImpl(this.connectivity, this.checker);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) return false;

    return checker.hasConnection;
  }
}
