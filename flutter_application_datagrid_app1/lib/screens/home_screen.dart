import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_datagrid_app1/models/models.dart';
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

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController widthController = TextEditingController();

  Image? image;
  late String picName;
  late int picHeight;
  late int picWidth;
  late FillType picType;

  List<PictureContainer> pictureCons = <PictureContainer>[];
  late PictureDataSource pictureConsDataSource;

  void pickImagefromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = Image.file(File(pickedImage.path));

      // setState(() {
      //   image = Image.file(File(pickedImage.path));
      // });
    }
  }

  @override
  void initState() {
    super.initState();

    if (image != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Login'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      image!,
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please write a name';
                          }
                          return null;
                        },
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          icon: Icon(Icons.pending_actions),
                        ),
                      ),
                      Row(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please input a height';
                              }
                              return null;
                            },
                            controller: heightController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Height',
                              icon: Icon(Icons.height),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please input a width';
                              }
                              return null;
                            },
                            controller: widthController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Width',
                              icon: Icon(Icons.width_full),
                            ),
                          )
                        ],
                      ),
                      DropdownButton<FillType>(
                        onChanged: (value) => picType = value!,
                        items: FillType.values
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(describeEnum(type)),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        picName = nameController.text;
                        picHeight = int.parse(heightController.text);
                        picWidth = int.parse(widthController.text);

                        pictureCons.add(PictureContainer(
                            image, picName, picHeight, picWidth, picType));
                        //Navigator.of(context).pop();
                      }
                    })
              ],
            );
          });
    }

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
              child: Text(
                "Welcome to Datagrid!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              )),
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: 50,
                width: 150,
                child: TextButton(
                    style: raisedButtonStyle,
                    onPressed: () => {pickImagefromGallery()},
                    child: const Text('Upload Image')),
              )),
          SfDataGrid(
              source: pictureConsDataSource,
              columnWidthMode: ColumnWidthMode.fill,
              columns: <GridColumn>[
                GridColumn(
                    columnName: "Image",
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Image',
                        ))),
                GridColumn(
                    columnName: "Name",
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Name',
                        ))),
                GridColumn(
                    columnName: "Height",
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Height',
                        ))),
                GridColumn(
                    columnName: "Width",
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Width',
                        ))),
                GridColumn(
                    columnName: "FillType",
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'FillType',
                        ))),
              ]),
        ],
      )),
    );
  }
}
