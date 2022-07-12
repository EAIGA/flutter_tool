import 'package:flutter/material.dart';

class PerformancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SizedBox(
        child: PerformanceOverlay.allEnabled(),
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
