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

  Future<List<Map<String, dynamic>>> getAllUsers({
    int? page,
    int? limit,
    String? searchCharacter,
  }) async {
    final db = await _databaseHelper.database;
    List<Map<String, Object?>> result = [];
    List<dynamic> args = [];
    print("page: $page, limit: $limit, searchCharacter: $searchCharacter");

    if ((page == null || page <= 0) &&
        (limit == null || limit <= 0) &&
        searchCharacter == null) {
      print("Condition IF");
      result = await db.query('users');
    } else {
      print("Condition ELSE");
      final currentPage = page ?? 1;
      final pageSize = (limit ?? 10);
      final offset = (currentPage - 1) * pageSize;
      final search = searchCharacter ?? "";

      args.add(currentPage);
      args.add(offset);

      result = await db.query(
        'users',
        where: 'LOWER(name) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?)',
        whereArgs: ["%$search%", "%$search%"],
        limit: pageSize,
        offset: offset,
      );
    }

    if (result.isNotEmpty) {
      return result;
    } else {
      return [];
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
    print('Trying to login with: $email / $password');
    print('Query result: $result');
    if (result.isNotEmpty) {
      return result.first;
    } else {
      // Try to see if the email exists at all
      final emailResult =
          await db.query('users', where: 'email = ?', whereArgs: [email]);
      print('Email-only query result: $emailResult');
      return null;
    }
  }
}
