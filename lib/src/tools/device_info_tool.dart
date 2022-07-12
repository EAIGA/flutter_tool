import 'package:bybit_app_tools/src/core/base/tools_item_base.dart';
import 'package:bybit_app_tools/src/core/tools_list.dart';
import 'package:bybit_app_tools/src/kits/device_info.dart';
import 'package:bybit_flutter_lifecycle/bybit_flutter_lifecycle.dart';
import 'package:flutter/material.dart';

class DeviceInfoTool extends ToolItemBase {
  @override
  Future<void> goToolPage(BuildContext context) async {
    UINavigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => DeviceInfoPage()),
    );
  }

  @override
  String get title => 'DeviceInfo';

  @override
  ToolType get toolType => ToolType.DeviceInfo;

  @override
  IconData get iconData => Icons.perm_device_info_rounded;
}
