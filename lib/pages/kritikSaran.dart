import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:news_pbp/client/TestimoniClient.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/testimoni.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KritikSaran extends StatefulWidget {
  final int? id;
  final double? rating;
  final String? deskripsi;
  const KritikSaran(
      {super.key,
      required this.rating,
      required this.deskripsi,
      required this.id});

  @override
  State<KritikSaran> createState() => _KritikSaranState();
}

class _KritikSaranState extends State<KritikSaran> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController kritikController = TextEditingController();
  double ratingValue = 0;
  int? id, idTestimoni;
  bool isLoading = false;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    User user = await UserClient.find(prefs.getInt('userId'));
    setState(() {
      id = user.id!;
      if (widget.id != null) {
        kritikController.text = widget.deskripsi!;
        ratingValue = widget.rating!;
        idTestimoni = widget.id!;
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 55),
          child: Image.asset(
            'images/Tria News.png',
            width: 150,
            height: 200,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 500,
                        height: 70.0,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(122, 149, 229, 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20.0),
                              child: const Text(
                                "Kritik dan Saran",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 120.0),
                            child: const Text(
                              "Tulis Kritik & Saran Anda",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: TextFormField(
                              maxLines: 7,
                              controller: kritikController,
                              decoration: InputDecoration(
                                hintText: "Masukkan Kritik & Saran Anda Disini",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(122, 149, 229, 1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(122, 149, 229, 1),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Deskripsi Kritik dan Saran Tidak Boleh Kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 18.0,
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 180.0),
                            child: const Text(
                              "Beri Penilaian",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 100.0),
                            child: RatingBar.builder(
                              initialRating: ratingValue,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Color.fromRGBO(122, 149, 229, 1),
                              ),
                              onRatingUpdate: (rating) async {
                                setState(() {
                                  ratingValue = rating;
                                  print(ratingValue);
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 240.0),
                          SizedBox(
                            height: 50.0,
                            width: 350.0,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    if (widget.id == null) {
                                      await addTestimoni();
                                      Navigator.pop(context);
                                      notifyAddTestimoni();
                                    } else {
                                      await editTestimoni(widget.id!);
                                      Navigator.pop(context);
                                      notifyAddTestimoni();
                                    }
                                  } catch (e) {
                                    Navigator.pop(context);
                                    errorAddTestimoni();
                                  }
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(122, 149, 229, 1),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(double.infinity, 50.0),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.send_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Kirim",
                                    style: TextStyle(
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> addTestimoni() async {
    // print(ratingValue);
    Testimoni testimoni = Testimoni(
        id_user: id,
        deskripsi: kritikController.text,
        rating: ratingValue.toInt());

    await TestimoniClient.create(testimoni);
  }

  Future<void> editTestimoni(int id) async {
    Testimoni testimoni = Testimoni(
        id: id,
        id_user: this.id,
        deskripsi: kritikController.text,
        rating: ratingValue.toInt());
    await TestimoniClient.update(testimoni);
  }

  notifyAddTestimoni() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(
                color: Color.fromRGBO(122, 149, 229, 1), width: 2.0),
          ),
          content: Stack(
            children: [
              Positioned(
                right: 0.0,
                bottom: 80.0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Terima Kasih",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 0.5,
                    width: 300.0,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    "Kritik dan saran anda telah kami\nterima, Saran dan Kritik anda\nakan membuat aplikasi ini lebih baik",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  errorAddTestimoni() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(
                color: Color.fromRGBO(122, 149, 229, 1), width: 2.0),
          ),
          content: Stack(
            children: [
              Positioned(
                right: 0.0,
                bottom: 100.0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Mohon Maaf",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 0.5,
                    width: 300.0,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    "Anda sudah pernah mengirim kritik dan saran",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
