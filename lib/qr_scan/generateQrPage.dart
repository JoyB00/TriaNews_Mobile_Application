import 'package:flutter/material.dart';
import 'package:news_pbp/database/sql_news.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateQRPage extends StatefulWidget {
  const GenerateQRPage({super.key});

  @override
  State<GenerateQRPage> createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  String image = '';
  String judul = '';
  String deskripsi = '';
  String author = '';
  String kategori = '';
  String tanggalPublish = '';
  int newsId = -1;

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
      newsId = news[0]['id'];
    });
  }

  @override
  Widget build(BuildContext context) {
    loadNewsData();
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
      body: Center(
          child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 50)),
          const Text(
            'QR Berita',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Text(
            'Scan QR dibawah untuk melihat berita',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          QrImageView(
            data: newsId.toString(),
            version: 6,
            padding: const EdgeInsets.all(50),
          ),
        ],
      )),
    );
  }
}
