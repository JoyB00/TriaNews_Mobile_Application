import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:news_pbp/database/sql_news.dart';
import 'package:speech_to_text/speech_to_text.dart';

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

class Utility {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
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
  String imgString = "";

  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      descriptionController.text = "${result.recognizedWords}";
    });
  }

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
                      //Input judul, author, date, desciption
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
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0)),
                      Text(
                        _speechToText.isListening
                            ? "Mendengarkan"
                            : _speechEnabled
                                ? "Tekan Microphone untuk mengisi deskripsi"
                                : "Speech not available",
                      ),
                      FloatingActionButton(
                        onPressed: _speechToText.isListening
                            ? _stopListening
                            : _startListening,
                        tooltip: 'Listen',
                        backgroundColor: Colors.blue,
                        child: Icon(
                          _speechToText.isNotListening
                              ? Icons.mic_off
                              : Icons.mic,
                          color: Colors.white,
                        ),
                      ),

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
