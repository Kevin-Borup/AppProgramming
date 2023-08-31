import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrumboard_app/data/blocs/card_bloc.dart';
import 'package:scrumboard_app/screens/scrum_board_screen.dart';
import 'package:scrumboard_app/services/locator_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupApi();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrum Board App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CardBloc>(
              create: (cardContext) => CardBloc())
        ],
      child: const MyHomePage(title: 'Scrum Board'),)
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const SafeArea(child: ScrumBoardScreen())
    );
  }
}
