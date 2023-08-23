import 'package:flutter/material.dart';
import 'package:flutter_application_datagrid_app1/models/models.dart';
import 'package:provider/provider.dart';

import '../providers/pic_image_provider.dart';

class PicDialog extends StatelessWidget {
  PicDialog(this.picCon, {Key? key}) : super(key: key);

  final PictureContainer picCon;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  void _submitForm(BuildContext context) {
    picCon.addName(nameController.text);
    Provider.of<PicImageProvider>(context, listen: false).add(picCon);
    Navigator.of(context).pop();
  }

  void _showImage(BuildContext context, PictureContainer picCon) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: picCon.image);
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget nameField;
    Text titleText;
    Text closeText;
    bool filledName = picCon.name != "";

    if (filledName) {
      titleText = Text(picCon.name);
      closeText = const Text("Close");
      nameField = const Text("");
    } else {
      titleText = const Text('Add Name');
      closeText = const Text("Submit");
      nameField = TextFormField(
          onFieldSubmitted: (text) => _submitForm(context),
          autofocus: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please write a name';
            }
            return null;
          },
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'));
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
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: InkWell(
                        child: picCon.image,
                        onTap: () {
                          _showImage(context, picCon);
                        }),
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: nameField,
                  )
                ],
              ),
              Text("Dimensions: ${picCon.getDimSize()}"),
              Text("Type: ${picCon.type}"),
              Text("Size: ${picCon.getSize()} "),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            child: closeText,
            onPressed: () {
              if (filledName) {
                Navigator.of(context).pop();
              } else if (_formKey.currentState!.validate()) {
                _submitForm(context);
              }
            })
      ],
    );
  }
}
