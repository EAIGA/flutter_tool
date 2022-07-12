import 'package:bybit_app_tools/src/core/base/tools_item_base.dart';
import 'package:bybit_app_tools/src/core/tools_list.dart';
import 'package:bybit_app_tools/src/core/ui/qr_scanner.dart';
import 'package:bybit_flutter_lifecycle/bybit_flutter_lifecycle.dart';
import 'package:flutter/material.dart';

class QRScannerTool extends ToolItemBase {
  @override
  Future<void> goToolPage(BuildContext context) async {
    UINavigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => QRScannerPage(),
    ),);
  }

  @override
  String get title => 'QRCodeScanner';

  @override
  ToolType get toolType => ToolType.QRScanner;

  @override
  IconData get iconData => Icons.camera_enhance_outlined;
}
