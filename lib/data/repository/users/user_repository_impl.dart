import 'package:call_watcher/data/models/employee.dart';
import 'package:call_watcher/domain/repository/users.dart';
import 'package:call_watcher/domain/sqlite/users/users.sqlite.dart';

class UserRepositoryImpl implements UsersRepository {
  @override
  Future<List<Employee?>> getAllEmployees(
      {int? page, int? limit, String? search}) async {
    try {
      print("page: $page, limit: $limit, search: $search");
      List<Map<String, Object?>> response = await UsersStore()
          .getAllUsers(limit: limit, page: page, searchCharacter: search);
      final List<Employee> employee = response
          .map((e) => Employee.fromJsonSafe(e))
          .whereType<Employee>() // drops nulls
          .toList();
      return employee;
    } catch (error) {
      print(error.toString());
      return [];
    }
  }
}
