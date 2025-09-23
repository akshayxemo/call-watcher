import 'package:call_watcher/data/models/employee.dart';

abstract class UsersRepository {
  Future<List<Employee?>> getAllEmployees({int? page, int? limit, String? search});
}
