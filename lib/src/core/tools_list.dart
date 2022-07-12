import 'package:bybit_app_tools/src/core/base/tools_item_base.dart';
import 'package:bybit_app_tools/src/tools/cts_testcase_tool.dart';
import 'package:bybit_app_tools/src/tools/device_info_tool.dart';
import 'package:bybit_app_tools/src/tools/device_type_tool.dart';
import 'package:bybit_app_tools/src/tools/event_track_capture_tool.dart';
import 'package:bybit_app_tools/src/tools/hive_monitor_tool.dart';
import 'package:bybit_app_tools/src/tools/network_capture_tool.dart';
import 'package:bybit_app_tools/src/tools/performance_tool.dart';
import 'package:bybit_app_tools/src/tools/qr_scanner_tool.dart';
import 'package:bybit_app_tools/src/tools/widget_inspector_tool.dart';

enum ToolType {
  NetworkCapture,
  HiveMonitor,
  EventLogCapture,
  QRScanner,
  WidgetInspector,
  PerfOverlay,
  DeviceInfo,
  CtsTestcase,
}

List<ToolItemBase> defaultToolList = [
  NetworkCaptureTool(),
  HiveMonitorTool(),
  EventTrackHistoryTool(),
  QRScannerTool(),
  WidgetInspectorTool(),
  PerfOverlayTool(),
  DeviceInfoTool(),
  DataTypeTool(),
  CtsTestCaseTool()
];
