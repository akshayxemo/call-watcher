import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';

class LogView extends StatelessWidget {
  final CallLogEntry callLog;

  const LogView({super.key, required this.callLog});

  @override
  Widget build(BuildContext context) {
    final log = callLog;

    // Fallback for missing name and number
    final displayName = log.name ?? log.number ?? 'Unknown';
    final callType = log.callType?.toString() ?? 'Unknown';
    final duration =
        log.duration != null ? '${log.duration}s' : 'Unknown duration';
    final timestamp = log.timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(log.timestamp ?? 0)
        : DateTime.now();
    return  Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Type: $callType, Duration: $duration, Date: ${timestamp.toLocal()}',
          ),
        ],
      ),
    );
  }
}
