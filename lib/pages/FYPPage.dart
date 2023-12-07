import 'dart:io';
import 'package:flutter/material.dart';
import 'package:news_pbp/client/NewsClient.dart';
// import 'package:news_pbp/database/sql_news.dart';
import 'package:news_pbp/entity/news.dart';
import 'package:news_pbp/image/image_setup.dart';
import 'package:news_pbp/pages/detailNews.dart';
import 'package:news_pbp/qr_scan/scan_qr_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FYPPage extends StatefulWidget {
  const FYPPage({super.key, this.id});
  final int? id;

  @override
  State<FYPPage> createState() => _FYPPage();
}

class _FYPPage extends State<FYPPage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: ElevatedCardExample(),
      ),
    );
  }
}

class ElevatedCardExample extends StatefulWidget {
  const ElevatedCardExample({Key? key}) : super(key: key);

  @override
  State<ElevatedCardExample> createState() => _ElevatedCardExampleState();
}

class _ElevatedCardExampleState extends State<ElevatedCardExample> {
  Image convert = Image.asset('images/luffy.jpg');
  String? image;
  File? userImage;
  bool isLoading = false;

  List<News> newsList = [];
  void refresh() async {
    final data = await NewsClient.fetchAll();
    setState(() {
      newsList = data;
      isLoading = false;
    });
  }

  Future<void> loadDetailNews(int id) async {
    final prefs = await SharedPreferences.getInstance();
    News news = await NewsClient.find(id);
    setState(() {
      prefs.setInt('newsId', news.id!);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'images/Tria News.png',
            width: 20.h,
            height: 20.w,
          ),
          backgroundColor: Colors.black,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(left: 30, top: 40, bottom: 20),
                      child: Text(
                        "Berita Terbaru",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: SizedBox(
                        width: 320,
                        height: 280,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Image.asset('images/luffy.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                                width: double.infinity,
                                height: 280,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Color.fromRGBO(122, 149, 229, 1)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30.0),
                                )),
                            Positioned.fill(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Judul Berita Terbaru",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: () {},
                                            child: const Text(
                                              "Lihat Detail",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                  const Padding(
                      padding: EdgeInsets.only(left: 30, top: 30, bottom: 20),
                      child: Text(
                        "Berita Terbaru",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ],
              ));
  }
}
