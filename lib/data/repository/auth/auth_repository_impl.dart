// import 'package:call_watcher/core/util/database.helper.dart';
import 'package:call_watcher/core/util/persistance_storage.helper.dart';
import 'package:call_watcher/data/models/employee.dart';
import 'package:call_watcher/domain/repository/auth.dart';
import 'package:call_watcher/domain/sqlite/users/users.sqlite.dart';
import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

class AuthRepositoryImpl implements AuthRepository {
  // final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<Either> employeeSignin(String email, String password) async {
    try {
      final user =
          await UsersStore().getUserByEmailAndPassword(email, password);
      if (user == null) {
        return left('Usr not found');
      }

      return right(user);
    } on DatabaseException catch (e) {
      return left('Database error: ${e.toString()}');
    } catch (e) {
      return left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either> employeeSignup(Employee employee) async {
    try {
      // Check if email already exists
      final existing = await UsersStore().getUserByEmail(employee.email);
      if (existing.isNotEmpty) {
        return left('Email already registered');
      }

      final userMap = <String, dynamic>{
        'name': employee.name,
        'email': employee.email,
        'password': employee.password,
      };

      final int id = await UsersStore().insertUser(userMap);

      return right(id);
    } on DatabaseException catch (e) {
      // Handle unique constraint or other DB issues
      if (e.isUniqueConstraintError()) {
        return left('Email already registered');
      }
      return left('Database error: ${e.toString()}');
    } catch (e) {
      return left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    // Not part of the current task.
    clearSession();
    return;
  }
}
