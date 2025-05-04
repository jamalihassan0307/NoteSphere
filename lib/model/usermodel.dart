// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names
// import 'dart:convert';

class UserModel {
  String id;

  String email;
  String password;
  UserModel({
    required this.id,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, email: $email, password: $password)';
}
