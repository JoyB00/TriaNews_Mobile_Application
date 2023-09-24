import 'package:flutter/material.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Demo")),
        body: const Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final int _cells = 8;
  final double _containerSizeSmall = 120;
  final double _containerSizeLarge = 260;
  final double _padding = 10;
  int _clicked = 0;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
        height: size.height,
        child: Wrap(
          children: List.generate(
            _cells,
            (col) => Padding(
              padding: EdgeInsets.all(_padding),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _clicked != col + 1 ? _clicked = col + 1 : _clicked = 0;
                  });
                },
                child: Container(
                  height: _clicked == col + 1
                      ? _containerSizeLarge
                      : _containerSizeSmall,
                  width: _clicked == col + 1
                      ? _containerSizeLarge
                      : _containerSizeSmall,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Center(child: Text('${col + 1}')),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
