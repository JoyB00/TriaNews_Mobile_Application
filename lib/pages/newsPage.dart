import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:news_pbp/View/inputanberita.dart';
import 'package:news_pbp/client/NewsClient.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/news.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/pages/detailNews.dart';
import 'package:news_pbp/qr_scan/scan_qr_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:news_pbp/image/image_setup.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key, this.id});
  final int? id;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
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
  Image? image;
  File? userImage;
  bool isLoading = false;
  User user = User();

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
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InputanBerita(
                              image: null,
                              id: null,
                              judul: null,
                              author: null,
                              deskripsi: null,
                              kategori: null,
                              date: null,
                            )),
                  ).then((_) => refresh());
                }),
          ],
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
                          return Slidable(
                            actionPane: const SlidableDrawerActionPane(),
                            secondaryActions: [
                              IconSlideAction(
                                caption: 'Update',
                                color: const Color.fromRGBO(122, 149, 229, 1),
                                icon: Icons.update,
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InputanBerita(
                                              image: newsList[index].image,
                                              id: newsList[index].id,
                                              judul: newsList[index].judul,
                                              author: newsList[index].author,
                                              deskripsi:
                                                  newsList[index].deskripsi,
                                              kategori:
                                                  newsList[index].kategori,
                                              date: newsList[index].date,
                                            )),
                                  ).then((_) => refresh());
                                },
                              ),
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () async {
                                  await deleteNews(newsList[index].id!);
                                },
                              )
                            ],
                            child: ListTile(
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
                                        child: newsList[index].image != null
                                            ? decode(newsList[index].image!)
                                            : SizedBox(),
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
                                              print(
                                                  " asdas ${newsList[index].id}");
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailNews(
                                                              index: newsList[
                                                                      index]
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
                            ),
                          );
                        }))
              ]));
  }

  Future<void> deleteNews(int id) async {
    await NewsClient.destroy(id);
    refresh();
  }


  Image decode(image) {
    return Utility.imageFromBase64String(image);
  }
}
