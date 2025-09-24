import 'package:call_watcher/data/models/employee.dart';

class PaginatedEmployeeResponse {
  final List<Employee?> data;
  final int totalPages;
  const PaginatedEmployeeResponse({
    required this.data,
    required this.totalPages,
  });
}
