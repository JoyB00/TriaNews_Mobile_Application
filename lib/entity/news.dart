class News{
  final int? id;
  final String? image, judul, author, deskripsi, tanggal;

  News({this.id, this.image, this.judul, this.author, this.deskripsi, this.tanggal});

  Map<String, dynamic> toMap(){
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
}