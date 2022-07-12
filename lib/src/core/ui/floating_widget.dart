import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bybit_app_tools/bybit_app_tools.dart';
import 'package:bybit_app_tools/src/core/ui/tool_menu_page.dart';
import 'package:bybit_app_tools/src/utils/common_util.dart';
import 'package:bybit_flutter_lifecycle/bybit_flutter_lifecycle.dart';
import 'package:flutter/material.dart';

class FloatingWidget extends StatefulWidget {
  FloatingWidget({
    Key? key,
    this.functionView,
    this.functionIcon,
  }) : super(key: key);

  final Widget? functionView;
  final IconData? functionIcon;

  @override
  _FloatingWidgetState createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget> {
  double _dx = 0;
  double _dy = 0;
  bool _isShowMenu = false;
  final double _margin = 8.0;
  final Size floatSize = Size(50.0, 50.0);
  final Size _windowSize = MediaQueryData.fromWindow(ui.window).size;
  late Uint8List bytes;

  Widget? _functionView;

  @override
  void initState() {
    super.initState();
    _dx = _windowSize.width - floatSize.width - _margin;
    _dy = _windowSize.height - floatSize.height - _margin * 10;
    bytes = base64.decode(iconData);
    _functionView = widget.functionView;
  }

  @override
  void dispose() {
    ToolsManager().isShowing = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = getTextColor(context);
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: _windowSize.width,
        height: _windowSize.height,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            _functionView ?? Container(),
            Positioned(
              left: _dx,
              top: _dy,
              child: GestureDetector(
                onTap: () => onTap(textColor),
                onVerticalDragEnd: dragEnd,
                onHorizontalDragEnd: dragEnd,
                onHorizontalDragUpdate: dragEvent,
                onVerticalDragUpdate: dragEvent,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: textColor,
                    boxShadow: [
                      BoxShadow(
                        color: textColor.withOpacity(0.3),
                        offset: Offset(0.0, 0.0),
                        blurRadius: 2.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  width: floatSize.width,
                  height: floatSize.height,
                  child: _functionView != null
                      ? Icon(
                          widget.functionIcon,
                          color: Colors.red,
                        )
                      : Image.memory(bytes),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onTap(Color textColor) async {
    if (_functionView != null) {
      setState(() {
        _functionView = null;
      });
      return;
    }

    if (_isShowMenu) {
      UINavigator.pop(context);
      return;
    }
    _isShowMenu = true;
    await showBottomDialog(
      context: context,
      title: 'Tools',
      child: ToolMenuPage(),
    );
    _isShowMenu = false;
  }

  void dragEvent(DragUpdateDetails details) {
    _dx = details.globalPosition.dx - floatSize.width / 2;
    _dy = details.globalPosition.dy - floatSize.height / 2;
    setState(() {});
  }

  void dragEnd(DragEndDetails details) {
    if (_dx + floatSize.width / 2 < _windowSize.width / 2) {
      _dx = _margin;
    } else {
      _dx = _windowSize.width - floatSize.width - _margin;
    }

    if (_dy + floatSize.height > _windowSize.height) {
      _dy = _windowSize.height - floatSize.height - _margin;
    } else if (_dy < 0) {
      _dy = _margin;
    }
    setState(() {});
  }
}
