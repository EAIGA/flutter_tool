import 'package:bybit_app_tools/src/core/base/tools_item_base.dart';
import 'package:bybit_app_tools/src/core/tools_list.dart';
import 'package:event_track_capture/event_track_capture.dart';
import 'package:flutter/material.dart';

class EventTrackHistoryTool extends ToolItemBase {
  @override
  Future<void> goToolPage(BuildContext context) async => navigatorToEventCapturePage(context);

  @override
  String get title => 'EventCapture';

  @override
  ToolType get toolType => ToolType.EventLogCapture;

  @override
  IconData get iconData => Icons.event_note_outlined;
}
