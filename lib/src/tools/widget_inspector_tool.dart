import 'package:bybit_app_tools/src/core/base/tools_item_base.dart';
import 'package:bybit_app_tools/src/core/tools_list.dart';
import 'package:bybit_flutter_lifecycle/bybit_flutter_lifecycle.dart';
import 'package:flutter/material.dart';
import 'package:widget_inspector/widget_inspector.dart';

import '../../bybit_app_tools.dart';

class WidgetInspectorTool extends ToolItemBase {
  @override
  Future<void> goToolPage(BuildContext context) async {
    UINavigator.of(context).pop();

    ToolsManager().showChildFloating(
      context,
      WidgetInfoInspector(
        globalKey: devToolRootKey,
      ),
      iconData,
    );
  }

  @override
  String get title => 'Widget Inspector';

  @override
  ToolType get toolType => ToolType.WidgetInspector;

  @override
  IconData get iconData => Icons.add_location_alt_rounded;
}
