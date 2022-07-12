import 'package:bybit_app_tools/src/core/base/tools_item_base.dart';
import 'package:bybit_flutter_lifecycle/bybit_flutter_lifecycle.dart';
import 'package:cts_testcase/testpages/entry.dart';
import 'package:flutter/material.dart';
import 'package:bybit_app_tools/src/core/tools_list.dart';
import 'package:service_manager/service_manager.dart';

class CtsTestCaseTool extends ToolItemBase {
  @override
  Future<void> goToolPage(BuildContext context) async {
    UINavigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => TestCaseEntry()),
    );
  }

  @override
  String get title {
    if (isCtsActive) {
      return "cts active";
    }
    return "cts(not active)";
  }

  @override
  ToolType get toolType => ToolType.CtsTestcase;

  @override
  IconData get iconData => isCtsActive ? Icons.airplanemode_active : Icons.airplanemode_inactive;

  bool get isCtsActive => byService<ILaunch>()?.isCtsSDKActive() ?? false;
}
