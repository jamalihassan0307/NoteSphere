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

  
String toMap() {
    return "'$id','$email','$password'";
  
  }

 factory UserModel. fromMap(Map<String ,dynamic> map) {
    return UserModel( 

    
      id: map['id'] ,
      email: map['email'] ,
    
      password: map['password'] ,
    );
  }


 

  @override
  String toString() => 'UserModel(id: $id, email: $email, password: $password)';
}
