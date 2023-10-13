import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  int userId = 0;
  String userEmail = '';
  String userNama = '';
  String userNoTelp = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? 0;
      userEmail = prefs.getString('userEmail') ?? '';
      userNama = prefs.getString('userNama') ?? '';
      userNoTelp = prefs.getString('userNoTelp') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ID Pengguna: $userId'),
            Text('Email: $userEmail'),
            Text('Nama: $userNama'),
            Text('NoTelepon: $userNoTelp'),
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
}

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  UpdateProfilePageState createState() => UpdateProfilePageState();
}

class UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perbarui Profil'),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nama'),
          ),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'Nomor Telepon'),
          ),
          ElevatedButton(
            onPressed: () async {
              await SharedPreferences.getInstance().then((prefs) {
                prefs.setString('userNama', nameController.text);
                prefs.setString('userNoTelp', phoneController.text);
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }
}
