import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:news_pbp/View/camera/camera.dart';
import 'package:news_pbp/database/sql_helper.dart';
import 'package:news_pbp/pages/updateProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final String? imagePath;
  final CameraController? cameraController;

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

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> user =
        await SQLHelper.getUser(prefs.getInt('userId') ?? 0);

    setState(() {
      id = user[0]['id'];
      userEmail = user[0]['email'];
      userNama = user[0]['username'];
      userNoTelp = user[0]['notelp'];
      userPass = user[0]['password'];
      userTglLahir = user[0]['dateofbirth'];
      image = user[0]['image'];
      if (image != null) {
        userImage = File(image!);
        convert = Image.file(userImage!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    loadUserData();

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Image.asset(
            'images/Tria News.png',
            width: 150,
            height: 150,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
            SizedBox(
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image(
                  image: convert.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 0.0),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      camOrGallery(context, id);
                    },
                    child: const Text(
                      'Ganti Profile',
                      style: TextStyle(color: Color.fromRGBO(249, 148, 23, 1)),
                    ),
                  ),
                  const Text(
                    "Selamat Datang",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(122, 149, 229, 1)),
                  ),
                  Text(
                    //show username from prof
                    userNama,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(122, 149, 229, 1)),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: "Email : $userEmail",
                        labelStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: "No Telepon : $userNoTelp",
                        labelStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Tanggal Lahir : $userTglLahir',
                        labelStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UpdateProfilePage()));
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
    );
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
  await SQLHelper.addImage(result, id);
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
