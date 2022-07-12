import 'package:bybit_app_tools/src/core/base/tools_item_base.dart';
import 'package:bybit_app_tools/src/core/tools_list.dart';
import 'package:bybit_app_tools/src/kits/performance_page.dart';
import 'package:bybit_flutter_lifecycle/bybit_flutter_lifecycle.dart';
import 'package:flutter/material.dart';

import '../../bybit_app_tools.dart';

class PerfOverlayTool extends ToolItemBase {
  @override
  Future<void> goToolPage(BuildContext context) async {
    if (UINavigator.canPop(context)) {
      UINavigator.pop(context);
    }

    ToolsManager().showChildFloating(context, PerformancePage(), iconData);
  }

  @override
  String get title => 'PerfOverlay';

  @override
  ToolType get toolType => ToolType.PerfOverlay;

  @override
  IconData get iconData => Icons.bar_chart_outlined;
}
