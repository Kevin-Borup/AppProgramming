
import 'package:bulletin_board_app/data/bloc/image_bloc.dart';
import 'package:bulletin_board_app/data/bloc/image_model_bloc.dart';
import 'package:bulletin_board_app/screens/board_screen.dart';
import 'package:bulletin_board_app/screens/camera_screen.dart';
import 'package:bulletin_board_app/screens/gallery_screen.dart';
import 'package:bulletin_board_app/services/service_locator.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupApi();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ImageBloc>(
              create: (BuildContext context) => ImageBloc(),
            ),
            BlocProvider<ImageModelBloc>(
              create: (BuildContext context) => ImageModelBloc(),
            ),
          ],
          child: const MyHomePage(title: 'Bulletin Board'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CameraDescription>? cameras = null;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _findCameras() async {
    cameras = await availableCameras();
  }

  Widget camScreen(){
    if (cameras != null){
      return CameraScreen(cameras: cameras!);
    } else {
      return Scaffold(
        body: Container(
          color: Colors.black,
          child: const Text(
            "No camera found",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }


  @override
  void initState(){
    super.initState();
    _findCameras();
  }

  @override
  Widget build(BuildContext context) {
    toggleDrawer() async {
      if (_scaffoldKey.currentState != null){
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          _scaffoldKey.currentState?.openEndDrawer();
        } else {
          _scaffoldKey.currentState?.openDrawer();
        }
      }
    }

    List<Widget> widgetScreens = <Widget>[
      const BoardScreen(),
      camScreen(),
      const GalleryScreen()
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: widgetScreens[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text("Menu")),
            ListTile(
              leading: const Icon(Icons.developer_board_sharp),
              title: const Text('Bulletin Board'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Navigate to other page and pop drawer
                toggleDrawer();
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              selected: _selectedIndex == 1,
              onTap: () {
                // Navigate to other page and pop drawer
                toggleDrawer();
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_album_outlined),
              title: const Text('Gallery'),
              selected: _selectedIndex == 2,
              onTap: () {
                // Navigate to other page and pop drawer
                toggleDrawer();
                _onItemTapped(2);
              },
            )
          ],
        ),
      ),
    );
  }
}
