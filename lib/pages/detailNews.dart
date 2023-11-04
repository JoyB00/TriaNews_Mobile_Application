import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news_pbp/database/sql_news.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailNews extends StatefulWidget {
  const DetailNews({Key? key}) : super(key: key);

  @override
  State<DetailNews> createState() => DetailNewsState();
}

class DetailNewsState extends State<DetailNews> {
  TextEditingController textEditingController = TextEditingController();
  FlutterTts flutterTts = FlutterTts();

  String image = '';
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
    loadNewsData();
  }

  Future<void> loadNewsData() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> news =
        await SQLNews.getSpesificNews(prefs.getInt('newsId') ?? 0);

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
    loadNewsData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, left: 15),
            child: Text(
              judul,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Oleh $author',
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15.0, left: 15),
            child: Text(
              'Tanggal Publish $tanggalPublish',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey),
            ),
          ),
          Center(child: Image.asset(image)),
          Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
              child: Text(
                deskripsi,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.normal),
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
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Icon(
                      play ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
