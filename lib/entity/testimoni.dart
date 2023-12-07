import 'dart:convert';

import 'package:flutter/foundation.dart';

class Testimoni {
  final int? id, id_user;
  final int? rating;
  final String? deskripsi;

  Testimoni({this.id, this.id_user, this.deskripsi, this.rating});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_user': id_user,
      'deskripsi': deskripsi,
      'rating': rating,
    };
  }

  Testimoni.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        id_user = map['id_user'],
        deskripsi = map['deskripsi'],
        rating = map['rating'];

  factory Testimoni.fromRawJson(String str) =>
      Testimoni.fromJson(json.decode(str));

  factory Testimoni.fromJson(Map<String, dynamic> json) => Testimoni(
        id: json['id'],
        id_user: json['id_user'],
        deskripsi: json['deskripsi'],
        rating: json['rating'],
      );

  // untuk membuat data json dari objek User yang dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": id_user,
        "deskripsi": deskripsi,
        "rating": rating,
      };
}
