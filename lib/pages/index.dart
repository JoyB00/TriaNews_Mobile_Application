import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:news_pbp/client/NewsClient.dart';
import 'package:news_pbp/entity/news.dart';
import 'package:news_pbp/image/image_setup.dart';
import 'package:news_pbp/pages/detailNews.dart';
import 'package:news_pbp/pages/editProfile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewsLandingPage extends StatefulWidget {
  const NewsLandingPage({super.key, this.id});
  final int? id;
  @override
  State<NewsLandingPage> createState() => _NewsLandingPage();
}

class _NewsLandingPage extends State<NewsLandingPage> {
  // Image convert = Image.asset('images/luffy.jpg');
  // Image? image;
  // File? userImage;
  bool isLoading = false;

  List<News> newsList = [];
  void refresh() async {
    final data = await NewsClient.fetchAll();
    setState(() {
      newsList = data;
      isLoading = false;
    });
  }

  // Future<void> loadDetailNews(int id) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   News news = await NewsClient.find(id);
  //   setState(() {
  //     prefs.setInt('newsId', news.id!);
  //   });
  // }

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
          : Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Row(
                      children: [
                        Icon(Icons.new_releases_rounded),
                        Text(
                          'Berita Terbaru',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  StaggeredGrid.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: [
                      StaggeredGridTile.count(
                        crossAxisCellCount: 3,
                        mainAxisCellCount: 2,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailNews(index: newsList[0].id)));
                            },
                            child: Image(
                              image: decode(newsList[0].image!).image,
                              fit: BoxFit.cover,
                            )),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 2,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailNews(index: newsList[1].id)));
                            },
                            child: Image(
                              image: decode(newsList[1].image!).image,
                              fit: BoxFit.cover,
                            )),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailNews(index: newsList[2].id)));
                            },
                            child: Image(
                              image: decode(newsList[2].image!).image,
                              fit: BoxFit.cover,
                            )),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailNews(index: newsList[3].id)));
                            },
                            child: Image(
                              image: decode(newsList[3].image!).image,
                              fit: BoxFit.cover,
                            )),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailNews(index: newsList[4].id)));
                            },
                            child: Image(
                              image: decode(newsList[4].image!).image,
                              fit: BoxFit.cover,
                            )),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailNews(index: newsList[5].id)));
                            },
                            child: Image(
                              image: decode(newsList[5].image!).image,
                              fit: BoxFit.cover,
                            )),
                      )
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Row(
                      children: [
                        Icon(Icons.newspaper_rounded),
                        Text(
                          'Semua Berita',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: newsList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Container(
                                margin: EdgeInsets.only(top: 1.h),
                                width: 100,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.black),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: SizedBox(
                                        width: 80,
                                        height: 130,
                                        child: decode(newsList[index].image!),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.h,
                                                vertical: 3.w)),
                                        Text(
                                          newsList[index].kategori!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          softWrap: true,
                                        ),
                                        SizedBox(
                                          width: 50.w,
                                          child: Text(
                                            newsList[index].judul!,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            softWrap: true,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
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
                        }),
                  ),
                ],
              ),
            ),
    );
  }

  Image decode(image) {
    return Utility.imageFromBase64String(image);
  }
}


// child: ListView.builder(itemCount: newsList.length,
//               itemBuilder: (context,index){
//                 return InkWell(
//                   onTap: () {
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //   builder: (context) =>
//                     //   DetailNews(
//                     //     index:
//                     //     newsList[index].id)));
//                 },
//                 child: Card(child: Row(
//                       children: [
//                         SizedBox(
//                           height: 100,
//                           width: 100,
//                           child: Image.file(File(newsList[index].image!),),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 10.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Title(color: Colors.black, child: Text("${newsList[index].date}",style: TextStyle(fontSize: 13.sp,))),
//                               Text(
//                                           "${newsList[index].kategori}",
//                                           style: TextStyle(
//                                               fontSize: 15.sp,
//                                               color: Colors.grey),
//                                         ),
                                        
//                             ],
//                           ),
//                         ),

//                       ],
//                     ),),);
//               },),

