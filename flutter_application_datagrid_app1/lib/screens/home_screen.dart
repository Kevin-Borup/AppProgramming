import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_datagrid_app1/models/models.dart';
import 'package:flutter_application_datagrid_app1/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';


import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.blueGrey,
  );

  List<PictureContainer> pictureCons = <PictureContainer>[];
  late PictureDataSource pictureConsDataSource;


        
  @override
  void initState() {
    super.initState();
    pictureCons = getPictureData();
    pictureConsDataSource = PictureDataSource(pictureData: pictureCons);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 20),
              child: const Text(
                "Welcome to Datagrid!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              )),
          Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: 50,
                width: 150,
                child: TextButton(
                    style: raisedButtonStyle,
                    onPressed: ,
                    child: const Text('Upload Image')),
              )),
          SfDataGrid(
              source: pictureConsDataSource,
              columnWidthMode: ColumnWidthMode.fill,
              columns: <GridColumn>[
                GridColumn(
                    columnName: "Name",
                    label: Container(
                        padding: EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Name',
                        ))),
                GridColumn(
                    columnName: "Height",
                    label: Container(
                        padding: EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Height',
                        ))),
                GridColumn(
                    columnName: "Width",
                    label: Container(
                        padding: EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Width',
                        ))),
                GridColumn(
                    columnName: "FillType",
                    label: Container(
                        padding: EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: Text(
                          'FillType',
                        ))),
              ])
        ],
      )),
    );
  }

  List<PictureContainer> getPictureData() {
    Random random = Random();

    return [
      PictureContainer("PicName1", random.nextInt(100) + 700,
          random.nextInt(100) + 400, FillType.values[random.nextInt(2)]),
      PictureContainer("PicName2", random.nextInt(100) + 700,
          random.nextInt(100) + 400, FillType.values[random.nextInt(2)]),
      PictureContainer("PicName3", random.nextInt(100) + 700,
          random.nextInt(100) + 400, FillType.values[random.nextInt(2)]),
      PictureContainer("PicName4", random.nextInt(100) + 700,
          random.nextInt(100) + 400, FillType.values[random.nextInt(2)]),
      PictureContainer("PicName5", random.nextInt(100) + 700,
          random.nextInt(100) + 400, FillType.values[random.nextInt(2)]),
      PictureContainer("PicName6", random.nextInt(100) + 700,
          random.nextInt(100) + 400, FillType.values[random.nextInt(2)]),
      PictureContainer("PicName7", random.nextInt(100) + 700,
          random.nextInt(100) + 400, FillType.values[random.nextInt(2)]),
      PictureContainer("PicName8", random.nextInt(100) + 700,
          random.nextInt(100) + 400, FillType.values[random.nextInt(2)]),
      PictureContainer("PicName9", random.nextInt(100) + 700,
          random.nextInt(100) + 400, FillType.values[random.nextInt(2)]),
      PictureContainer("PicName10", random.nextInt(100) + 700,
          random.nextInt(100) + 400, FillType.values[random.nextInt(2)])
    ];
  }
}
