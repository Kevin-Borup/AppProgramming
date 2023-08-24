import 'package:flutter/material.dart';
import 'package:flutter_application_datagrid_app1/providers/pic_image_provider.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => PicImageProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Datagrid App",
      home: HomeScreen(),
    );
  }
}
