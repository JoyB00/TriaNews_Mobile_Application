import 'dart:convert';

class News {
  final int? id;
  final String? image, judul, author, kategori, deskripsi, date;

  News(
      {this.id,
      this.image,
      this.judul,
      this.author,
      this.kategori,
      this.deskripsi,
      this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'judul': judul,
      'author': author,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'date': date,
    };
  }

  News.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        image = map['image'],
        judul = map['judul'],
        author = map['author'],
        kategori = map['kategori'],
        deskripsi = map['deskripsi'],
        date = map['date'];

  factory News.fromRawJson(String str) => News.fromJson(json.decode(str));

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json['id'],
        image: json['image'],
        judul: json['judul'],
        author: json['author'],
        kategori: json['kategori'],
        deskripsi: json['deskripsi'],
        date: json['date'],
      );

  // untuk membuat data json dari objek User yang dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "judul": judul,
        "author": author,
        "kategori": kategori,
        "deskripsi": deskripsi,
        "date": date,
      };
}
