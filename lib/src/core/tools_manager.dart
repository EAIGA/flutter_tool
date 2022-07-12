import 'package:bybit_app_tools/src/utils/sp_util.dart';
import 'package:event_track_capture/event_track_capture.dart';
import 'package:flutter/material.dart';
import 'package:hive_monitor/hive_monitor.dart';
import 'package:network_capture/network_capture.dart';

import 'ui/floating_widget.dart';

class ToolsManager {
  ToolsManager._();

  factory ToolsManager() => _instance ??= ToolsManager._();
  static ToolsManager? _instance;

  late OverlayEntry _overlayEntry;

  //是否正在显示
  bool isShowing = false;
  final SPUtil _spUtil = SPUtil();

  //启动时是否自动显示
  bool autoShow = true;

  Future<void> init() async {
    NetworkCapture().init();
    HiveMonitor().init();
    EventTrackCapture().init();
    autoShow = await _spUtil.getFloatingStatus();
  }

  void startOrEnd(BuildContext context) {
    if (isShowing) {
      hideFloatView();
    } else {
      showFloatView(context);
    }
  }

  void showFloatView(BuildContext context) {
    if(isShowing) return;
    OverlayState? overlayState = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(builder: (BuildContext context) => FloatingWidget());
    overlayState?.insert(_overlayEntry);
    autoShow = isShowing = true;
    _saveToSharedPref();
  }

  void showChildFloating(BuildContext context, Widget child, IconData icon) {
    _overlayEntry.remove();

    OverlayState? overlayState = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => FloatingWidget(
        functionView: child,
        functionIcon: icon,
      ),
    );
    overlayState?.insert(_overlayEntry);
  }

  void hideFloatView() {
    _overlayEntry.remove();
    autoShow = isShowing = false;
    _saveToSharedPref();
  }

  void _saveToSharedPref() {
    _spUtil.saveFloatingStatus(autoShow);
  }
}
