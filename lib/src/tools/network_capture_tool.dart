import 'package:bybit_app_tools/src/core/base/tools_item_base.dart';
import 'package:bybit_app_tools/src/core/tools_list.dart';
import 'package:flutter/material.dart';
import 'package:network_capture/network_capture.dart';

class NetworkCaptureTool extends ToolItemBase {
  @override
  Future<void> goToolPage(BuildContext context) async => navigatorToCapturePage(context);

  @override
  String get title => 'NetworkCapture';

  @override
  ToolType get toolType => ToolType.NetworkCapture;

  @override
  IconData get iconData => Icons.https_outlined;
}
