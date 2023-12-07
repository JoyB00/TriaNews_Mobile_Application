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

class NewsPageViewer extends StatefulWidget {
  const NewsPageViewer({super.key, this.id});
  final int? id;

  @override
  State<NewsPageViewer> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPageViewer> {
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
            : Column(children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BarcodeScannerPageView()));
                  },
                  child: const Text(
                    'Cari Berita Melalui Qr Code',
                    style: TextStyle(color: Color.fromRGBO(122, 149, 229, 1)),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: newsList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Container(
                                margin: EdgeInsets.only(
                                    top: 1.h, left: 3.w, right: 3.w),
                                width: 100.w,
                                height: 25.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 30.w,
                                      height: 90.h,
                                      child: decode(newsList[index].image!),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.h,
                                                vertical: 4.w)),
                                        Text(
                                          "${newsList[index].date}",
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.grey),
                                        ),
                                        SizedBox(
                                          width: 50.w,
                                          child: Text(
                                            newsList[index].judul!,
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            softWrap: true,
                                          ),
                                        ),
                                        Text(
                                          "${newsList[index].kategori}",
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Colors.grey),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // loadDetailNews(newsList[index].id!);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailNews(
                                                            index:
                                                                newsList[index]
                                                                    .id)));
                                          },
                                          child: const Text(
                                            'Lihat Detail',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    249, 148, 23, 1)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          );
                        }))
              ]));
  }

  Image decode(image) {
    return Utility.imageFromBase64String(image);
  }

  Future<void> deleteNews(int id) async {
    await NewsClient.destroy(id);
    refresh();
  }
}
