import 'dart:io';
import 'package:flutter/material.dart';
import 'package:news_pbp/client/BookmarkClient.dart';
import 'package:news_pbp/client/NewsClient.dart';
import 'package:news_pbp/entity/news.dart';
import 'package:news_pbp/pages/detailNews.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BookmarkList extends StatefulWidget {
  const BookmarkList({super.key, this.id});
  final int? id;

  @override
  State<BookmarkList> createState() => BookmarkView();
}

class BookmarkView extends State<BookmarkList> {
  Image convert = Image.asset('images/luffy.jpg');
  String? image;
  File? userImage;
  News? news;
  int idUser = -1;
  bool isLoading = false;

  List<News> bookmarkList = [];
  void refresh() async {
    final data = await BookmarkClient.getBookmarkNews(widget.id);
    setState(() {
      bookmarkList = data;
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
                Expanded(
                    child: ListView.builder(
                        itemCount: bookmarkList.length,
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
                                      child: Image.file(
                                        File(bookmarkList[index].image!),
                                      ),
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
                                          "${bookmarkList[index].date}",
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.grey),
                                        ),
                                        SizedBox(
                                          width: 50.w,
                                          child: Text(
                                            bookmarkList[index].judul!,
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
                                          "${bookmarkList[index].kategori}",
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Colors.grey),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // loadDetailNews(
                                            //     bookmarkList[index].id!);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailNews(
                                                            index: bookmarkList[
                                                                    index]
                                                                .id))).then(
                                                (_) => refresh());
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

  Future<void> deleteNews(int id) async {
    await NewsClient.destroy(id);
    refresh();
  }
}
