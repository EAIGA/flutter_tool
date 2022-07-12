import 'package:bui/bybit_app.dart';
import 'package:bybit_app_tools/src/core/base/tools_item_base.dart';
import 'package:bybit_app_tools/src/core/tools_list.dart';
import 'package:bybit_app_tools/src/utils/common_util.dart';
import 'package:bybit_flutter_lifecycle/bybit_flutter_lifecycle.dart';
import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';

class ToolMenuPage extends StatelessWidget {
  const ToolMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = getTextColor(context);
    return Container(
      height: DoubleExtension.screenHeight * 0.7,
      margin: EdgeInsets.only(top: 8.pt),
      child: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: defaultToolList.length,
        itemBuilder: (context, index) {
          ToolItemBase data = defaultToolList[index];
          return InkWell(
            onTap: () => data.goToolPage(context),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: textColor.withOpacity(0.05),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(data.iconData, size: 32, color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                    data.title,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                ],
              ),
            ),
          );
        },
        // ),
      ),
    );
  }
}

Future<void> showBottomDialog({
  required BuildContext context,
  required String title,
  required Widget child,
}) async {
  Color textColor = getTextColor(context);
  await DialogManager().showBottomModalDialog(
    minHeight: DoubleExtension.screenHeight * 0.6,
    maxHeight: DoubleExtension.screenHeight * 0.8,
    child: child,
    title: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.pt),
          height: 70.pt,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(12.pt))),
          alignment: Alignment.centerLeft,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(title, style: TextStyle(color: textColor, fontSize: 20.pt)),
            ),
            InkWell(
              onTap: () {
                if (UINavigator.of(context).canPop()) {
                  UINavigator.pop(context);
                }
              },
              child: Container(
                width: 30.pt,
                height: 30.pt,
                decoration: BoxDecoration(
                    color: textColor.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(20.pt))),
                alignment: Alignment.center,
                child: Icon(Icons.close, color: textColor, size: 16.pt),
              ),
            ),
          ]),
        ),
        const ByDivider(),
      ],
    ),
  );
}
