import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PlatformService {
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      return {
        'name': 'Web Browser',
        'type': 'web',
        'platform': 'web',
        'deviceInfo': {'platform': 'web'},
      };
    } else {
      final androidInfo = await deviceInfo.androidInfo;
      return {
        'name': '${androidInfo.brand} ${androidInfo.model}',
        'type': 'mobile',
        'platform': 'android',
        'deviceInfo': {
          'platform': 'android',
          'manufacturer': androidInfo.manufacturer,
          'model': androidInfo.model,
          'version': androidInfo.version.release,
        },
      };
    }
  }
}
