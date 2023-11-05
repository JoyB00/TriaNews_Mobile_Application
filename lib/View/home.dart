import 'package:flutter/material.dart';
import 'package:news_pbp/pages/newsPage.dart';
import 'package:news_pbp/pages/profileNew.dart';

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

  @override
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
      const ProfilePage(),
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
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.home,
                color: Color.fromRGBO(249, 148, 23, 1),
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.list,
                color: Color.fromRGBO(249, 148, 23, 1),
              ),
              label: 'List'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_2,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.person_2,
                color: Color.fromRGBO(249, 148, 23, 1),
              ),
              label: 'Profile'),
        ],
        backgroundColor: Colors.black,
        fixedColor: const Color.fromRGBO(249, 148, 23, 100),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
