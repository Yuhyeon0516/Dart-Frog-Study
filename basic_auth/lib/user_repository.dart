import 'package:basic_auth/user.dart';

Map<String, User> _users = {
  '1': const User(
    id: '1',
    username: 'user01',
    email: 'user01@gamil.com',
    password: '123456',
  ),
  '2': const User(
    id: '2',
    username: 'user02',
    email: 'user02@gmail.com',
    password: '123456',
  ),
};

class UserRepository {
  Future<User> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    final result = _users.values.any((user) => user.email == email);

    if (result) {
      throw Exception('Email already token');
    }

    final newUser = User.create(
      username: username,
      email: email,
      password: password,
    );

    _users[newUser.id] = newUser;

    return newUser.copyWith(password: () => null);
  }

  Future<User> signin({
    required String email,
    required String password,
  }) async {
    final users = _users.values
        .where((user) => user.email == email && user.password == password)
        .toList();

    if (users.isEmpty) {
      throw Exception('User not found');
    }

    return users.first.copyWith(password: () => null);
  }

  Future<User> findUserById(String id) async {
    final currentUser = _users[id];

    if (currentUser == null) {
      throw Exception('User with $id not found');
    }

    return currentUser.copyWith(password: () => null);
  }

  Future<User?> findUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final users = _users.values
        .where((user) => user.email == email && user.password == password)
        .toList();

    if (users.isNotEmpty) {
      return users.first.copyWith(password: () => null);
    }

    return null;
  }

  Future<User> updateUser({
    required String id,
    required String username,
  }) async {
    final currentUser = _users[id];

    if (currentUser == null) {
      throw Exception('User with $id not found');
    }

    final updateUser = currentUser.copyWith(username: username);

    _users[id] = updateUser;

    return updateUser.copyWith(password: () => null);
  }

  Future<void> deleteUser({
    required String id,
  }) async {
    if (_users[id] == null) {
      throw Exception('User with $id not found');
    }

    _users.remove(id);
  }
}
