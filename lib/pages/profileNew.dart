import 'package:flutter/material.dart';
import 'package:news_pbp/database/sql_helper.dart';
import 'package:news_pbp/pages/updateProfile.dart';

class ProfilePage extends StatefulWidget {
  final int id;
  const ProfilePage({super.key, required this.id});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  int userId = 0;
  String userEmail = '';
  String userNama = '';
  String userNoTelp = '';
  String userPass = '';
  String userTglLahir = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> user = SQLHelper.getUserbyID(widget.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('images/luffy.jpg'),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 0.0),
              child: Column(
                children: [
                  const Text(
                    "Selamat Datang",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  Text(
                    user[username];
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
                        builder: (context) => UpdateProfilePage(
                              user: widget.user,
                            )));
              },
              child: const Text('Perbarui Profil'),
            ),
          ],
        ),
      ),
    );
  }
}
