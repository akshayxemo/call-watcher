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
  Future<Either<Exception, Map<String, dynamic>?>> employeeSignin(
      String email, String password) async {
    try {
      final allUser = await UsersStore().getAllUsers();
      allUser.map((el) => print("User ->>>> :  ${el.toString()}"));
      final user =
          await UsersStore().getUserByEmailAndPassword(email, password);
      if (user == null) {
        return left(Exception('User Not Found'));
      }

      return right(user);
    } on DatabaseException catch (e) {
      return left(Exception('Database error: ${e.toString()}'));
    } catch (e) {
      return left(Exception('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, int>> employeeSignup(Employee employee) async {
    try {
      // Check if email already exists
      final existing = await UsersStore().getUserByEmail(employee.email);
      if (existing.isNotEmpty) {
        return left(Exception('Email already registered'));
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
        return left(Exception('Email already registered'));
      }
      return left(Exception('Database error: ${e.toString()}'));
    } catch (e) {
      return left(Exception('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<void> logout() async {
    // Not part of the current task.
    clearSession();
    return;
  }
}
