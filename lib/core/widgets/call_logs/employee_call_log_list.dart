import 'package:call_watcher/core/widgets/call_logs/log_view.dart';
import 'package:call_watcher/data/models/call_log.dart';
import 'package:flutter/material.dart';

class EmployeeCallLogList extends StatelessWidget {
  final List<CallLogRecord> callLogs;
  final String label;
  const EmployeeCallLogList({
    super.key,
    required this.callLogs,
    this.label = "Older",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6.0)),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            label,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: callLogs.length,
          itemBuilder: (context, index) {
            // print(
            //     "->>>>>>>>>>>>>>>>>>>> : ${callLogs.elementAt(index).toMap()}");
            return LogView(callLog: callLogs.elementAt(index));
          },
        ),
      ],
    );
  }
}
