import 'package:flutter/material.dart';
import 'package:bybit_data/bybit_data.dart';

class DataTypeMonitorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SafeArea(
        top: true,
        child: StreamBuilder<Set<DataType>>(
            initialData: TopicInstance.currentDataTypeSet,
            stream: TopicInstance.currentDataTypeStream,
            builder: (context, snapshot) {
              if (snapshot.data?.isNotEmpty == true) {
                final List<DataType> list = snapshot.data!.toList();
                return Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(
                          '${list[index]}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.green),
                        );
                      },
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                );
              }
              return SizedBox.shrink();
            }),
      ),
    );
  }
}
