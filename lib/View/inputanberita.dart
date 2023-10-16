import 'dart:io';
import 'package:flutter/material.dart';
import 'package:news_pbp/database/sql_news.dart';

class InputanBerita extends StatefulWidget {
  // const InputanBerita({Key? key}) : super(key: key);

  const InputanBerita(
      {super.key,
      required this.image,
      required this.id,
      required this.judul,
      required this.author,
      required this.deskripsi,
      required this.kategori,
      required this.date});

  final String? image, judul, deskripsi, kategori, author, date;
  final int? id;

  @override
  State<InputanBerita> createState() => _InputanBerita();
}

class _InputanBerita extends State<InputanBerita> {
  Future<File> imageFile = Future<File>.value(File(""));
  var image = Image.asset("");
  final _formKey = GlobalKey<FormState>();
  //controller
  TextEditingController judulController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      judulController.text = widget.judul!;
      authorController.text = widget.author!;
      dateController.text = widget.date!;
      kategoriController.text = widget.kategori!;
      descriptionController.text = widget.deskripsi!;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upload Berita'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(padding: EdgeInsets.all(5.0)),
                      TextFormField(
                          controller: judulController,
                          decoration: const InputDecoration(
                            labelText: 'Judul Berita',
                            prefixIcon: Icon(Icons.input),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Judul Berita Tidak Boleh Kosong';
                            } else if (value.length > 25) {
                              return 'Judul Tidak Boleh lebih dari 25 Karakter';
                            }
                            return null;
                          }),
                      const Padding(padding: EdgeInsets.all(5.0)),
                      TextFormField(
                          controller: authorController,
                          decoration: const InputDecoration(
                            labelText: 'Author',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nama Author Tidak Boleh Kosong';
                            } else if (value.length < 6) {
                              return 'Nama Author Kurang dari 6 karakter';
                            }
                            return null;
                          }),
                      const Padding(padding: EdgeInsets.all(5.0)),
                      TextFormField(
                          controller: kategoriController,
                          decoration: const InputDecoration(
                            labelText:
                                'Kategori Berita (sport/politik/digital)',
                            prefixIcon: Icon(Icons.input),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Kategori Tidak Boleh Kosong';
                            } else if (value.compareTo('sport') != 0 &&
                                value.compareTo('politik') != 0 &&
                                value.compareTo('digital') != 0) {
                              return 'Kategori Berita Invalid';
                            }
                            return null;
                          }),
                      const Padding(padding: EdgeInsets.all(5.0)),
                      TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            labelText: 'Tanggal Up berita',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _dateSelect();
                                  });
                                },
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey,
                                )),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Tanggal tidak boleh kosong';
                            }
                            return null;
                          }),
                      const Padding(padding: EdgeInsets.all(5.0)),
                      TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Deskripsi"),
                          maxLines: 10,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Deskripsi Tidak Boleh Kosong';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (widget.id == null) {
                              await addNews(kategoriController.text);
                            } else {
                              await editNews(
                                  widget.id!, kategoriController.text);
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Publish'),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }

  Future<void> _dateSelect() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1945),
      lastDate: DateTime(2040),
    );

    if (picked != null) {
      setState(() {
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> addNews(String kategori) async {
    if (kategori.compareTo('sport') == 0) {
      await SQLNews.addNews(
          'images/sport.jpg',
          judulController.text,
          descriptionController.text,
          authorController.text,
          kategoriController.text,
          dateController.text);
    } else if (kategori.compareTo('digital') == 0) {
      await SQLNews.addNews(
          'images/digital.jpg',
          judulController.text,
          descriptionController.text,
          authorController.text,
          kategoriController.text,
          dateController.text);
    } else {
      await SQLNews.addNews(
          'images/politik.jpg',
          judulController.text,
          descriptionController.text,
          authorController.text,
          kategoriController.text,
          dateController.text);
    }
  }

  Future<void> editNews(int id, String kategori) async {
    if (kategori.compareTo('sport') == 0) {
      await SQLNews.editNews(
          id,
          'images/sport.jpg',
          judulController.text,
          descriptionController.text,
          authorController.text,
          kategoriController.text,
          dateController.text);
    } else if (kategori.compareTo('digital') == 0) {
      await SQLNews.editNews(
          id,
          'images/digital.jpg',
          judulController.text,
          descriptionController.text,
          authorController.text,
          kategoriController.text,
          dateController.text);
    } else {
      await SQLNews.editNews(
          id,
          'images/politik.jpg',
          judulController.text,
          descriptionController.text,
          authorController.text,
          kategoriController.text,
          dateController.text);
    }
  }
}
