import 'package:call_watcher/data/models/call_log.dart';

class UpdateLogParams {
  final List<CallLogRecord> callLogs;
  final int userId;

  UpdateLogParams({
    required this.callLogs,
    required this.userId,
  });
}
class GetLogParams {
  final int? date;
  final int userId;

  GetLogParams({
    this.date,
    required this.userId,
  });
}
