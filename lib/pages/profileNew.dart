import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:news_pbp/View/camera/camera.dart';
import 'package:news_pbp/client/UserClient.dart';
// import 'package:news_pbp/database/sql_helper.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/pages/updateProfile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final String? imagePath;
  final CameraController? cameraController;
  //final int? id;

  const ProfilePage({Key? key, this.imagePath, this.cameraController})
      : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String userEmail = '';
  String userNama = '';
  String userNoTelp = '';
  String userPass = '';
  String userTglLahir = '';
  var id = 0;
  String? image;
  File? userImage;
  Image convert = Image.asset('images/luffy.jpg');

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    User user = await UserClient.find(prefs.getInt('userId'));

    setState(() {
      id = user.id!;
      userEmail = user.email!;
      userNama = user.username!;
      userNoTelp = user.notelp!;
      userPass = user.password!;
      userTglLahir = user.dateofbirth!;
      image = user.image;
      if (image != null) {
        userImage = File(image!);
        convert = Image.file(userImage!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    loadUserData();
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
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(vertical: 3.0.h)),
                SizedBox(
                  width: 25.h,
                  height: 50.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80.h),
                    child: Image(
                      image: convert.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0.h, vertical: 2.0.w),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          camOrGallery(context, id);
                        },
                        child: const Text(
                          'Ganti Profile',
                          style:
                              TextStyle(color: Color.fromRGBO(249, 148, 23, 1)),
                        ),
                      ),
                      Text(
                        "Selamat Datang",
                        style: TextStyle(
                            fontSize: 23.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(122, 149, 229, 1)),
                      ),
                      Text(
                        //show username from prof
                        userNama,
                        style: TextStyle(
                            fontSize: 23.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(122, 149, 229, 1)),
                      ),
                      Padding(padding: EdgeInsets.all(1.0.h)),
                      TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText: "Email : $userEmail",
                            labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                      ),
                      Padding(padding: EdgeInsets.all(1.h)),
                      TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText: "No Telepon : $userNoTelp",
                            labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                      ),
                      Padding(padding: EdgeInsets.all(1.h)),
                      TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText: 'Tanggal Lahir : $userTglLahir',
                            labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.h),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProfilePage(id: id)));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(122, 149, 229, 1)),
                    ),
                    child: const Text('Perbarui Profil'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Image viewImage(File image) {
    return Image.file(image);
  }
}

_getFromGallery(var id) async {
  // ignore: deprecated_member_use
  String? imageFile;
  PickedFile? pickedFile = await ImagePicker().getImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    imageFile = pickedFile.path;
    // imageFile = File(pickedFile.path);
    editImage(id, imageFile);
  }
}

Future<void> editImage(int id, String result) async {
  User temp = await UserClient.find(id);

  User user = temp;
  user.image = result;

  await UserClient.update(user);
}

void camOrGallery(BuildContext context, var id) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Pilih Foto'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextButton(
                child: const Text('Camera'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CameraView(),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text('Galery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _getFromGallery(id);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
