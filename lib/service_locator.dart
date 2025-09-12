import 'package:call_watcher/data/repository/auth/auth_repository_impl.dart';
import 'package:call_watcher/domain/repository/auth.dart';
import 'package:call_watcher/domain/usecases/auth/signup_employee.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  serviceLocator.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  serviceLocator
      .registerSingleton<SignupEmployeeUseCase>(SignupEmployeeUseCase());
}
