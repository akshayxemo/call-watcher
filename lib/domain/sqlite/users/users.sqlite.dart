import 'package:call_watcher/core/util/database.helper.dart';
import 'package:sqflite/sqflite.dart';

class UsersStore {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  Future<DatabaseHelper> get dbHelper async => _databaseHelper;

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await _databaseHelper.database;
    return await db.insert('users', user,
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    final db = await _databaseHelper.database;
    final result =
        await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await _databaseHelper.database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmailAndPassword(
      String email, String password) async {
    final db = await _databaseHelper.database;
    final result = await db.query('users',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
