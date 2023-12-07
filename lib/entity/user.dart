import 'dart:convert';

class User {
  final int? id;
  String? email,
      notelp,
      username,
      password,
      dateofbirth,
      role,
      membership,
      image;

  User(
      {this.id,
      this.email,
      this.notelp,
      this.username,
      this.password,
      this.dateofbirth,
      this.role,
      this.membership,
      this.image});

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        notelp: json['notelp'],
        username: json['username'],
        password: json['password'],
        dateofbirth: json['dateofbirth'],
        role: json['role'],
        membership: json['membership'],
        image: json['image'],
      );

  // untuk membuat data json dari objek User yang dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "notelp": notelp,
        "username": username,
        "password": password,
        "dateofbirth": dateofbirth,
        "role": role,
        "membership": membership,
        "image": image,
      };
}
