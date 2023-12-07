import 'package:flutter/material.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/pages/FYPPage.dart';
import 'package:news_pbp/pages/newsPage.dart';
import 'package:news_pbp/pages/newsPageViewer.dart';
import 'package:news_pbp/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final int? id;
  const HomePage({Key? key, this.id}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String userRole = '';
  bool isLoading = false;

  Future<void> loadHomePage() async {
    final prefs = await SharedPreferences.getInstance();
    User user = await UserClient.find(prefs.getInt('userId'));
    print(user.role);
    setState(() {
      userRole = user.role!;
      isLoading = false;
    });

    _widgetOptions = [
      userRole == 'viewer' ? const NewsPageViewer() : const NewsPage(),
      const FYPPage(),
      const ProfilePageNew(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    loadHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
              size: 48,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.explore,
                color: Colors.white,
                size: 48,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.white,
                size: 48,
              ),
              label: ''),
        ],
        backgroundColor: Colors.black,
        fixedColor: const Color.fromRGBO(249, 148, 23, 100),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
