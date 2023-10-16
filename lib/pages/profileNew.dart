import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_pbp/database/sql_helper.dart';
import 'package:news_pbp/pages/updateProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:news_pbp/entity/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String userEmail = '';
  String userNama = '';
  String userNoTelp = '';
  String userPass = '';
  String userTglLahir = '';

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
      userEmail = user[0]['email'];
      userNama = user[0]['username'];
      userNoTelp = user[0]['notelp'];
      userPass = user[0]['password'];
      userTglLahir = user[0]['dateofbirth'];
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
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: "No Telepon : $userNoTelp",
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Tanggal Lahir : $userTglLahir',
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // Text('Nama: $userNama'),
            // Text('Email: $userEmail'),
            // Text('No Telepon: $userNoTelp'),
            // Text('Tanggal Lahir: $userTglLahir'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateProfilePage()));
              },
              child: const Text('Perbarui Profil'),
            ),
          ],
        ),
      ),
    );
  }
}
