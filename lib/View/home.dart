import 'package:flutter/material.dart';
// import 'package:news_pbp/View/inputanberita.dart';
// import 'package:news_pbp/entity/user.dart';
// import 'package:news_pbp/pages/grid.dart';
import 'package:news_pbp/View/profile.dart';
import 'package:news_pbp/pages/newsPage.dart';
import 'package:news_pbp/pages/profileNew.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:news_pbp/database/sql_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Future<void> loadUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<Map<String, dynamic>> user = await SQLHelper.getUser(prefs.getInt('userId') ?? 0);
  // }

  void initState() {
    super.initState();
    _widgetOptions = [
      const NewsPage(),
      // index 1
      const Center(
        child: Text(
          'On Progress',
        ),
      ),
      // index 2
      const ProfileView(),
      ProfilePage(),
      // const InputanBerita(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.blue,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                color: Colors.blue,
              ),
              label: 'List'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.group,
                color: Colors.blue,
              ),
              label: 'Anggota'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_2,
                color: Colors.blue,
              ),
              label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
