import 'dart:convert';

class News {
  final int? id;
  final String? image, judul, author, deskripsi, tanggal;

  News(
      {this.id,
      this.image,
      this.judul,
      this.author,
      this.deskripsi,
      this.tanggal});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'judul': judul,
      'author': author,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
    };
  }

  News.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        image = map['image'],
        judul = map['judul'],
        author = map['author'],
        deskripsi = map['deskripsi'],
        tanggal = map['tanggal'];

  factory News.fromRawJson(String str) => News.fromJson(json.decode(str));

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json['id'],
        image: json['image'],
        judul: json['judul'],
        author: json['author'],
        deskripsi: json['deskripsi'],
        tanggal: json['tanggal'],
      );

  // untuk membuat data json dari objek User yang dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "judul": judul,
        "author": author,
        "deskripsi": deskripsi,
        "tanggal": tanggal,
      };
}
