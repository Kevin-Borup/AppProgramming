import 'package:flutter/material.dart';
import 'package:flutter_application_datagrid_app1/blocs/pic_cons_bloc.dart';
import 'package:flutter_application_datagrid_app1/services/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/screens.dart';

void main() {
  setupApi();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Datagrid App",
      home: BlocProvider<PicConsBloc>(
        create: (context) => PicConsBloc(),
        child: HomeScreen(),
      ),
    );
  }
}
