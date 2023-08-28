import 'package:flutter/material.dart';

class PictureContainer {
  PictureContainer(this.image, this.height, this.width, this.type);

  final Image image;
  late String name = "";
  final num height;
  final num width;
  final String type;

  void addName(String name) {
    this.name = name;
  }

  String getSize() {
    return ("$height x $width");
  }
}
