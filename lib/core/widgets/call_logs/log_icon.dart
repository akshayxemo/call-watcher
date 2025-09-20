// import 'package:call_log/call_log.dart';
import 'package:call_watcher/core/config/enum.dart';
import 'package:flutter/material.dart';

class LogIcon extends StatelessWidget {
  final CallRecordType callType;
  final double? iconSize;
  const LogIcon({super.key, required this.callType, this.iconSize = 24});

  @override
  Widget build(BuildContext context) {
    switch (callType) {
      case CallRecordType.incoming:
        return Icon(
          Icons.call_received,
          color: Colors.green,
          size: iconSize,
        );
      case CallRecordType.outgoing:
        return Icon(
          Icons.call_made,
          color: Colors.blue,
          size: iconSize,
        );
      case CallRecordType.rejected:
        return Icon(
          Icons.call_end,
          color: Colors.red,
          size: iconSize,
        );
      case CallRecordType.missed:
        return Icon(
          Icons.call_missed,
          color: Colors.red,
          size: iconSize,
        );
      case CallRecordType.blocked:
        return Icon(
          Icons.block,
          color: Colors.red,
          size: iconSize,
        );
      case CallRecordType.wifiIncoming:
        return Icon(
          Icons.wifi_calling,
          color: Colors.green,
          size: iconSize,
        );
      case CallRecordType.wifiOutgoing:
        return Icon(
          Icons.wifi_calling,
          color: Colors.blue,
          size: iconSize,
        );
      case CallRecordType.voiceMail:
        return Icon(
          Icons.device_unknown,
          color: Colors.deepPurpleAccent,
          size: iconSize,
        );
      default:
        return Icon(
          Icons.device_unknown,
          color: Colors.amber,
          size: iconSize,
        );
    }
  }
}
