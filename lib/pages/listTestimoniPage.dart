import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:news_pbp/client/NewsClient.dart';
import 'package:news_pbp/client/TestimoniClient.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/testimoni.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/image/image_setup.dart';
import 'package:news_pbp/pages/kritikSaran.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ListTestimoni extends StatefulWidget {
  const ListTestimoni({super.key, this.id});
  final int? id;

  @override
  State<ListTestimoni> createState() => _NewsPageState();
}

class _NewsPageState extends State<ListTestimoni> {
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
  int? id_user;
  bool isLoading = false;

  List<Testimoni> testimoniList = [];
  List<User> userList = [];
  User currentUser = User();
  Testimoni currentTestimoni = Testimoni();
  void refresh() async {
    print("asdasd");
    final data = await TestimoniClient.fetchAll();
    setState(() {
      testimoniList = data;
    });

    print(testimoniList.length);
    await fetchDataUser();
    isLoading = false;
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    User user = await UserClient.find(prefs.getInt('userId'));
    setState(() {
      id_user = user.id!;
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
                const Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  "Testimoni Anda",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                currentTestimoni.deskripsi == null
                    ? const Text("Belum mengirimkan testimoni")
                    : ListTile(
                        title: Container(
                            margin: EdgeInsets.only(
                                top: 1.h, left: 3.w, right: 3.w),
                            width: 100.w,
                            height: 23.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 30.w,
                                  height: 20.h,
                                  child: currentUser.image != null
                                      ? decode(currentUser.image)
                                      : Image.asset('images/luffy.jpg'),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.h, vertical: 4.w)),
                                    SizedBox(
                                      width: 50.w,
                                      child: Text(
                                        currentUser.username!,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: true,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50.w,
                                      child: Text(
                                        currentTestimoni.deskripsi!,
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      ),
                                    ),
                                    RatingBar.builder(
                                      initialRating:
                                          currentTestimoni.rating!.toDouble(),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) async {
                                        setState(() {});
                                      },
                                      ignoreGestures: true,
                                    ),
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        KritikSaran(
                                                      rating: currentTestimoni
                                                          .rating!
                                                          .toDouble(),
                                                      deskripsi:
                                                          currentTestimoni
                                                              .deskripsi!,
                                                      id: currentTestimoni.id,
                                                    ),
                                                  )).then((_) => refresh());
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(Icons.edit),
                                                Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            )),
                                        TextButton(
                                            onPressed: () async {
                                              await deleteTestimoni(
                                                  currentTestimoni.id!);

                                              notifyDeleteTestimoni();
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors.red),
                                                Text(
                                                  "Hapus",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  "Semua Testimoni",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: testimoniList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Container(
                                margin: EdgeInsets.only(
                                    top: 1.h, left: 3.w, right: 3.w),
                                width: 100.w,
                                height: 25.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.black),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 30.w,
                                      height: 20.h,
                                      child: userList[index].image != null
                                          ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage: ((decode(
                                                      userList[index].image))
                                                  .image),
                                            )
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundImage: Image.asset(
                                                      'images/luffy.jpg')
                                                  .image),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.h,
                                                vertical: 4.w)),
                                        SizedBox(
                                          width: 50.w,
                                          child: Text(
                                            userList[index].username!,
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            softWrap: true,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50.w,
                                          child: Text(
                                            testimoniList[index].deskripsi!,
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                color: Colors.grey),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 6,
                                            softWrap: true,
                                          ),
                                        ),
                                        RatingBar.builder(
                                          initialRating: testimoniList[index]
                                              .rating!
                                              .toDouble(),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 20,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 1.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) async {
                                            setState(() {});
                                          },
                                          ignoreGestures: true,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          );
                        }))
              ]));
  }

  Future<void> fetchDataUser() async {
    await loadUserData();
    for (int i = 0; i < testimoniList.length; i++) {
      try {
        User user = await UserClient.find(testimoniList[i].id_user);
        setState(() {
          if (testimoniList[i].id_user == id_user) {
            currentUser = user;
            currentTestimoni = testimoniList[i];
          }
          userList.add(user);
        });
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Image decode(image) {
    return Utility.imageFromBase64String(image);
  }

  Future<void> deleteTestimoni(int id) async {
    await TestimoniClient.destroy(id);
    currentTestimoni = Testimoni();
    refresh();
  }

  notifyDeleteTestimoni() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(
                color: Color.fromRGBO(122, 149, 229, 1), width: 2.0),
          ),
          content: Stack(
            children: [
              Positioned(
                right: 0.0,
                bottom: 80.0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Hapus Testimoni",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 0.5,
                    width: 300.0,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    "Berhasil Menghapus Testimoni.\nJangan Sungkan untuk mengisi kembali",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
