import 'dart:convert';

class Bookmark {
  final int? id, id_user, id_berita;

  Bookmark({this.id, this.id_berita, this.id_user});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_berita': id_berita,
      'id_user': id_user,
    };
  }

  Bookmark.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        id_berita = map['id_berita'],
        id_user = map['id_user'];

  factory Bookmark.fromRawJson(String str) =>
      Bookmark.fromJson(json.decode(str));

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        id: json['id'],
        id_berita: json['id_berita'],
        id_user: json['id_user'],
      );

  // untuk membuat data json dari objek User yang dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "id_berita": id_berita,
        "id_user": id_user,
      };
}
