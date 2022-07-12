import 'dart:ui' as ui;

import 'package:flutter/material.dart';

extension DoubleExt on double {
  static double get safeTop => MediaQueryData.fromWindow(ui.window).padding.top;

  static double get safeBottom => MediaQueryData.fromWindow(ui.window).padding.bottom;

  static double get safeLeft => MediaQueryData.fromWindow(ui.window).padding.left;

  static double get safeRight => MediaQueryData.fromWindow(ui.window).padding.right;

  static double get screenWidth => MediaQueryData.fromWindow(ui.window).size.width;

  static double get screenHeight => MediaQueryData.fromWindow(ui.window).size.height;
}
