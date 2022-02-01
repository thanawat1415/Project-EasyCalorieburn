import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? imageUrl;
  String? email;
  String? username;
  String? age;
  String? height;
  String? weight;

  UserModel({
    this.uid,
    this.imageUrl,
    this.email,
    this.username,
    this.age,
    this.height,
    this.weight,
  }
  );
  //receiving data from server
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      imageUrl: map['imageUrl'],
      email: map['email'],
      username: map['username'],
      age: map['age'],
      height: map['height'],
      weight:  map['weight'],
    );
  }
  //sending data to our server
  Map<String, dynamic> toMap(){
    return {
      'uid':uid,
      'imageUrl':imageUrl,
      'email':email,
      'username':username,
      'age':age,
      'height':height,
      'weight':weight,
    };
  }
}