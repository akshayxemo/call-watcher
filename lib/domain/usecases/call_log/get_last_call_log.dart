import 'package:call_watcher/core/usecase/usecase.dart';
import 'package:call_watcher/data/models/call_log.dart';
import 'package:call_watcher/domain/repository/call_log.dart';
import 'package:call_watcher/service_locator.dart';

class GetLastCallLogUseCase implements UseCase<int, int> {
  @override
  Future<int> call({int? params}) async {
    try {
      if (params == null) return 0;
      final recordStatus =
          await serviceLocator<CallLogRepository>().lastEntryEmployeeId(params);
      final CallLogRecord? lastRecord = recordStatus.fold(
        (left) => null,
        (right) => right,
      );
      if (lastRecord == null) return 0;
      return lastRecord.date;
    } catch (error) {
      return 0;
    }
  }
}
