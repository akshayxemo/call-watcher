class Employee {
  final int? id;
  final String name;
  final String email;
  final String? password;

  Employee({
    this.id,
    required this.name,
    required this.email,
    this.password,
  });
}
