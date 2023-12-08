import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news_pbp/client/BookmarkClient.dart';
import 'package:news_pbp/client/NewsClient.dart';
import 'package:news_pbp/client/ReviewsClient.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/bookmark.dart';
import 'package:news_pbp/entity/news.dart';
import 'package:news_pbp/entity/reviews.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/image/image_setup.dart';
import 'package:news_pbp/pages/editComment.dart';
import 'package:news_pbp/pages/pdf_berita_view.dart';
import 'package:news_pbp/qr_scan/generateQrPage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailNews extends StatefulWidget {
  final int? index;
  const DetailNews({Key? key, this.index}) : super(key: key);

  @override
  State<DetailNews> createState() => DetailNewsState();
}

class DetailNewsState extends State<DetailNews> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();
  FlutterTts flutterTts = FlutterTts();
  User currentUser = User();

  String image = 'unnamed.jpg';
  String imageUser = 'images/luffy.jpg';
  String judul = '';
  String deskripsi = '';
  String author = '';
  String kategori = '';
  String tanggalPublish = '';
  bool play = false;
  int idUser = -1;
  int isDelete = 0;
  var i = 0;
  bool isLoading = false;
  double ratingValue = 1;
  List<User> userList = [];

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
    setState(() {
      isLoading = true;
    });
    refresh();
  }

  void refresh() async {
    await loadUserData();
    await loadCommentUser();
    await loadNewsData(widget.index!);
  }

  Future<void> loadNewsData(int id) async {
    News news = await NewsClient.find(id);
    setState(() {
      if (news.image != null) {
        image = news.image!;
      }
      judul = news.judul!;
      deskripsi = news.deskripsi!;
      author = news.author!;
      kategori = news.kategori!;
      tanggalPublish = news.date!;
      isLoading = false;
    });
  }

  List<Review> commentList = [];
  Future<void> loadCommentUser() async {
    final data = await ReviewClient.fetchAll(widget.index);
    setState(() {
      commentList = data;
    });
    print(commentList.length);
    await fetchDataUser();
  }

  Future<void> fetchDataUser() async {
    for (int i = 0; i < commentList.length; i++) {
      try {
        User user = await UserClient.find(commentList[i].id_user);
        setState(() {
          userList.add(user);
        });
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  List<News> bookmarkList = [];
  void bookMark(int idUser) async {
    final data = await BookmarkClient.getBookmarkNews(idUser);
    setState(() {
      bookmarkList = data;
    });
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    User user = await UserClient.find(prefs.getInt('userId'));
    setState(() {
      idUser = user.id!;
      currentUser = user;
    });

    print(currentUser.username);
  }

  @override
  Widget build(BuildContext context) {
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
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    bookMark(idUser);
                    Bookmark bookmark =
                        await BookmarkClient.findBookmark(widget.index, idUser);
                    await BookmarkClient.destroy(widget.index);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Hapus dari Bookmark'),
                    ));
                  } catch (e) {
                    Bookmark bookmarkNew =
                        Bookmark(id_berita: widget.index, id_user: idUser);
                    await BookmarkClient.create(bookmarkNew);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Tambahkan ke Bookmark'),
                    ));
                  }
                },
                icon: const Icon(Icons.bookmark_add_outlined))
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : judul.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(top: 2.h, left: 1.h, right: 1.0.h),
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
                                          GenerateQRPage(index: widget.index)));
                            },
                            child: const Text(
                              'Lihat Qr Code Berita',
                              style: TextStyle(
                                  color: Color.fromRGBO(122, 149, 229, 1)),
                            ),
                          )),

                      image != 'unnamed.jpg'
                          ? Center(child: decode(image))
                          : const SizedBox(),
                      Container(
                          margin: EdgeInsets.only(left: 4.5.w, top: 3.0.h),
                          child: Text(
                            "Deskripsi Berita",
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              left: 4.5.w, top: 3.h, right: 4.5.w),
                          child: Text(
                            deskripsi,
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w400),
                          )),
                      //  Jangan diubah!!
                      Container(
                          padding: EdgeInsets.only(
                              top: 0.1.h, left: 0.5.w, right: 1.w),
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
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Container(
                                      height: 10.h,
                                      width: 15.w,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(122, 149, 229, 1),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          play
                                              ? Icons.volume_up
                                              : Icons.volume_off,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )),
                              ElevatedButton(
                                onPressed: () {
                                  createPdf(
                                      widget.index!,
                                      Utility.dataFromBase64String(image),
                                      judul,
                                      deskripsi,
                                      author,
                                      kategori,
                                      tanggalPublish,
                                      context);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () async {
                                await loadCommentUser();
                                setState(() {
                                  _showComments();
                                });
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.comment,
                                      color: Color.fromRGBO(122, 149, 229, 1)),
                                  Text(
                                    " Lihat Komentar",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(122, 149, 229, 1)),
                                  ),
                                ],
                              )),
                        ],
                      )
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

  Image decode(image) {
    return Utility.imageFromBase64String(image);
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        double maxHeight = MediaQuery.of(context).size.height * 0.9;
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    height: 7.0,
                    width: 60.0,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(122, 149, 229, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: const Text(
                    "Comments",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 330.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: commentList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                image: userList[index].image != null
                                    ? ((decode(userList[index].image)).image)
                                    : Image.asset('images/luffy.jpg').image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            userList[index].username!,
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(121, 121, 121, 1),
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      commentList[index].review!,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    child: RatingBar.builder(
                                      initialRating:
                                          commentList[index].rating!.toDouble(),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Color.fromRGBO(122, 149, 229, 1),
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                      ignoreGestures: true,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 80.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      commentList[index].id_user ==
                                              currentUser.id
                                          ? IconButton(
                                              onPressed: () async {
                                                await deleteComment(
                                                    commentList[index].id!);
                                                Navigator.pop(context);
                                                notifyDeleteComment();
                                              },
                                              icon: Icon(Icons.delete),
                                            )
                                          : const SizedBox(),
                                      commentList[index].id_user ==
                                              currentUser.id
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          EditComment(
                                                        id: commentList[index]
                                                            .id,
                                                        idUser:
                                                            commentList[index]
                                                                .id_user,
                                                        idNews:
                                                            commentList[index]
                                                                .id_news,
                                                        deskripsi:
                                                            commentList[index]
                                                                .review,
                                                        rating:
                                                            commentList[index]
                                                                .rating!
                                                                .toDouble(),
                                                      ),
                                                    ),
                                                  );
                                                });
                                              },
                                              icon: Icon(Icons.edit),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                ),
                Container(
                  width: 500,
                  height: 0.5,
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 8,
                      ),
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: currentUser.image != null
                              ? ((decode(currentUser.image)).image)
                              : Image.asset('images/luffy.jpg').image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 30,
                      width: 270,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color.fromRGBO(217, 217, 217, 1),
                      ),
                      child: TextFormField(
                        controller: commentController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText: "Tambahkan Komentar...",
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showRatingDialog();
                        });
                      },
                      icon: Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      commentController.clear();
      FocusScope.of(context).requestFocus(commentFocusNode);
    });
  }

  Future<void> addComment() async {
    Review review = Review(
        id_user: idUser,
        id_news: widget.index!,
        review: commentController.text,
        rating: ratingValue.toInt());
    await ReviewClient.create(review);
  }

  Future<void> deleteComment(int id) async {
    await ReviewClient.destroy(id);
    setState(() {
      isLoading = true;
    });
    refresh();
    isLoading ? Center(child: CircularProgressIndicator()) : SizedBox();
  }

  void notifyDeleteComment() {
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
                bottom: 25.0,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
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
                    "Terima Kasih",
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
                  Container(
                    child: const Text(
                      "Comment anda telah di Hapus",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: 300, top: 200),
          child: AlertDialog(
            contentPadding: EdgeInsets.all(10.0),
            title: Text("Beri Rating"),
            content: Column(
              children: [
                RatingBar.builder(
                  initialRating: 1.0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 30.0,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Color.fromRGBO(122, 149, 229, 1),
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      ratingValue = rating;
                      print(ratingValue);
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Batal"),
              ),
              TextButton(
                onPressed: () async {
                  await addComment();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Kirim"),
              ),
            ],
          ),
        );
      },
    );
  }
}
