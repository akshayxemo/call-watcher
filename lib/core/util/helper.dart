import 'package:call_log/call_log.dart';
import 'package:call_watcher/core/config/enum.dart';
import 'package:call_watcher/data/models/call_log.dart';
import 'package:call_watcher/domain/entity/call_log/call_log.dart';

String formatDuration(int seconds) {
  int hours = seconds ~/ 3600; // Get hours
  int minutes = (seconds % 3600) ~/ 60; // Get minutes
  int remainingSeconds = seconds % 60; // Get remaining seconds

  // Build the formatted string
  String formattedDuration = '';

  if (hours > 0) {
    formattedDuration += '${hours}h ';
  }
  if (minutes > 0) {
    formattedDuration += '${minutes}m ';
  }
  if (remainingSeconds > 0 || formattedDuration.isEmpty) {
    formattedDuration += '${remainingSeconds}s';
  }

  return formattedDuration.trim();
}

CallRecordType mapToRecordType(CallType? t) {
  switch (t) {
    case CallType.incoming:
      return CallRecordType.incoming;
    case CallType.outgoing:
      return CallRecordType.outgoing;
    case CallType.rejected:
      return CallRecordType.rejected;
    case CallType.missed:
      return CallRecordType.missed;
    case CallType.voiceMail:
      return CallRecordType.voiceMail;
    case CallType.wifiIncoming:
      return CallRecordType.wifiIncoming;
    case CallType.wifiOutgoing:
      return CallRecordType.wifiOutgoing;
    case CallType.blocked:
      return CallRecordType.blocked;
    case CallType.unknown:
      return CallRecordType.unknown;
    case CallType.answeredExternally:
      return CallRecordType.answeredExternally;
    default:
      return CallRecordType.missed;
  }
}

List<CallLogRecord> callLogEntriesToRecordsObj(List<CallLogEntry> logs) {
  return logs.map((log) => CallLogRecord.fromCallLogEntry(log)).toList();
}

List<CallLogRecord> callLogsMapToRecordsObj(List<Map<String, dynamic>> logs) {
  return logs.map((log) => CallLogRecord.fromMap(log)).toList();
}

List<Map<String, dynamic>> callLogRecordsMap(List<CallLogRecord> logs) {
  return logs.map((log) => log.toMap()).toList();
}

List<Map<String, dynamic>> callLogRecordsMapWithoutId(
    List<CallLogRecord> logs) {
  return logs.map((log) => log.toMapWithoutId()).toList();
}

FormattedLogs getFormattedLogs(List<CallLogRecord> entries) {
  final DateTime now = DateTime.now().toLocal();

  final List<CallLogRecord> computedToday = entries.where((el) {
    if (el.date == 0) return false;
    final dt = DateTime.fromMillisecondsSinceEpoch(el.date).toLocal();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }).toList();

  final List<CallLogRecord> computedYesterday = entries.where((el) {
    if (el.date == 0) return false;
    final dt = DateTime.fromMillisecondsSinceEpoch(el.date).toLocal();
    return dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day - 1;
  }).toList();

  final List<CallLogRecord> computedOlder = entries.where((el) {
    if (el.date == 0) return false;
    final dt = DateTime.fromMillisecondsSinceEpoch(el.date).toLocal();
    return !(dt.year == now.year &&
        dt.month == now.month &&
        (dt.day == now.day || dt.day == now.day - 1));
  }).toList();

  return FormattedLogs(
    yesterdayLogs: computedYesterday,
    olderLogs: computedOlder,
    todayLogs: computedToday,
  );
}
