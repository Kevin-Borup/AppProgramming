import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.blueGrey,
      fixedSize: const Size(30, 50));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          const Text(
            "Welcome to Datagrid!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 30,
            width: 30,
            child: TextButton(
                style: raisedButtonStyle,
                onPressed: () {},
                child: const Text('Upload Image')),
          )
        ],
      ),
    );
  }
}
