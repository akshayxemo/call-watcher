import 'package:call_watcher/data/models/admin.dart';
import 'package:call_watcher/data/models/employee.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> persistSession({
  required int userId,
  required String name,
  required String email,
  required String role,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('user_id', userId);
  await prefs.setString('user_name', name);
  await prefs.setString('user_email', email);
  await prefs.setString('user_role', role);
}

Future<bool> hasValidSession() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('user_id') && prefs.containsKey('user_email');
}

Future<void> clearSession() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_id');
  await prefs.remove('user_name');
  await prefs.remove('user_email');
  await prefs.remove('user_role');
}

Future<Map<String, dynamic>?> getCurrentSessionData() async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('user_id') || !prefs.containsKey('user_email')) {
    return null;
  }
  
  return {
    'id': prefs.getInt('user_id'),
    'name': prefs.getString('user_name'),
    'email': prefs.getString('user_email'),
    'role': prefs.getString('user_role'),
  };
}

Future<Employee> getCurrentEmployeeFromSessionData() async {
  final prefs = await SharedPreferences.getInstance();

  final int id = prefs.getInt("user_id") ?? 0;
  final String name = prefs.getString("user_name") ?? "";
  final String email = prefs.getString("user_email") ?? "";

  return Employee(id: id, name: name, email: email);
}

Future<Admin> getCurrentEAdminFromSessionData() async {
  final prefs = await SharedPreferences.getInstance();

  final int id = prefs.getInt("user_id") ?? 0;
  final String name = prefs.getString("user_name") ?? "";
  final String email = prefs.getString("user_email") ?? "";

  return Admin(id: id, name: name, email: email);
}
