import 'dart:io';
import 'package:stom_club/components/device_detector.dart';
import 'package:flutter/widgets.dart';

class Sizes {
  static double tabControllerHeight(BuildContext context) => Platform.isAndroid
      ? 68.0
      : DeviceDetector.isLarge(context)
          ? 88.0
          : 68.0;

  static double appBarHeight = 64.0;

  static double indicatorHeight(BuildContext context) =>
      DeviceDetector.isLarge(context) ? 40.0 : 50.0;
}
