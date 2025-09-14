import 'package:call_watcher/data/models/call_log.dart';
import 'package:dartz/dartz.dart';

abstract class CallLogRepository {
  Future<Either<Exception, CallLogRecord?>> lastEntryEmployeeId(int id);
  Future<Either<Exception, int>> registerLogsForEmployee(
      int employeeId, List<CallLogRecord> records);
  Future<List<CallLogRecord>?> getCallLogEntriesByEmployeeId(
    int employeeId,
    int requestedPage,
    int pageSize,
  );
}
