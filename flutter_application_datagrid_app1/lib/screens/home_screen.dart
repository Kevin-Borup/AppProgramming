import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_datagrid_app1/models/models.dart';
import 'package:flutter_application_datagrid_app1/widgets/pic_dialog_widget.dart';
import 'package:flutter_application_datagrid_app1/widgets/pictable_widget.dart';
import 'package:image_picker/image_picker.dart';

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

  final TextEditingController nameController = TextEditingController();

  Future<void> _pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Image image = Image.file(File(pickedImage.path));
      double height = image.height ?? 0;
      double width = image.width ?? 0;
      String type = pickedImage.mimeType ?? "";
      PictureContainer picCon = PictureContainer(image, height, width, type);
      _showImageDialog(picCon);
    }
  }

  void _showImageDialog(PictureContainer picCon) {
    showDialog(
        context: context,
        builder: (context) {
          return PicDialog(picCon);
        });
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
                    onPressed: () {
                      _pickImageFromGallery();
                    },
                    child: const Text('Upload Image')),
              )),
          const PicTable()
        ],
      )),
    );
  }
}
