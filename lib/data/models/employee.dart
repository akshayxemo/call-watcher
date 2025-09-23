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

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      id: json["id"] as int,
      password: json["password"] as String,
    );
  }

  factory Employee.fromJsonSafe(Map<String, dynamic> json) {
    return Employee(
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      id: json["id"] as int,
    );
  }
}
