import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news_pbp/database/sql_news.dart';
import 'package:news_pbp/qr_scan/generateQrPage.dart';

class DetailNews extends StatefulWidget {
  final int? index;
  const DetailNews({Key? key, this.index}) : super(key: key);

  @override
  State<DetailNews> createState() => DetailNewsState();
}

class DetailNewsState extends State<DetailNews> {
  TextEditingController textEditingController = TextEditingController();
  FlutterTts flutterTts = FlutterTts();

  String image = 'unnamed.jpg';
  String judul = '';
  String deskripsi = '';
  String author = '';
  String kategori = '';
  String tanggalPublish = '';
  bool play = false;

  void textToSpeech(String text) async {
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    loadNewsData(widget.index!);
  }

  Future<void> loadNewsData(int id) async {
    final news = await SQLNews.getSpesificNews(widget.index!);
    setState(() {
      image = news[0]['image'];
      judul = news[0]['judul'];
      deskripsi = news[0]['deskripsi'];
      author = news[0]['author'];
      kategori = news[0]['kategori'];
      tanggalPublish = news[0]['date'];
    });
  }

  @override
  Widget build(BuildContext context) {
    loadNewsData(widget.index!);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Image.asset(
            'images/Tria News.png',
            width: 150,
            height: 150,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: judul.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 15, right: 10),
                  child: Text(
                    judul,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, top: 10.0),
                  width: 100,
                  height: 3,
                  color: const Color.fromRGBO(122, 149, 229, 1),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, top: 15.0),
                  child: const Text(
                    'Tria News',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, top: 5),
                  child: Text(
                    '$tanggalPublish | $author',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 15.0, left: 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GenerateQRPage()));
                      },
                      child: const Text(
                        'Lihat Qr Code Berita',
                        style:
                            TextStyle(color: Color.fromRGBO(122, 149, 229, 1)),
                      ),
                    )),

                Center(child: Image.asset(image)),
                Container(
                    margin: const EdgeInsets.only(left: 15.0, top: 30),
                    child: const Text(
                      "Deskripsi Berita",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Container(
                    margin:
                        const EdgeInsets.only(left: 15.0, top: 15, right: 15),
                    child: Text(
                      deskripsi,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    )),
                //  Jangan diubah!!
                Container(
                    padding: const EdgeInsets.only(top: 50, left: 15),
                    child: GestureDetector(
                        onTap: () {
                          play = !play;
                          if (play == true) {
                            textToSpeech(deskripsi);
                          } else {
                            textToSpeech('');
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, bottom: 20),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(122, 149, 229, 1),
                            ),
                            child: Center(
                              child: Icon(
                                play ? Icons.volume_up : Icons.volume_off,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ))),
              ],
            ))
          : Container(
              margin: const EdgeInsets.only(top: 20, left: 15),
              child: const Text(
                "Berita Tidak tersedia",
                style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
              ),
            ),
    );
  }
}
