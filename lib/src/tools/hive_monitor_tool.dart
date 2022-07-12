import 'package:bybit_app_tools/src/core/base/tools_item_base.dart';
import 'package:bybit_app_tools/src/core/tools_list.dart';
import 'package:bybit_flutter_lifecycle/bybit_flutter_lifecycle.dart';
import 'package:flutter/material.dart';
import 'package:hive_monitor/hive_monitor.dart';

class HiveMonitorTool extends ToolItemBase {
  @override
  Future<void> goToolPage(BuildContext context) async =>
      UINavigator.push(context, MaterialPageRoute(builder: (_) => HiveDataPage()));

  @override
  String get title => 'HiveMonitor';

  @override
  ToolType get toolType => ToolType.HiveMonitor;

  @override
  IconData get iconData => Icons.data_usage_outlined;
}
