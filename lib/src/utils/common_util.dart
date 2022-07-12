import 'package:flutter/material.dart';

Color getTextColor(BuildContext context) {
  final isLight = Theme.of(context).brightness == Brightness.light;
  return isLight ? Colors.black54 : Colors.white60;
}

final String iconData =
    r'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';
