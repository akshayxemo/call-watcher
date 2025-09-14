
import 'package:call_watcher/data/models/employee.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Exception, Map<String, dynamic>?>> employeeSignin(
      String email, String password);
  Future<Either<Exception, int>> employeeSignup(Employee employee);
  Future<void> logout();
}