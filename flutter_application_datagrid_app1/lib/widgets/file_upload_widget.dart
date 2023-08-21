import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FileUploadWidget extends StatelessWidget {
  FileUploadWidget({Key? key}) : super(key: key);
  late File? imageFile;

  Future<File?> pickImagefromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    } else {
      return null;
    }
  }

  imageFile = pickImagefromGallery();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SimpleDialog(
        title: const Text('File Upload'),
        children: <Widget>[
          Image(image: FileImage(pickImagefromGallery())),
          SimpleDialogOption(
            onPressed: () {},
            child: const Text('Option 1'),
          ),
          SimpleDialogOption(
            onPressed: () {},
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }
}
