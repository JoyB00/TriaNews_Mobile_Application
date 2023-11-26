import 'package:flutter/material.dart';
// import 'package:news_pbp/client/NewsClient.dart';
// import 'package:news_pbp/entity/news.dart';
// import 'package:news_pbp/database/sql_news.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class GenerateQRPage extends StatefulWidget {
  final int? index;
  const GenerateQRPage({super.key, this.index});

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
    // loadNewsData();
    print(widget.index);
  }

  // Future<void> loadNewsData() async {
  //   // final prefs = await SharedPreferences.getInstance();
  //   News news = NewsClient.find(widget.index) as News;
  //   setState(() {
  //     newsId = news.id!;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // loadNewsData();
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
            data: widget.index.toString(),
            version: 6,
            padding: const EdgeInsets.all(50),
          ),
        ],
      )),
    );
  }
}
