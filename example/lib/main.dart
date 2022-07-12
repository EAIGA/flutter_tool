import 'package:bui/bybit_app.dart';
import 'package:bybit_app_tools/bybit_app_tools.dart';
import 'package:flutter/material.dart';
import 'package:launch/launch.dart';
import 'package:service_manager/service_manager.dart';
import 'package:webview_module/webview_module.dart';

Future<void> main() async {
  runApp(RootPage(
      selectEnv: false,
      beforeLaunch: beforeLaunch,
      afterLaunch: afterLaunch,
      onGenerateRoute: onGenerateRoute));
}

/// 启动前在这里添加各模块的实现, 不要添加任何耗时操作
void beforeLaunch() {
  ServiceManager().addService<IRoot, IRootImpl>(IRootImpl());
  ServiceManager().addService<ILaunch, ILaunchImpl>(ILaunchImpl());
  ServiceManager().addService<IWebView, IWebViewImpl>(IWebViewImpl());

  for (IService service in ServiceManager().allServices()) service.beforeLaunch();

  UIRouteRegistry.register();
}

/// 这里添加启动页加载完成后的实现, 在跳转至Tab页前，把自己模块需要做的耗时操作在这里做完
Future<void> afterLaunch(BuildContext context) async {
  for (IService service in ServiceManager().allServices()) service.afterLaunch();
  Navigator.of(context).pushReplacement<dynamic, dynamic>(MaterialPageRoute<dynamic>(
    builder: (BuildContext context) => MyHomePage(title: 'Flutter Demo Home Page'),
  ));
}

/// 路由交由各模块内部自己处理
RouteFactory onGenerateRoute = (RouteSettings settings) {
  Route<dynamic>? route;
  for (IService service in ServiceManager().allServices()) {
    route = service.onGenerateRoute(settings);
    if (route != null) break;
  }
  return route;
};

class IRootImpl extends IRoot {
  @override
  void beforeLaunch() {}

  @override
  Future<void> afterLaunch() async {}

  @override
  Route<dynamic>? onGenerateRoute(RouteSettings settings) => null;

  @override
  RootTab currentTab() => RootTab.home;

  @override
  void jumpToTab(RootTab tabType, {Map<String, String>? params}) {}

  @override
  void registerPushRoutePath(String path, RouteHandle handle) {}

  @override
  void handleRoutePath(BuildContext context, String url) {}

  @override
  void unRegisterRoutePath(String path) {}

  @override
  Future<void> navigateToTab(BuildContext context) {
    return Future.sync(() => null);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    if (ToolsManager().isShowing) {
      ToolsManager().hideFloatView();
    } else {
      ToolsManager().showFloatView(context);
    }
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (ToolsManager().autoShow) {
        ToolsManager().showFloatView(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
