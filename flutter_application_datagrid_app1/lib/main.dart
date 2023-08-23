import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_datagrid_app1/data/http_override.dart';
import 'package:flutter_application_datagrid_app1/providers/pic_image_provider.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides(); // NOT PRODUCTION FRIENDLY CODE
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
