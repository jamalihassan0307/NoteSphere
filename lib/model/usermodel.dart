// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names
// import 'dart:convert';

class UserModel {
  String id;
  String email;
  String password;
  String? name;
  String? bio;
  String? avatar;
  String? createdAt;
  String? updatedAt;
  
  UserModel({
    required this.id,
    required this.email,
    required this.password,
    this.name,
    this.bio,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'bio': bio,
      'avatar': avatar,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      name: map['name'] as String?,
      bio: map['bio'] as String?,
      avatar: map['avatar'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, email: $email, password: $password, name: $name, bio: $bio, avatar: $avatar)';
}
