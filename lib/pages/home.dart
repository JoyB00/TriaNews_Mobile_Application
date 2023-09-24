import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/news.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _cells = 8;
  final double _containerSizeSmall = 120;
  final double _containerSizeLarge = 260;
  final double _padding = 10;
  int _clicked = 0;
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Atma News',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.blueGrey,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchAnchor(builder:
                      (BuildContext context, SearchController controller) {
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
                      trailing: <Widget>[
                        Tooltip(
                          message: 'Change brightness mode',
                          child: IconButton(
                            isSelected: isDark,
                            onPressed: () {
                              setState(() {
                                isDark = !isDark;
                              });
                            },
                            icon: const Icon(Icons.wb_sunny_outlined),
                            selectedIcon:
                                const Icon(Icons.brightness_2_outlined),
                          ),
                        )
                      ],
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
              Container(
                child: SingleChildScrollView(
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
                              child: Center(
                                  child: Image.network(choices[col].link)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.bookmark,
                  ),
                  label: 'BookMark'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: 'Profile'),
            ],
          ),
        ));
  }
}
