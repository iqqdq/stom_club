import 'package:flutter/material.dart';

enum DeviceHeight { small, large }

class DeviceDetector {
  DeviceHeight detectDeviceHeight() =>
      MediaQueryData.fromView(WidgetsBinding.instance.window).size.height <=
              700.0
          ? DeviceHeight.small
          : DeviceHeight.large;

  bool isLarge() => detectDeviceHeight() == DeviceHeight.large ? true : false;
}
