import 'package:flutter/material.dart';
import 'package:news_pbp/data/news.dart';

class Grid extends StatefulWidget {
  const Grid({super.key});

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  final int _cells = 8;
  final double _containerSizeSmall = 120;
  final double _containerSizeLarge = 260;
  final double _padding = 10;
  int _clicked = 0;
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Atma News',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                );
              }, suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                return List<ListTile>.generate(5, (int index) {
                  final String item = 'item $index';
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      setState(() {
                        controller.closeView(item);
                      });
                    },
                  );
                });
              }),
            ),
          ),
          SingleChildScrollView(
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
                          _clicked != col + 1
                              ? _clicked = col + 1
                              : _clicked = 0;
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
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Center(child: Image.network(choices[col].link)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
