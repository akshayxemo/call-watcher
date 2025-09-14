import 'package:call_watcher/core/usecase/usecase.dart';
import 'package:call_watcher/data/models/employee.dart';
import 'package:call_watcher/domain/repository/auth.dart';
import 'package:call_watcher/service_locator.dart';
import 'package:dartz/dartz.dart';

class SignupEmployeeUseCase
    implements UseCase<Either<Exception, int>, Employee> {
  @override
  Future<Either<Exception, int>> call({Employee? params}) async {
    if (params == null) return left(Exception("Employee is null"));
    return serviceLocator<AuthRepository>().employeeSignup(params);
  }
}
