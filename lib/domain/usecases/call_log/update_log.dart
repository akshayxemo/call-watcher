import 'package:call_watcher/core/usecase/usecase.dart';
import 'package:call_watcher/domain/entity/call_log/update_log.dart';
import 'package:call_watcher/domain/repository/call_log.dart';
import 'package:call_watcher/service_locator.dart';
import 'package:dartz/dartz.dart';

class UpdateCallLogsUseCase implements UseCase<Either<Exception, int>, UpdateLogParams> {
  @override
  Future<Either<Exception, int>> call({UpdateLogParams? params}) async {
    try {
      if (params == null) return left(Exception('Parameters cannot be null'));
      final result = await serviceLocator<CallLogRepository>()
          .registerLogsForEmployee(params.userId, params.callLogs);
      if (result.isLeft()) return left(Exception('Failed to register logs'));
      int noOfRowsEffected = result.fold((l) => 0, (r) => r);
      return right(noOfRowsEffected);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }
}
