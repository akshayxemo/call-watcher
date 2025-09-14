import 'package:call_log/call_log.dart';
import 'package:call_watcher/core/usecase/usecase.dart';
import 'package:call_watcher/core/util/helper.dart';
import 'package:call_watcher/domain/entity/call_log/call_log.dart';
import 'package:flutter/material.dart';

class GetPastSevenDayLogs implements UseCase<FormattedLogs?, DateTime?> {
  @override
  Future<FormattedLogs?> call({DateTime? params}) async {
    try {
      // Yes, this is correct. By passing the last entry time from your DB as 'params',
      // this will fetch all call log entries from just after that time up to now.
      // If 'params' is null, it defaults to the past 7 days.
      final Iterable<CallLogEntry> entries = await CallLog.query(
        dateTimeFrom: params != null
            ? params.add(const Duration(seconds: 1))
            : DateTime.now().subtract(const Duration(days: 7)),
        dateTimeTo: DateTime.now(),
      );
      return getFormattedLogs(callLogEntriesToRecordsObj(entries.toList()));
    } catch (error) {
      // Handle errors if any
      debugPrint("Error fetching call logs: $error");
      return null;
    }
  }
}
