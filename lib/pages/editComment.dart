import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:news_pbp/client/ReviewsClient.dart';
import 'package:news_pbp/entity/reviews.dart';
import 'package:news_pbp/pages/detailNews.dart';
// import 'package:login_view/bagiandalamhome/comment.dart';

class EditComment extends StatefulWidget {
  final int? id, idUser, idNews;
  final double? rating;
  final String? deskripsi;
  const EditComment(
      {super.key,
      this.idUser,
      this.idNews,
      this.rating,
      this.deskripsi,
      this.id});

  @override
  State<EditComment> createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {
  double ratingValue = 0;
  int? id, idUser, idNews;
  TextEditingController editCommentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> loadData() async {
    setState(() {
      idUser = widget.idUser;
      idNews = widget.idNews;
      ratingValue = widget.rating!.toDouble();
      editCommentController.text = widget.deskripsi!;
    });
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        title: const Align(
          alignment: Alignment.center,
          child: Text('Tria News'),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 500,
                        height: 70.0,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(122, 149, 229, 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20.0),
                              child: const Text(
                                "Edit Comment",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 120.0),
                              child: const Text(
                                "Edit Commentar anda",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: TextFormField(
                                maxLines: 7,
                                controller: editCommentController,
                                decoration: InputDecoration(
                                  hintText: "Edit Comment Anda Disini",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(122, 149, 229, 1),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(122, 149, 229, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 18.0,
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 180.0),
                              child: const Text(
                                "Beri Penilaian",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 100.0),
                              child: RatingBar.builder(
                                initialRating: ratingValue,
                                minRating: 1,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Color.fromRGBO(122, 149, 229, 1),
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                  setState(() {
                                    ratingValue = rating;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 240.0),
                            Container(
                              height: 50.0,
                              width: 350.0,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await editComment();
                                  Navigator.pop(context);
                                  // ignore: use_build_context_synchronously
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  122, 149, 229, 1),
                                              width: 2.0),
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
                                                    "Comment anda telah di edit",
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
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color.fromRGBO(122, 149, 229, 1),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  minimumSize: MaterialStateProperty.all<Size>(
                                    Size(double.infinity, 50.0),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.send_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      "Kirim",
                                      style: TextStyle(
                                        fontSize: 22.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> editComment() async {
    Review reviews = Review(
        id: widget.id,
        id_user: widget.idUser,
        id_news: widget.idNews,
        review: editCommentController.text,
        rating: ratingValue.toInt());
    await ReviewClient.update(reviews);
  }
}
