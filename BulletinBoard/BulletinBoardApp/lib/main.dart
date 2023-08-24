import 'package:bulletin_board_app/data/bloc/image_model_bloc.dart';
import 'package:bulletin_board_app/data/models/image_model.dart';
import 'package:bulletin_board_app/screens/board_screen.dart';
import 'package:bulletin_board_app/services/service_locator.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<ImageModelBloc>(
        create: (context) => ImageModelBloc(),
        child: const MyHomePage(title: 'Flutter Demo Home Page')
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
  @override
  Widget build(BuildContext context) {
    // imgs.add(value)
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: const BoardScreen());
  }
}
