
import 'package:call_watcher/data/models/employee.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either> employeeSignin(String email, String password);
  Future<Either> employeeSignup(Employee employee);
  Future<void> logout();
}