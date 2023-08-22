import 'package:flutter/material.dart';
import 'package:flutter_application_datagrid_app1/models/models.dart';
import 'package:provider/provider.dart';

import '../providers/pic_image_provider.dart';

class PicDialog extends StatelessWidget {
  PicDialog(this.picCon, {Key? key}) : super(key: key);

  final PictureContainer picCon;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    // super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget nameField;
    Text titleText;
    bool filledName = picCon.name != "";

    if (filledName) {
      titleText = Text(picCon.name);
      nameField = Text("");
    } else {
      titleText = Text('Add Name');
      nameField = TextFormField(
          autofocus: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please write a name';
            }
            return null;
          },
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            icon: Icon(Icons.add_circle_outline),
          ));
    }

    return AlertDialog(
      scrollable: true,
      title: titleText,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              picCon.image,
              nameField,
              Text(picCon.getSize()),
              Text(picCon.type)
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            child: const Text("Submit"),
            onPressed: () {
              if (filledName) {
                Navigator.of(context).pop();
              } else if (_formKey.currentState!.validate()) {
                picCon.addName(nameController.text);
                Provider.of<PicImageProvider>(context, listen: false)
                    .add(picCon);
                Navigator.of(context).pop();
              }
            })
      ],
    );
  }
}
