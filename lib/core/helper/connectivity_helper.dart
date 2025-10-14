import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static final ConnectivityHelper _instance = ConnectivityHelper._internal();
  final Connectivity _connectivity = Connectivity();
  final List<void Function(bool)> _listeners = [];
  bool _isConnected = false;

  factory ConnectivityHelper() {
    return _instance;
  }

  ConnectivityHelper._internal() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectivityStatus(result);
    } as void Function(List<ConnectivityResult> event)?);

    // Check the initial connectivity status
    _checkInitialConnectivity();
  }

  bool get isConnected => _isConnected;

  void addListener(void Function(bool) listener) {
    _listeners.add(listener);
    listener(_isConnected); // Notify the new listener of the current status
  }

  void removeListener(void Function(bool) listener) {
    _listeners.remove(listener);
  }

  void _updateConnectivityStatus(ConnectivityResult result) {
    _isConnected = result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
    for (var listener in _listeners) {
      listener(_isConnected);
    }
  }

  void _checkInitialConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectivityStatus(connectivityResult as ConnectivityResult);
  }
}
