import 'package:call_watcher/data/models/call_log.dart';

class FormattedLogs {
  final List<CallLogRecord> todayLogs;
  final List<CallLogRecord> yesterdayLogs;
  final List<CallLogRecord> olderLogs;

  FormattedLogs({
    required this.yesterdayLogs,
    required this.olderLogs,
    required this.todayLogs,
  });
}

class PaginatedCallLogsResponse {
  final List<CallLogRecord> logs;
  final int totalCount;

  PaginatedCallLogsResponse({
    required this.logs,
    required this.totalCount,
  });
}
