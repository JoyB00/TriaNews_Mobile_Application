import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:news_pbp/View/inputanberita.dart';
import 'package:news_pbp/database/sql_news.dart';
import 'package:news_pbp/pages/detailNews.dart';
import 'package:news_pbp/qr_scan/scan_qr_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

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
  List<Map<String, dynamic>> newsList = [];
  void refresh() async {
    final data = await SQLNews.getNews();
    setState(() {
      newsList = data;
    });
  }

  Future<void> loadNewsData(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> news = await SQLNews.getSpesificNews(id);
    setState(() {
      prefs.setInt('newsId', news[0]['id']);
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'images/Tria News.png',
            width: 150,
            height: 150,
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
            IconButton(icon: const Icon(Icons.clear), onPressed: () async {})
          ],
        ),
        body: Column(children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BarcodeScannerPageView()));
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
                                        image: newsList[index]['image'],
                                        id: newsList[index]['id'],
                                        judul: newsList[index]['judul'],
                                        author: newsList[index]['author'],
                                        deskripsi: newsList[index]['deskripsi'],
                                        kategori: newsList[index]['kategori'],
                                        date: newsList[index]['date'],
                                      )),
                            ).then((_) => refresh());
                          },
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () async {
                            await deleteNews(newsList[index]['id']);
                          },
                        )
                      ],
                      child: ListTile(
                        title: Container(
                            margin: const EdgeInsets.only(
                                top: 15, left: 5, right: 5),
                            width: 500,
                            height: 180,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 150,
                                  child: Image.asset(
                                    newsList[index]['image'],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10.0)),
                                    Text(
                                      "${newsList[index]['date']}",
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        newsList[index]['judul'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: true,
                                      ),
                                    ),
                                    Text(
                                      "${newsList[index]['kategori']}",
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        loadNewsData(newsList[index]['id']);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailNews(
                                                        index: newsList[index]
                                                            ['id'])));
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
    await SQLNews.deleteNews(id);
    refresh();
  }
}
