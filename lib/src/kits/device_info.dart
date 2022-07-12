import 'dart:io';

import 'package:bui/bybit_app.dart';
import 'package:bybit_app_tools/src/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apm/flutter_apm.dart';
import 'package:foundation/foundation.dart';

class DeviceInfoPage extends StatefulWidget {
  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _deviceData = FlutterApm.shared().deviceInfo.all;
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = getTextColor(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Platform.isAndroid ? 'Android Device Info' : 'iOS Device Info'),
      ),
      body: ListView(
        children: _deviceData.keys.map((String property) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(12.pt),
                    child: Text(
                      property,
                      style: TextStyle(
                        fontSize: 16.pt,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(12.pt),
                      child: Text(
                        '${_deviceData[property]}',
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16.pt,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const ByDivider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
