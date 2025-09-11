// import 'package:call_log/call_log.dart';
import 'package:call_watcher/core/config/enum.dart';
import 'package:flutter/material.dart';

class LogIcon extends StatelessWidget {
  final CallRecordType callType;
  const LogIcon({super.key, required this.callType});

  @override
  Widget build(BuildContext context) {
    switch (callType) {
      case CallRecordType.incoming:
        return const Icon(Icons.call_received, color: Colors.green,);
      case CallRecordType.outgoing:
        return const Icon(Icons.call_made, color: Colors.blue,);
      case CallRecordType.rejected:
        return const Icon(Icons.call_end, color: Colors.red,);
      case CallRecordType.missed:
        return const Icon(Icons.call_missed, color: Colors.red,);
      case CallRecordType.blocked:
        return const Icon(Icons.block, color: Colors.red,);
      case CallRecordType.wifiIncoming:
        return const Icon(Icons.wifi_calling, color: Colors.green,);
      case CallRecordType.wifiOutgoing:
        return const Icon(Icons.wifi_calling, color: Colors.blue,);
      case CallRecordType.unknown:
        return const Icon(Icons.device_unknown, color: Colors.amber,);
      case CallRecordType.answeredExternally:
        return const Icon(Icons.device_unknown, color: Colors.amber,);
      case CallRecordType.voiceMail:
        return const Icon(Icons.device_unknown, color: Colors.deepPurpleAccent,);
    }
  }
}
