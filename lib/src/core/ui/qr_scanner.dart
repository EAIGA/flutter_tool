import 'dart:io';

import 'package:bui/bybit_app.dart';
import 'package:bybit_flutter_lifecycle/bybit_flutter_lifecycle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foundation/foundation.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:service_manager/service_manager.dart';

enum QRScannerType {
  web,
  route,
  deep_link,
}

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // 官方demo里的代码
  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(),
          ),
          Positioned(
            right: 16.pt,
            top: 16.pt + (MediaQuery.of(context).padding.top),
            child: InkWell(
              onTap: _openResultPage,
              child: Container(
                width: 70.pt,
                height: 40.pt,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(180),
                  borderRadius: BorderRadius.circular(4.pt),
                ),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    '手动输入',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16.pt,
            top: 66.pt + (MediaQuery.of(context).padding.top),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  FullScreenPopRoute(child: ScanTips(), height: 280.pt),
                );
              },
              child: Container(
                width: 70.pt,
                height: 40.pt,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(180),
                  borderRadius: BorderRadius.circular(4.pt),
                ),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    '使用指南',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!mounted) return;
      setState(() {
        result = scanData;
        analyseScanDataType();
      });
    });
  }

  void analyseScanDataType() {
    String scanDataContent = result?.code ?? '';
    QRScannerType scannerType = QRScannerType.web;

    Uri u = Uri.parse(scanDataContent);
    String scheme = u.scheme;

    if (scheme == 'bybitapp') {
      scannerType = QRScannerType.deep_link;
    } else if (scheme == 'http' || scheme == 'https') {
      scannerType = QRScannerType.web;
    } else if (scheme == 'route') {
      scannerType = QRScannerType.route;
    }

    if (scannerType == QRScannerType.route) {
      _openRoutUrl();
    } else if (scannerType == QRScannerType.deep_link) {
      _openDeepLink();
    } else if (scannerType == QRScannerType.web) {
      _openResultPage();
    }
  }

  //TODO: 解析deep link
  void _openDeepLink() {
    controller?.stopCamera();
    UINavigator.pop(context);
    byService<IRoot>()?.handleRoutePath(context, result?.code ?? '');
  }

  //TODO: 解析rout url
  void _openRoutUrl() {
    Uri u = Uri.parse(result?.code ?? '');
    String page = u.path.substring(1);
    Map map = u.queryParameters;

    controller?.stopCamera();
    UINavigator.pop(context);
    ByNavigator.pushNamed(context, page, arguments: map);
  }

  void _openResultPage() {
    controller?.stopCamera();
    UINavigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => _QRScanResult(result?.code ?? ''),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class _QRScanResult extends StatefulWidget {
  const _QRScanResult(this.data, {Key? key}) : super(key: key);

  final String data;

  @override
  _QRScanResultState createState() => _QRScanResultState();
}

class _QRScanResultState extends State<_QRScanResult> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.text = widget.data;

    return Scaffold(
      appBar: AppBar(
        title: Text('扫描结果'),
      ),
      body: ChangeNotifierProvider<_QrHistoryNotifier>(
        create: (_) => _QrHistoryNotifier(),
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.only(left: 16.pt, top: 16.pt, right: 16.pt),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent.withAlpha(200)),
                          borderRadius: BorderRadius.circular(4.pt),
                        ),
                        padding: EdgeInsets.only(left: 3.pt, right: 3.pt, bottom: 2.pt),
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            hintText: '请输入跳转连接',
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.pt),
                    MaterialButton(
                      color: Colors.blue,
                      minWidth: 40.pt,
                      child: Text(
                        '打开',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () =>
                          context.read<_QrHistoryNotifier>().openUrl(context, controller.text),
                    ),
                  ],
                ),
                Expanded(child: _OpenHistoryList()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OpenHistoryList extends StatefulWidget {
  const _OpenHistoryList({Key? key}) : super(key: key);

  @override
  _OpenHistoryListState createState() => _OpenHistoryListState();
}

class _OpenHistoryListState extends State<_OpenHistoryList> {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<_QrHistoryNotifier>(context);
    // final notifier = context.select((_QrHistoryNotifier notifier) => notifier);
    if (notifier.value.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      children: [
        Row(
          children: [
            Text('历史记录'),
            Spacer(),
            IconButton(
              icon: Icon(Icons.clear_rounded),
              onPressed: _deleteHistory,
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            itemCount: notifier.value.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              return _QrOpenHistoryItem(text: notifier.value[index]);
            },
          ),
        )
      ],
    );
  }

  void _deleteHistory() {
    DialogManager().showActionDialog(title: '是否清除历史?', actions: <DialogAction>[
      DialogAction(title: '否', callback: () => UINavigator.pop(context)),
      DialogAction(
          title: '是',
          callback: () {
            final notifier = Provider.of<_QrHistoryNotifier>(context, listen: false);
            notifier.clear();
            UINavigator.pop(context);
          }),
    ]);
  }
}

