import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 55),
          child: Image.asset(
            'images/Tria News.png',
            width: 150,
            height: 200,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            width: 500,
            height: 70.0,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(122, 149, 229, 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: const Text(
                    "Tentang Kami",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 620,
            width: 395,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/about.png'), fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
