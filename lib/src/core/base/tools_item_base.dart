import 'package:bybit_app_tools/src/core/tools_list.dart';
import 'package:flutter/material.dart';

abstract class ToolItemBase {
  String get title;

  ToolType get toolType;

  IconData iconData = Icons.build_circle_outlined;

  Future<void> goToolPage(BuildContext context);
}