class _QrOpenHistoryItem extends StatelessWidget {
  const _QrOpenHistoryItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<_QrHistoryNotifier>().openUrl(context, text),
      child: Container(
        alignment: Alignment.centerLeft,
        constraints: BoxConstraints(maxWidth: double.infinity, minHeight: 40.pt),
        child: Text(text),
      ),
    );
  }
}

class _QrHistoryNotifier extends ValueNotifier<List<String>> {
  static final String _qrOpenHistoryListBoxKey = '_dev_tools_qrOpenHistoryListBoxKey';

  _QrHistoryNotifier()
      : box = byService<ILaunch>()!.globalBox(),
        super(<String>[]) {
    _refreshValue();
  }

  final Box<dynamic>? box;

  void add(String text) {
    if (text.isEmpty) return;
    text = text.trim();
    if (value.contains(text)) {
      value.remove(text);
    }
    value.insert(0, text);
    box?.put(_qrOpenHistoryListBoxKey, value);
    _refreshValue();
  }

  void clear() {
    box?.delete(_qrOpenHistoryListBoxKey);
    _refreshValue();
  }

  Future<void> openUrl(BuildContext context, String text) async {
    if (text.isEmpty) {
      return;
    }

    if (!text.startsWith('http://') && !text.startsWith('https://')) {
      final Uri? uri = Uri.tryParse(text);
      if (uri?.queryParameters.isNotEmpty ?? false) {
        text = uri!.path;
      }
      try {
        ByNavigator.of(context).pushNamed(
          text,
          arguments: uri?.queryParameters,
        );
        add(uri?.toString() ?? text);
      } catch (e) {
        print(e);
        BToast.error('页面打开失败，请检查页面名称是否正确');
      }
      return;
    }
    add(text);
    byService<IWebView>()?.openWebView(buildContext: context, url: text, debuggingEnabled: true);
  }

  void _refreshValue() {
    if (box == null) return;
    final List<String> result = box?.get(_qrOpenHistoryListBoxKey, defaultValue: <String>[]);
    value = result.toList(growable: true);
  }
}

class ScanTips extends StatelessWidget {
  const ScanTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = BybitTheme.of<BaseTheme>(NavigatorService.context);
    return ByFullScreenPop(
      title: Text(
        '使用指南',
        style: TextStyle(
          fontSize: 16.pt,
          color: theme.grey2,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('样例: '),
            SizedBox(
              height: 5.pt,
            ),
            RichText(
              text: TextSpan(
                  text: 'route : route://bybit/',
                  style: TextStyle(color: theme.grey1),
                  children: [
                    TextSpan(
                      text: '{station-message-center}',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
            ),
            SizedBox(
              height: 5.pt,
            ),
            RichText(
              text: TextSpan(
                  text: 'link : bybitapp://open/',
                  style: TextStyle(color: theme.grey1),
                  children: [
                    TextSpan(
                      text: '{list2recharge}',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
            ),
            SizedBox(
              height: 5.pt,
            ),
            Text('web  : https://www.baidu.com?userId=88888'),
            SizedBox(
              height: 10.pt,
            ),
            RichText(
              text:
                  TextSpan(text: '根据不同的scheme区分', style: TextStyle(color: theme.grey1), children: [
                TextSpan(
                  text: '   route、deep link、web页面   ',
                  style: TextStyle(color: theme.bybitColor),
                ),
                TextSpan(
                  text: '   红色部分为各个类型注册标识',
                  style: TextStyle(color: Colors.red),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
