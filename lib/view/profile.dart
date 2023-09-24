import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Developer Profile"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(15.0)),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30, bottom: 5),
                child: Text(
                  "Hy, Salam Kenal !",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30, bottom: 15),
                child: Text(
                  "Yuk kenalan dengan orang orang hebat dibelakang layar terbentuknya aplikasi ini",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

            //William Juvent
            Container(
              margin: EdgeInsets.only(bottom: 8, top: 15, left: 30, right: 30),
              width: 350,
              height: 120,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: Offset(2, 3))
                ],
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.blue,
                  width: 3.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        " William Juvent",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        "210711067",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "'Hidup Seperti Larry'",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  Container(
                      width: 150,
                      margin: EdgeInsets.only(left: 21),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.blue,
                        border: Border.all(
                          color: Colors.blue,
                          width: 3.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/Wilju.jpeg'),
                      ))
                ],
              ),
            ),

            //Dendy
            Container(
              margin: EdgeInsets.all(8.0),
              width: 350,
              height: 120,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: Offset(2, 3))
                ],
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.blue,
                  width: 3.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        " Dendy Pramartha",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 21.4,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        "210711095",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "'Let's Goww!'",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  Container(
                      width: 150,
                      margin: EdgeInsets.only(left: 21),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.blue,
                        border: Border.all(
                          color: Colors.blue,
                          width: 3.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/Dendy.jpeg'),
                      ))
                ],
              ),
            ),

            //Jeanny
            Container(
              margin: EdgeInsets.all(8.0),
              width: 350,
              height: 120,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: Offset(2, 3))
                ],
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.blue,
                  width: 3.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        " Jeanny Leviana",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        "210711142",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "'Semangat Nugas!'",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  Container(
                      width: 150,
                      margin: EdgeInsets.only(left: 27),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.blue,
                        border: Border.all(
                          color: Colors.blue,
                          width: 3.0,
                        ),
                      ),
                      child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('images/Jeanny.jpeg')))
                ],
              ),
            ),

            // Joel
            Container(
              margin: EdgeInsets.all(8.0),
              width: 350,
              height: 120,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: Offset(2, 3))
                ],
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.blue,
                  width: 3.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        " Joel Christian",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        "210711413",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "'Jalani dengan jalan-jalan'",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  Container(
                      width: 150,
                      margin: EdgeInsets.only(left: 31),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.blue,
                        border: Border.all(
                          color: Colors.blue,
                          width: 3.0,
                        ),
                      ),
                      child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('images/Joel.jpeg')))
                ],
              ),
            ),

            // Joseph
            Container(
              margin: EdgeInsets.all(8.0),
              width: 350,
              height: 120,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: Offset(2, 3))
                ],
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.blue,
                  width: 3.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        " Joseph Putra",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        "210711518",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "'Just Do It!'",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  Container(
                      width: 150,
                      margin: EdgeInsets.only(left: 38),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.blue,
                        border: Border.all(
                          color: Colors.blue,
                          width: 3.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/Joseph.jpeg'),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
