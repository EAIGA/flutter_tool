import 'package:bybit_app_tools/src/utils/double_extension.dart';
import 'package:bybit_flutter_lifecycle/bybit_flutter_lifecycle.dart';
import 'package:flutter/material.dart';

class FullScreenPopRoute extends ModalRoute<dynamic> {
  FullScreenPopRoute({
    required this.child,
    this.height,
    this.bgColor = Colors.black12,
    RouteSettings? settings,
  }) : super(settings: settings) {
    progressHeight = height ?? progressHeight;
    marginTop = height == null ? marginTop : DoubleExt.screenHeight - DoubleExt.safeTop - height!;
    if (marginTop < 0) marginTop = 0;
  }

  static const String heightKey = 'height';

  final Widget child;
  final double? height;
  final Color bgColor;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.grey.withOpacity(0.2);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  double? beginOffsetY;
  double? dismissProgress;
  double progressHeight = DoubleExt.screenHeight - DoubleExt.safeTop - 20;
  Function? dismissCallback;
  double marginTop = 100;

  @override
  Widget buildPage(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    dismissCallback = () {
      UINavigator.of(context).pop();
    };
    return Material(
      type: MaterialType.transparency,
      color: bgColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: InkWell(
            onTap: () => UINavigator.pop(context),

            ///点击外部退出
            child: Container(
              padding: EdgeInsets.only(top: marginTop),
              child: PhysicalModel(
                color: bgColor,
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                clipBehavior: Clip.antiAlias,
                child: GestureDetector(
                  onVerticalDragDown: _onVerticalDragDown,
                  onVerticalDragUpdate: _onVerticalDragUpdate,
                  onVerticalDragEnd: _onVerticalDragEnd,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: child,
    );
  }

  void _onVerticalDragDown(DragDownDetails details) {
    beginOffsetY = details.localPosition.dy;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (beginOffsetY != null) {
      dismissProgress =
          ((details.localPosition.dy - beginOffsetY!) / progressHeight).clamp(0.0, 1.0).toDouble();
      controller?.animateTo(1.0 - dismissProgress!, duration: Duration.zero);
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (dismissProgress == null) return;
    if (dismissProgress! > 0.3 || details.velocity.pixelsPerSecond.dy > 200) {
      dismissCallback?.call();
    } else {
      controller?.animateTo(1.0);
    }
  }
}
