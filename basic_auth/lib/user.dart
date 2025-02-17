import 'package:basic_auth/typedefs.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.email,
    this.password,
  });

  factory User.create({
    required String username,
    required String email,
    required String password,
  }) {
    return User(
      id: uuid.v4(),
      username: username,
      email: email,
      password: password,
    );
  }

  final String id;
  final String username;
  final String email;
  final String? password;

  MapData toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  @override
  List<Object?> get props => [id, username, email, password];

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, password: $password)';
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? Function()? password,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password != null ? password() : this.password,
    );
  }
}
