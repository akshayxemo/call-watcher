class Admin {
  final int? id;
  final String name;
  final String email;
  final String? password;

  Admin({
    this.id,
    required this.name,
    required this.email,
    this.password,
  });
}
