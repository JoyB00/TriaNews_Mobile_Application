import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/image/image_setup.dart';
import 'package:news_pbp/pages/aboutPage.dart';
import 'package:news_pbp/pages/bookmarkPage.dart';
import 'package:news_pbp/pages/editProfile.dart';
import 'package:news_pbp/pages/kritikSaran.dart';
import 'package:news_pbp/pages/listTestimoniPage.dart';
import 'package:news_pbp/pages/loginView.dart';
import 'package:news_pbp/pages/membership.dart';
import 'package:news_pbp/pages/newsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageNew extends StatefulWidget {
  final String? imagePath;
  final CameraController? cameraController;
  //final int? id;

  const ProfilePageNew({Key? key, this.imagePath, this.cameraController})
      : super(key: key);

  @override
  State<ProfilePageNew> createState() => _ProfilePageNewState();
}

class _ProfilePageNewState extends State<ProfilePageNew> {
  String userEmail = '';
  String userNama = '';
  String userNoTelp = '';
  String userPass = '';
  String userTglLahir = '';
  String userMembership = '';
  String role = '';
  var id = 0;
  String? image;
  File? userImage;
  Image convert = Image.asset('images/luffy.jpg');
  bool isLoading = false;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    User user = await UserClient.find(prefs.getInt('userId'));
    setState(() {
      id = user.id!;
      userEmail = user.email!;
      userMembership = user.membership!;
      userNama = user.username!;
      userNoTelp = user.notelp!;
      userPass = user.password!;
      userTglLahir = user.dateofbirth!;
      image = user.image;
      role = user.role!;
      print(user.membership);
      if (image != null) {
        userImage = File(image!);
        // convert = Image.file(userImage!);
        convert = decode(user.image);
      } else {
        convert = Image.asset('images/luffy.jpg');
      }
      isLoading = false;
    });
  }

  Image decode(image) {
    return Utility.imageFromBase64String(image);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 500,
                    height: 250.0,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(122, 149, 229, 1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 50.0),
                          child: const Text(
                            "My Profile",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                left: 20.0,
                              ),
                              width: 120.0,
                              height: 120.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Image(
                                  image: convert.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                userMembership == 'Gold'
                                    ? SizedBox(
                                        width: 230,
                                        child: Row(children: [
                                          Container(
                                            width: 40,
                                            height: 45,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'images/gold.png'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                        ]))
                                    : userMembership == 'Platinum'
                                        ? SizedBox(
                                            width: 230,
                                            child: Row(children: [
                                              Container(
                                                width: 40,
                                                height: 45,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'images/plat.png'),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 7,
                                              ),
                                            ]))
                                        : const SizedBox(),
                                Text(
                                  userNama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 3.0,
                                ),
                                Text(
                                  userEmail,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                SizedBox(
                                  height: 20.0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const EditProfilePage(),
                                        ),
                                      ).then((_) => loadUserData());
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(122, 149, 229, 1),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: const BorderSide(
                                                color: Colors.white)),
                                      ),
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                      ),
                                    ),
                                    child: const Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      role == 'viewer'
                          ? ListTile(
                              leading: const Icon(
                                Icons.card_membership_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                              title: Container(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const MembershipPage(),
                                      ),
                                    ).then((_) => loadUserData());
                                  },
                                  child: const Text(
                                    "Membership",
                                    style: TextStyle(
                                        fontSize: 25.0, color: Colors.black),
                                  ),
                                ),
                              ),
                              subtitle: const Text(
                                "Dapatkan informasi berita yang lebih luas, melalui membership",
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 40.0,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MembershipPage(),
                                    ),
                                  ).then((_) => loadUserData());
                                },
                              ))
                          : ListTile(
                              leading: const Icon(
                                Icons.newspaper_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                              title: Container(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const NewsPage(),
                                      ),
                                    ).then((_) => loadUserData());
                                  },
                                  child: const Text(
                                    "Kelola Berita",
                                    style: TextStyle(
                                        fontSize: 25.0, color: Colors.black),
                                  ),
                                ),
                              ),
                              subtitle: const Text(
                                "Sebagai Admin anda bisa mengelola berita yang ada dalam aplikasi",
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 40.0,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const NewsPage(),
                                    ),
                                  ).then((_) => loadUserData());
                                },
                              )),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.4,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      ListTile(
                          leading: const Icon(
                            Icons.bookmark_border_rounded,
                            size: 30,
                            color: Colors.black,
                          ),
                          title: Container(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BookmarkList(
                                      id: id,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Bookmarks",
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.black),
                              ),
                            ),
                          ),
                          subtitle: const Text(
                            "Berita yang sudah anda simpan, bisa anda baca kembali di Bookmarks",
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.chevron_right_rounded,
                              size: 40.0,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookmarkList(
                                    id: id,
                                  ),
                                ),
                              );
                            },
                          )),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.4,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      ListTile(
                          leading: const Icon(
                            Icons.message_sharp,
                            size: 30,
                            color: Colors.black,
                          ),
                          title: Container(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const KritikSaran(
                                      rating: null,
                                      deskripsi: null,
                                      id: null,
                                    ),
                                  ),
                                ).then((_) => loadUserData());
                              },
                              child: const Text(
                                "Kritik & Saran",
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.black),
                              ),
                            ),
                          ),
                          subtitle: const Text(
                            "Bantu kami untuk selalu menghadirkan kualitas konten yang baik melalui kritik dan saran anda",
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.chevron_right_rounded,
                              size: 40.0,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const KritikSaran(
                                    rating: null,
                                    deskripsi: null,
                                    id: null,
                                  ),
                                ),
                              );
                            },
                          )),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.4,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      ListTile(
                          leading: const Icon(
                            Icons.rate_review_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                          title: Container(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ListTestimoni(),
                                  ),
                                ).then((_) => loadUserData());
                              },
                              child: const Text(
                                "Testimoni User",
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.black),
                              ),
                            ),
                          ),
                          subtitle: const Text(
                            "Segala bentuk saran serta kritik dari berbagai pengguna dapat anda lihat disini",
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.chevron_right_rounded,
                              size: 40.0,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ListTestimoni(),
                                ),
                              );
                            },
                          )),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.4,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      ListTile(
                          leading: const Icon(
                            Icons.question_mark_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                          title: Container(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AboutPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Tentang Tria News",
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.black),
                              ),
                            ),
                          ),
                          subtitle: const Text(
                            "Informasi mengenai Tria News dapat anda lihat disini",
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.chevron_right_rounded,
                              size: 40.0,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AboutPage(),
                                ),
                              );
                            },
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SizedBox(
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoginView(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(122, 149, 229, 1),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 90.0),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.door_back_door,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  )
                ],
              ),
            ),
    );
  }
}
