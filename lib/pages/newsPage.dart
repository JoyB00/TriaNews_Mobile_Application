import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:news_pbp/View/inputanberita.dart';
import 'package:news_pbp/database/sql_news.dart';

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

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("TAMBAH BERITA"),
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
        body: ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              return Slidable(
                actionPane: const SlidableDrawerActionPane(),
                secondaryActions: [
                  IconSlideAction(
                    caption: 'Update',
                    color: Colors.blue,
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
                          bottom: 8, top: 15, left: 5, right: 5),
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(2, 10))
                          ],
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage(newsList[index]['image']),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0)),
                              Text(
                                "Judul Berita : ${newsList[index]['judul']}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text("Author : ${newsList[index]['author']}"),
                              Text(
                                "Deskripsi : ${newsList[index]['deskripsi']}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "Tanggal Publish : ${newsList[index]['date']}",
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              )
                            ],
                          ),
                        ],
                      )),
                ),
              );
            }));
  }

  Future<void> deleteNews(int id) async {
    await SQLNews.deleteNews(id);
    refresh();
  }
}
