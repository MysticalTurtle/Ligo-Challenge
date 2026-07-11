import 'dart:io';

import 'package:ligo_challenge/core/network/connectivity/internet_connectivity.dart';

class InternetConnectivityImpl implements InternetConnectivity {
  @override
  Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}
