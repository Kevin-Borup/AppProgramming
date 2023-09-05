import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrumboard_app/data/blocs/card_bloc.dart';
import 'package:scrumboard_app/screens/scrum_board_screen.dart';
import 'package:scrumboard_app/services/locator_service.dart';
import 'package:scrumboard_app/widgets/blurred_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<CardBloc>(create: (cardContext) => CardBloc())
          ],
          child: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AssetImage> backgrounds = <AssetImage>[
    const AssetImage("assets/images/alpine-blue.jpg"),
    const AssetImage("assets/images/alpine-green.jpg"),
    const AssetImage("assets/images/alpine-grey.jpg"),
  ];

  // Obtain shared preferences.
  late int bgIndex = 0;

  Future<void> _setupPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bgIndex = prefs.getInt('bgIndex') ?? 0;
    bgIndex++;

    if (bgIndex >= 3) bgIndex = 0;

    prefs.setInt('bgIndex', bgIndex);
  }

  @override
  Widget build(BuildContext context) {
    _setupPrefs();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: BlurredAppBar(),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: backgrounds[bgIndex],
              fit: BoxFit.cover,
            ),
          ),
          child: const SafeArea(child: ScrumBoardScreen()),

      ),
    );
  }
}
