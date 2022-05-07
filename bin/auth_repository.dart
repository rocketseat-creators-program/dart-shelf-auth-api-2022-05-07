import 'dart:convert';

import 'user_model.dart';

class AuthRepository {
  final users = <String, User>{};

  String _generateKey(String seed) => base64Encode(utf8.encode(seed));

  String? register(String name, String email, String password) {
    final newUser = User(name: name, email: email, password: password);

    final key = _generateKey(newUser.toString());

    if (users.containsKey(key)) {
      return null;
    }

    users[key] = newUser;

    return key;
  }

  String? login(String email, String password) {
    final key = _generateKey(email);

    final user = users[key];

    if (user != null && user.password == password) {
      return key;
    }

    return null;
  }

  User? getUser(String key) {
    final user = users[key];

    if (user != null) {
      return user;
    }

    return null;
  }
}
