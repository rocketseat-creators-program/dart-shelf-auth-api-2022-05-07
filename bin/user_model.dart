import 'dart:convert';

class User {
  final String name;
  final String email;
  final String password;

  User({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  String toString() => email;

  toJson() => jsonEncode(
        {
          'email': email,
          'name': name,
        },
      );
}
