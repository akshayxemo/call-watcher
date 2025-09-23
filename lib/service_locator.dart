import 'package:call_watcher/data/repository/auth/auth_repository_impl.dart';
import 'package:call_watcher/data/repository/call_log/call_log_repository_impl.dart';
import 'package:call_watcher/data/repository/users/user_repository_impl.dart';
import 'package:call_watcher/domain/repository/auth.dart';
import 'package:call_watcher/domain/repository/call_log.dart';
import 'package:call_watcher/domain/repository/users.dart';
import 'package:call_watcher/domain/usecases/auth/signup_employee.dart';
import 'package:call_watcher/domain/usecases/call_log/get_last_call_log.dart';
import 'package:call_watcher/domain/usecases/call_log/get_past_seven_day_logs.dart';
import 'package:call_watcher/domain/usecases/call_log/update_log.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  serviceLocator.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  serviceLocator.registerSingleton<UsersRepository>(UserRepositoryImpl());
  serviceLocator
      .registerSingleton<SignupEmployeeUseCase>(SignupEmployeeUseCase());
  serviceLocator.registerSingleton<CallLogRepository>(CallLogRepositoryImpl());
  serviceLocator
      .registerSingleton<GetLastCallLogUseCase>(GetLastCallLogUseCase());
  serviceLocator
      .registerSingleton<UpdateCallLogsUseCase>(UpdateCallLogsUseCase());
  serviceLocator.registerSingleton<GetPastSevenDayLogs>(GetPastSevenDayLogs());
}
