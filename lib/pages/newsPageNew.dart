// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:news_pbp/client/NewsClient.dart';

// import 'package:news_pbp/entity/news.dart';

// import 'package:news_pbp/pages/detailNews.dart';

// import 'package:responsive_sizer/responsive_sizer.dart';

// class NewsPageNew extends ConsumerWidget {
//   NewsPageNew({super.key});

//   final listNewsProvider = FutureProvider<List<News>>((ref) async {
//     return await NewsClient.fetchAll();
//   });

// //  Future<void> loadUserData(int id) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     News user = await NewsClient.find(prefs.getInt('userId'));

// //     setState(() {
// //       prefs.setInt('newsId', news[0]['id']);
// //     });
// //   }

//   void onDelete(id, context, ref) async {
//     try {
//       await NewsClient.destroy(id);
//       ref.refresh(listNewsProvider);
//       // showSnackBar(context, "Delete Success", Colors.green);
//     } catch (e) {
//       // showSnackBar(context, e.toString(), Colors.red);
//     }
//   }

//   ListTile scrollViewItem(News n, context, ref) => ListTile(
//         title: Container(
//             margin: EdgeInsets.only(top: 0.5.h, left: 3.w, right: 3.w),
//             width: 100.w,
//             height: 27.h,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5.0), color: Colors.white),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 SizedBox(
//                   width: 20.w,
//                   height: 90.h,
//                   child: Image.file(
//                     File(n.image!),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 2.h, vertical: 2.w)),
//                     Text(
//                       n.tanggal!,
//                       style: TextStyle(fontSize: 13.sp, color: Colors.grey),
//                     ),
//                     SizedBox(
//                       width: 50.w,
//                       child: Text(
//                         n.judul!,
//                         style: TextStyle(
//                           fontSize: 20.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 4,
//                         softWrap: true,
//                       ),
//                     ),
//                     Text(
//                       n.kategori!,
//                       style: TextStyle(fontSize: 15.sp, color: Colors.grey),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         // Future<User> user = UserClient.find(n.id);
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DetailNews(index: n.id)));
//                       },
//                       child: const Text(
//                         'Lihat Detail',
//                         style:
//                             TextStyle(color: Color.fromRGBO(249, 148, 23, 1)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             )),
//       );

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     var listener = ref.watch(listNewsProvider);
//      return Scaffold(
//         appBar: AppBar(
//           title: Image.asset(
//             'images/Tria News.png',
//             width: 20.h,
//             height: 20.w,
//           ),
//           backgroundColor: Colors.black,
//           actions: [
//             IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: () async {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const InputanBerita(
//                               image: null,
//                               id: null,
//                               judul: null,
//                               author: null,
//                               deskripsi: null,
//                               kategori: null,
//                               date: null,
//                             )),
//                   ).then((_) => refresh());
//                 }),
//             IconButton(icon: const Icon(Icons.clear), onPressed: () async {})
//           ],
//         ),
//         body: Column(children: [
//           TextButton(
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const BarcodeScannerPageView()));
//             },
//             child: const Text(
//               'Cari Berita Melalui Qr Code',
//               style: TextStyle(color: Color.fromRGBO(122, 149, 229, 1)),
//             ),
//           ),
        
        
        
        
        
        
        
//         child: listener.when(
//           data: (barangs) => SingleChildScrollView(
//             child: Column(
//                 children: barangs
//                     .map((barang) => scrollViewItem(barang, context, ref))
//                     .toList()),
//           ),
//           error: (err, s) => Center(child: Text(err.toString())),
//           loading: () => const Center(
//             child: CircularProgressIndicator(),
//           ),
//         ));
//   }
// }
