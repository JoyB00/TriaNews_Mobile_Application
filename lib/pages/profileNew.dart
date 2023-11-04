import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:news_pbp/View/camera/camera.dart';
import 'package:news_pbp/database/sql_helper.dart';
import 'package:news_pbp/pages/updateProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_pbp/View/inputanberita.dart';

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
  String? image;
  File? userImage;

  File? fileResult;
  @override
  void initState() {
    super.initState();
    loadUserData();
    fileResult = File(widget.imagePath.toString());
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> user =
        await SQLHelper.getUser(prefs.getInt('userId') ?? 0);

    setState(() {
      userEmail = user[0]['email'];
      userNama = user[0]['username'];
      userNoTelp = user[0]['notelp'];
      userPass = user[0]['password'];
      userTglLahir = user[0]['dateofbirth'];
      image = user[0]['image'];
      if(image != null){
        userImage = File(image!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    loadUserData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
            CircleAvatar(
              radius: 80,
              backgroundImage: (image !=null ? AssetImage(image!) : const AssetImage('images/luffy.jpg')),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 0.0),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CameraView()));
                    },
                    child: const Text('Ganti Profile'),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _getFromGallery(fileResult!);
                  //   },
                  //   child: Text("PICK FROM GALLERY"),
                  // ),
                  const Text(
                    "Selamat Datang",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  Text(
                    //show username from prof
                    userNama,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UpdateProfilePage()));
              },
              child: const Text('Perbarui Profil'),
            ),
          ],
        ),
      ),
    );
  }

  Image viewImage(File image){
    return Image.file(image);
  }
}

_getFromGallery(File imageFile) async {
  PickedFile? pickedFile = await ImagePicker().getImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    imageFile = File(pickedFile.path);
  }

  
}
