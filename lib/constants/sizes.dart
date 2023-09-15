import 'dart:io';
import 'package:stom_club/components/device_detector.dart';

abstract class Sizes {
  static double tabControllerHeight = Platform.isAndroid
      ? 68.0
      : DeviceDetector().isLarge()
          ? 88.0
          : 68.0;

  static double appBarHeight = 64.0;
  static double indicatorHeight = DeviceDetector().isLarge() ? 40.0 : 50.0;
}
