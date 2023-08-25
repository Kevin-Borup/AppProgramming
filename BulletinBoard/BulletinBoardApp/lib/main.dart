import 'package:bulletin_board_app/data/bloc/image_model_bloc.dart';
import 'package:bulletin_board_app/data/models/image_model.dart';
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
      home: BlocProvider<ImageModelBloc>(
        create: (context) => ImageModelBloc(),
        child: const MyHomePage(title: 'Bulletin Board')
      ) ,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  CameraDescription? availableCam;

  void _findCamera() async {
    final cameras = await availableCameras();
    availableCam = cameras.first;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget availableCamScreen(){
    if (availableCam != null){
      return CameraScreen(camera: availableCam!);
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
    _findCamera();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetScreens = <Widget>[
      const BoardScreen(),
      availableCamScreen(),
      const GalleryScreen()
    ];

    // imgs.add(value)
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: _widgetScreens[_selectedIndex],
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(child: Text("Menu")),
              ListTile(
                title: const Text('Bulletin Board'),
                selected: _selectedIndex == 0,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(0);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Camera'),
                selected: _selectedIndex == 1,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(1);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Gallery'),
                selected: _selectedIndex == 2,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(2);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
    );
  }
}
