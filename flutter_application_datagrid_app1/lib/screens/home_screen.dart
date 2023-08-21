import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.blueGrey,
    minimumSize: const Size(20, 5),
    maximumSize: const Size(5, 5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(3)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
          child: ListView(
        children: <Widget>[
          Container(
              height: 20,
              padding: const EdgeInsets.only(top: 30),
              child: const Text(
                "Welcome to Datagrid!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
          Container(
            height: 20,
            child: TextButton(
                style: raisedButtonStyle,
                onPressed: () {},
                child: Text('Upload Image')),
          ),
          Container(
              child: GridView.count(
            crossAxisCount: 5,
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: Text("PicLogo"),
              ),
              Text("PicName", style: TextStyle(backgroundColor: Colors.grey)),
              Text("PicHeight", style: TextStyle(backgroundColor: Colors.grey)),
              Text("PicWidth", style: TextStyle(backgroundColor: Colors.grey)),
              Text("PicType", style: TextStyle(backgroundColor: Colors.grey))
            ],
          ))
        ],
      )),
    );
  }
}
