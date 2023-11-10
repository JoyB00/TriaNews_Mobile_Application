import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news_pbp/database/sql_news.dart';
import 'package:news_pbp/pages/pdf_berita_view.dart';
import 'package:news_pbp/qr_scan/generateQrPage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
    await flutterTts.setVolume(10.0);
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
            padding: EdgeInsets.only(left: 6.h),
            child: Image.asset(
              'images/Tria News.png',
              width: 20.h,
              height: 20.w,
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
                    margin: EdgeInsets.only(top: 2.h, left: 1.h, right: 1.0.h),
                    child: Text(
                      judul,
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 1.5.h, top: 1.0.h),
                    width: 20.w,
                    height: 0.5.h,
                    color: const Color.fromRGBO(122, 149, 229, 1),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 1.5.h, top: 1.5.h),
                    child: Text(
                      'Tria News',
                      style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 3.w, top: 0.5.h),
                    child: Text(
                      '$tanggalPublish | $author',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 0.5.h, left: 0.1.w),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GenerateQRPage()));
                        },
                        child: const Text(
                          'Lihat Qr Code Berita',
                          style: TextStyle(
                              color: Color.fromRGBO(122, 149, 229, 1)),
                        ),
                      )),

                  Center(child: Image.file(File(image))),
                  Container(
                      margin: EdgeInsets.only(left: 4.5.w, top: 3.0.h),
                      child: Text(
                        "Deskripsi Berita",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      margin:
                          EdgeInsets.only(left: 4.5.w, top: 3.h, right: 4.5.w),
                      child: Text(
                        deskripsi,
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w400),
                      )),
                  //  Jangan diubah!!
                  Container(
                      padding:
                          EdgeInsets.only(top: 0.1.h, left: 0.5.w, right: 1.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                play = !play;
                                if (play == true) {
                                  textToSpeech(deskripsi);
                                } else {
                                  textToSpeech('');
                                }
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 5.w, bottom: 2.h),
                                child: Container(
                                  height: 15.h,
                                  width: 15.w,
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
                              )),
                          ElevatedButton(
                            onPressed: () {
                              createPdf(
                                  widget.index!,
                                  File(image),
                                  judul,
                                  deskripsi,
                                  author,
                                  kategori,
                                  tanggalPublish,
                                  context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(122, 149, 229, 1)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.print),
                                Text(
                                  ' Cetak Berita',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ))
            : Center(
                child: Container(
                  margin: EdgeInsets.only(top: 5.h, left: 5.w),
                  child: Text(
                    "Berita Tidak tersedia",
                    style: TextStyle(
                      fontSize: 12.w,
                      fontStyle: FontStyle.italic,
                      color: Colors.red,
                    ),
                  ),
                ),
              ));
  }
}
