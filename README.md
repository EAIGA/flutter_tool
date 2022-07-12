# app_tools

app dev tools for debug

## Getting Started

### Install
```
app_tools
    hosted:
      name: app_tools
      url: https://unpub.bybit.com
    version: ^1.0.0
```

### 初始化
`ToolsManager().init()`

### 显示全局悬浮球
`ToolsManager().showFloatView(context)`

### 关闭全局悬浮球
`ToolsManager().hideFloatView()`

### 添加新的工具
  * 继承ToolItemBase
  * core/tools_list.dart 添加相应的枚举，将实现类加入list

```
class HiveMonitorTool extends ToolItemBase {
  @override
  Future<void> goToolPage(BuildContext context) async =>
      HiveMonitor().navigatorToHiveDataPage(context);

  @override
  String get title => 'HiveMonitor';

  @override
  ToolType get toolType => ToolType.HiveMonitor;

  @override
  IconData get iconData => Icons.data_usage_outlined;
}
```


