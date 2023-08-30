import 'package:flutter/material.dart';
import 'package:scrum_board_app/screens/scrum_board_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrum Board',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          toolbarHeight: 45,
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          elevation: 20,
        ),
        useMaterial3: true
      ),
      home: const ManagerPage(title: 'Scrum Board'),
    );
  }
}

class ManagerPage extends StatefulWidget {
  const ManagerPage({super.key, required this.title});
  final String title;
  @override
  State<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // int _selectedIndex = 0;

  // Reloads body, with new index, loading a different page.
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // Method to open and close menu drawer.
    // Miniminzes Context pops.
    // toggleDrawer() async {
    //   if (_scaffoldKey.currentState != null) {
    //     if (_scaffoldKey.currentState!.isDrawerOpen) {
    //       _scaffoldKey.currentState?.openEndDrawer();
    //     } else {
    //       _scaffoldKey.currentState?.openDrawer();
    //     }
    //   }
    // }

    // Widget list to cycle through
    List<Widget> widgetScreens = <Widget>[
       const ScrumBoardScreen(),
      // camScreen(),
      // const GalleryScreen()
    ];

    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // body: SafeArea(child: widgetScreens[_selectedIndex])
      body: SafeArea(child: widgetScreens[0])
      );

  }
}
