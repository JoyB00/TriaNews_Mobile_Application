// import 'dart:convert';
import 'dart:io';
// import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_pbp/client/NewsClient.dart';
import 'package:news_pbp/entity/news.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:news_pbp/image/image_setup.dart';

const List<String> kategori = <String>[
  'Politik',
  'Olahraga',
  'Hiburan',
  'Kesehatan',
  'International'
];

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
  String dropdownValue = kategori.first;
  Future<File> imageFile = Future<File>.value(File(""));
  String? image;
  final _formKey = GlobalKey<FormState>();
  //controller
  TextEditingController judulController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();
  String imgString = "";
  String text = "";

  final SpeechToText _speechToText = SpeechToText();
  String _wordSpoken = '';

  bool _speechEnabled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    initSpeech();
    if (widget.image != null) {
      image = widget.image;
    }
    loadBerita();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    text = descriptionController.text;
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordSpoken = "$text ${result.recognizedWords}";
      descriptionController.text = _wordSpoken;
    });
  }

  Future<void> loadBerita() async {
    if (widget.id != null) {
      setState(() {
        judulController.text = widget.judul!;
        authorController.text = widget.author!;
        dateController.text = widget.date!;
        kategoriController.text = widget.kategori!;
        if (_wordSpoken == '') {
          descriptionController.text = widget.deskripsi!;
        } else {
          descriptionController.text = _wordSpoken;
        }

        isLoading = false;
      });
    } else {
      isLoading = false;
    }

    if (imgString != '') {
      setState(() {
        image = imgString;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: 6.h),
            child: Image.asset(
              'images/Tria News.png',
              width: 20.h,
              height: 20.w,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0.h),
                  child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Padding(
                                  padding: EdgeInsets.only(bottom: 2.w),
                                  child: Container(
                                    height: 15.h,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(2.h),
                                    ),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.w)),
                                            Icon(
                                              Icons.newspaper,
                                              color: Colors.white,
                                              size: 25.sp,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    right: 5.w)),
                                            Text(
                                              "TULIS BERITA",
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )),
                                  )),
                            ),
                            //Input judul, author, date, desciption
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.w)),
                            ElevatedButton(
                              onPressed: () {
                                camOrGallery(context);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(249, 148, 23, 1)),
                              ),
                              child: const Text(
                                'Tambahkan Gambar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            if (image != null)
                              Column(
                                children: [
                                  kIsWeb
                                      ? Image.network(image!)
                                      : image != null
                                          ? SizedBox(
                                              child: decode(image),
                                            )
                                          : Image.file(File(image!)),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                    child: IconButton(
                                      color: Colors.red,
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          image = null;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              )
                            else
                              const Text("No image selected"),

                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 2.h)),
                            TextFormField(
                                controller: judulController,
                                decoration: InputDecoration(
                                  labelText: 'Judul Berita',
                                  prefixIcon: const Icon(Icons.input,
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0.2.h),
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Judul Berita Tidak Boleh Kosong';
                                  }
                                  return null;
                                }),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.h, vertical: 1.h)),
                            TextFormField(
                                controller: authorController,
                                decoration: InputDecoration(
                                  labelText: 'Author',
                                  prefixIcon: const Icon(Icons.person,
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0.2.h),
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Nama Author Tidak Boleh Kosong';
                                  } else if (value.length < 6) {
                                    return 'Nama Author Kurang dari 6 karakter';
                                  }
                                  return null;
                                }),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.h, vertical: 4.w)),
                            Align(
                              alignment:
                                  Alignment.centerLeft, // Align to the left
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownButtonFormField<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Kategori Berita',
                                      prefixIcon: const Icon(Icons.category,
                                          color: Colors.black),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                    items: kategori
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.h, vertical: 2.w)),
                            TextFormField(
                                controller: dateController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.black,
                                  ),
                                  labelText: 'Tanggal Up berita',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0.2.h),
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _dateSelect();
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.calendar_today,
                                        color: Colors.black,
                                      )),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Tanggal tidak boleh kosong';
                                  }
                                  return null;
                                }),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.h, vertical: 2.h)),
                            TextFormField(
                                controller: descriptionController,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: "Deskripsi",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.2.h,
                                            color: Colors.black))),
                                maxLines: 10,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Deskripsi Tidak Boleh Kosong';
                                  }
                                  return null;
                                }),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h)),
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
                              backgroundColor:
                                  const Color.fromRGBO(122, 149, 229, 1),
                              child: Icon(
                                _speechToText.isNotListening
                                    ? Icons.mic_off
                                    : Icons.mic,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(
                              height: 2.h,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (widget.id == null) {
                                        await addNews();
                                      } else {
                                        await editNews(widget.id!);
                                      }
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromRGBO(122, 149, 229, 1)),
                                  ),
                                  child: const Text('Publish'),
                                )),
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

  Future pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 10);

      if (image == null) return;

      imgString = await encode(image.path);
      await loadBerita();
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 25);

      if (image == null) return;

      imgString = await encode(image.path);
      await loadBerita();
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  void camOrGallery(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Foto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextButton(
                  child: const Text('Camera'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    pickImageC();
                  },
                ),
                TextButton(
                  child: const Text('Galery'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await pickImage();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> encode(image) async {
    File imageFile = File(image);
    Uint8List bytes = await imageFile.readAsBytes();
    String imgString = Utility.base64String(bytes);
    return imgString;
  }

  Image decode(image) {
    return Utility.imageFromBase64String(image);
  }

  Future<void> addNews() async {
    // print(image);
    // if (image != null) {
    //   imgString = await encode(image);
    // }
    News news = News(
      image: imgString,
      judul: judulController.text,
      deskripsi: descriptionController.text,
      author: authorController.text,
      kategori: dropdownValue,
      date: dateController.text,
    );
    print(imgString);
    await NewsClient.create(news);
  }

  Future<void> editNews(int id) async {
    News news = News(
      id: id,
      image: image,
      judul: judulController.text,
      deskripsi: descriptionController.text,
      author: authorController.text,
      kategori: dropdownValue,
      date: dateController.text,
    );
    await NewsClient.update(news);
  }
}
