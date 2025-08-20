import 'package:flutter/widgets.dart';

enum DeviceHeight { small, large }

class DeviceDetector {
  static DeviceHeight detectDeviceHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return height <= 700.0 ? DeviceHeight.small : DeviceHeight.large;
  }

  static bool isLarge(BuildContext context) {
    return detectDeviceHeight(context) == DeviceHeight.large;
  }
}
