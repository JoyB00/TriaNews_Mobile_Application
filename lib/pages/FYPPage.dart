import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:news_pbp/client/NewsClient.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/news.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/image/image_setup.dart';
import 'package:news_pbp/pages/detailNews.dart';
import 'package:news_pbp/pages/newsPageViewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FypPage extends StatefulWidget {
  const FypPage({
    super.key,
    this.items = const [
      'https://pks.id/contentAsset/resize-image/f73c1135-8722-4a86-955d-0a2f1955cb6f/image/?byInode=true&h=768',
      'https://akcdn.detik.net.id/community/media/visual/2022/10/05/roasting-anggota-dpr-komika-mamat-dipolisikan-tim-infograsi-detikcom-fauzan-2_43.jpeg?w=250&q=',
      'https://thumb.viva.co.id/media/frontend/thumbs3/2023/01/17/63c65344a2724-presiden-jokowi-buka-rakornas-kepala-daerah-dan-forkopimda-se-indonesia_665_374.jpg',
    ],
  });
  final List<String> items;
  @override
  State<FypPage> createState() => _FypPage();
}

class _FypPage extends State<FypPage> {
  late CarouselController controller;
  int currentIndex = 0;
  bool isLoading = false;
  User user = User();

  List<News> newsList = [];
  Future<void> loadPolitikNews(String kategori) async {
    await loadUserData();
    final data = await NewsClient.showSpesificNews("Olahraga");
    setState(() {
      newsList = data;
      isLoading = false;
    });
    print(user.membership);
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    User data = await UserClient.find(prefs.getInt('userId'));
    setState(() {
      user = data;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    loadPolitikNews("Olahraga");
    // print('lengt: ${newsList.length}');
    controller = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 55),
          child: Image.asset(
            'images/Tria News.png',
            width: 150,
            height: 200,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView(children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Yang Terbaru di Topik Olahraga',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      CarouselSlider(
                        carouselController: controller,
                        items: newsList
                            .map((item) => ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: SizedBox(
                                      height: 200,
                                      width: 260,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return DetailNews(
                                                    index: item.id);
                                              },
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                const begin = Offset(1.0, 0.0);
                                                const end = Offset.zero;
                                                const curve =
                                                    Curves.easeInOutCubic;
                                                var tween = Tween(
                                                        begin: begin, end: end)
                                                    .chain(CurveTween(
                                                        curve: curve));
                                                var offsetAnimation =
                                                    animation.drive(tween);

                                                return SlideTransition(
                                                  position: offsetAnimation,
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Image(
                                          image: decode(item.image!).image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      )),
                                ))
                            .toList(),
                        options: CarouselOptions(
                          height: 250,
                          autoPlay: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        child: DotsIndicator(
                          dotsCount: widget.items.length,
                          position: currentIndex,
                          onTap: (index) {
                            controller.animateToPage(index);
                          },
                          decorator: DotsDecorator(
                            color: Colors.grey,
                            activeColor: Colors.black,
                            size: const Size.square(12.0),
                            activeSize: const Size(24.0, 12.0),
                            activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Politik',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 110.0,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewsPageSpesific(
                                            kategori: "Politik",
                                          )));
                            },
                            child: const Text(
                              'Lihat Semua',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewsPageSpesific(
                                            kategori: "Politik",
                                          )));
                            },
                            child: SizedBox(
                              height: 150,
                              width: 330,
                              child: Image.network(
                                'https://awsimages.detik.net.id/community/media/visual/2023/04/04/ekonomi_169.jpeg?w=1200',
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Olahraga',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 110.0,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewsPageSpesific(
                                            kategori: "Olahraga",
                                          )));
                            },
                            child: const Text(
                              'Lihat Semua',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewsPageSpesific(
                                            kategori: "Olahraga",
                                          )));
                            },
                            child: SizedBox(
                              height: 150,
                              width: 330,
                              child: Image.network(
                                'https://res.cloudinary.com/dk0z4ums3/image/upload/v1614664554/attached_image/beragam-manfaat-olahraga-0-alodokter.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Kesehatan',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 100.0,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewsPageSpesific(
                                            kategori: "Kesehatan",
                                          )));
                            },
                            child: const Text(
                              'Lihat Semua',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NewsPageSpesific(
                                              kategori: "Kesehatan",
                                            )));
                              },
                              child: SizedBox(
                                height: 150,
                                width: 330,
                                child: Image.network(
                                  'https://img.antaranews.com/cache/1200x800/2023/03/31/photo_2023-03-31_22-13-00.jpg',
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Hiburan',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 110.0,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewsPageSpesific(
                                            kategori: "Hiburan",
                                          )));
                            },
                            child: const Text(
                              'Lihat Semua',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NewsPageSpesific(
                                              kategori: "Hiburan",
                                            )));
                              },
                              child: SizedBox(
                                height: 150,
                                width: 330,
                                child: Image.network(
                                  'https://www.zurich.co.id/-/media/project/zwp/indonesia/images/5_shutterstock_1041475570-1.jpg?la=id-id&mw=737&hash=82C6E377BF94B3D4BAC1E422566A0E48',
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Teknologi',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 110.0,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewsPageSpesific(
                                            kategori: "Teknologi",
                                          )));
                            },
                            child: const Text(
                              'Lihat Semua',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NewsPageSpesific(
                                              kategori: "Teknologi",
                                            )));
                              },
                              child: SizedBox(
                                height: 150,
                                width: 330,
                                child: Image.network(
                                  'https://images.bisnis.com/posts/2023/06/03/1661805/ilustrasi_ai.jpg',
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Internasional',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  Icons.card_membership,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 90.0,
                          ),
                          TextButton(
                            onPressed: () {
                              user.membership == "Standard"
                                  ? notifyMembership()
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NewsPageSpesific(
                                                kategori: "International",
                                              )));
                            },
                            child: const Text(
                              'Lihat Semua',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                user.membership == "Standard"
                                    ? notifyMembership()
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NewsPageSpesific(
                                                  kategori: "International",
                                                )));
                              },
                              child: SizedBox(
                                height: 150,
                                width: 330,
                                child: Image.network(
                                  fit: BoxFit.cover,
                                  'https://awsimages.detik.net.id/community/media/visual/2023/05/29/hubungan-internasional_169.jpeg?w=600&q=90',
                                ),
                              )),
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
            ),
    );
  }

  void notifyMembership() {
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
                    "Mohon Maaf",
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
                      "Anda harus menjadi member\nuntuk membaca berita ini",
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

  Image decode(image) {
    return Utility.imageFromBase64String(image);
  }
}
