import 'package:call_watcher/core/util/helper.dart';
import 'package:call_watcher/data/models/call_log.dart';
import 'package:call_watcher/domain/entity/call_log/call_log.dart';
import 'package:call_watcher/domain/repository/call_log.dart';
import 'package:call_watcher/domain/sqlite/call_logs/call_logs.sqlite.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class CallLogRepositoryImpl implements CallLogRepository {
  @override
  Future<Either<Exception, CallLogRecord?>> lastEntryEmployeeId(int id) async {
    try {
      final Map<String, dynamic>? lastCallLog =
          await CallLogsStore().getLastCallLogByUserId(id);
      if (lastCallLog == null) return right(null);
      final CallLogRecord callRecord = CallLogRecord.fromMap(lastCallLog);
      return right(callRecord);
    } catch (e) {
      debugPrint(e.toString());
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, int>> registerLogsForEmployee(
      int employeeId, List<CallLogRecord> records) async {
    try {
      final List<Map<String, dynamic>> logs =
          callLogRecordsMapWithoutId(records);
      final int result =
          await CallLogsStore().insertCallLogsBatch(logs, employeeId);

      return right(result);
    } catch (e) {
      debugPrint(e.toString());
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<List<CallLogRecord>?> getCallLogEntriesByEmployeeId(
    int employeeId,
    int requestedPage,
    int pageSize,
  ) async {
    try {
      print(
          "getCallLogEntriesByEmployeeId [ called ] :  $employeeId, $requestedPage, $pageSize");
      final List<Map<String, dynamic>> logs = await CallLogsStore()
          .getCallLogsByUserIdPaginated(employeeId, requestedPage, pageSize);
      print(
          "getCallLogEntriesByEmployeeId [ called ] :  is empty? :  ${logs.isEmpty} : ${logs.length} : $logs");
      if (logs.isEmpty) return null;
      final List<CallLogRecord> records = callLogsMapToRecordsObj(logs);
      return records;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<PaginatedCallLogsResponse?> getCallLogsPaginated({
    int? userId,
    int? startDate,
    int? endDate,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      print(
          "userid: $userId, startDate: $startDate, endDate: $endDate, page: $page, pageSize: $pageSize");
      final Map<String, dynamic> logs =
          await CallLogsStore().getCallLogsPaginated(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
        page: page,
        pageSize: pageSize,
      );

      print(logs);

      if (logs["totalCount"] <= 0) return null;
      if (logs["data"].isEmpty) return null;

      final List<CallLogRecord> records = callLogsMapToRecordsObj(logs["data"]);
      final int count = logs["totalCount"] as int;
      return PaginatedCallLogsResponse(logs: records, totalCount: count);
    } catch (error) {
      print("error occured: ${error.toString()}");
      return null;
    }
  }
}
