import 'package:call_watcher/data/models/employee.dart';
import 'package:call_watcher/domain/entity/employee/employee.dart';

abstract class UsersRepository {
  Future<List<Employee?>> getAllEmployees({int? page, int? limit, String? search});
  Future<PaginatedEmployeeResponse?> getAllEmployeesPaginatedResponse(
      {int page, int limit, String? search});
}
