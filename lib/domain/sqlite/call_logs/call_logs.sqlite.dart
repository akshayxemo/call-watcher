import 'package:call_watcher/core/util/database.helper.dart';
import 'package:sqflite/sqflite.dart';

class CallLogsStore {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  Future<DatabaseHelper> get dbHelper async => _databaseHelper;
  Future<int> insertCallLog(Map<String, dynamic> callLog) async {
    final db = await _databaseHelper.database;
    return await db.insert('call_logs', callLog);
  }

  Future<List<Map<String, dynamic>>> getAllCallLogsByUserId(int userId) async {
    final db = await _databaseHelper.database;
    return await db
        .query('call_logs', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getCallLogsByUserIdAndDateRangePaginated(
      int userId, int startDate, int endDate, int page, int pageSize) async {
    final db = await _databaseHelper.database;
    return await db.query('call_logs',
        where: 'user_id = ? AND date BETWEEN ? AND ?',
        whereArgs: [userId, startDate, endDate],
        orderBy: 'date DESC',
        limit: pageSize,
        offset: (page - 1) * pageSize);
  }

  Future<Map<String, dynamic>> getCallLogsPaginated({
    int? userId,
    int? startDate,
    int? endDate,
    int page = 1,
    int pageSize = 10,
  }) async {
    final db = await _databaseHelper.database;
    final offset = (page - 1) * pageSize;

    // Build WHERE clause and args dynamically
    List<String> whereClauses = ['call_logs.user_id IS NOT NULL'];
    List<dynamic> args = [];

    if (userId != null) {
      whereClauses.add('call_logs.user_id = ?');
      args.add(userId);
    }
    if (startDate != null && endDate != null) {
      whereClauses.add('call_logs.date BETWEEN ? AND ?');
      args.add(startDate);
      args.add(endDate);
    }

    String whereString = whereClauses.join(' AND ');

    args.add(pageSize);
    args.add(offset);

    final result = await db.rawQuery('''
      SELECT 
        call_logs.id, 
        call_logs.number, 
        call_logs.formattedNumber, 
        call_logs.type, 
        call_logs.date, 
        call_logs.duration, 
        call_logs.sim, 
        users.id AS user_id, 
        users.name AS user_name
      FROM call_logs
      LEFT JOIN users ON call_logs.user_id = users.id
      WHERE $whereString
      ORDER BY call_logs.date DESC
      LIMIT ? OFFSET ?
    ''', args);

    final totalCountResult = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM call_logs
      LEFT JOIN users on call_logs.user_id = users.id
      WHERE $whereString
    ''', args.sublist(0, args.length - 2)); // Remove LIMIT and OFFSET from args

    final totalCount = totalCountResult.first['count'] as int;

    return {
      'data': result,
      'totalCount': totalCount,
    };
  }

  Future<List<Map<String, dynamic>>> getCallLogsByUserIdPaginated(
    int userId,
    int page,
    int pageSize,
  ) async {
    final db = await _databaseHelper.database;
    return await db.query('call_logs',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC',
        limit: pageSize,
        offset: (page - 1) * pageSize);
  }

  Future<Map<String, dynamic>?> getLastCallLogByUserId(int userId) async {
    final db = await _databaseHelper.database;
    final result = await db.query('call_logs',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC',
        limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<int> insertCallLogsBatch(
      List<Map<String, dynamic>> callLogs, int userId) async {
    final db = await _databaseHelper.database;
    Batch batch = db.batch();
    for (var log in callLogs) {
      print('Entered Batch result: ${log.toString()} $userId');
      batch.insert('call_logs', {...log, 'user_id': userId});
    }
    List<dynamic> results = await batch.commit(noResult: false);
    return results.length;
  }
}
