import 'dart:convert';

import 'package:flutter/material.dart';

class PictureContainer {
  PictureContainer(this.image, this.byteSize, this.height, this.width,
      this.type);

  final Image image;
  late String name = "";
  final int byteSize;
  final num height;
  final num width;
  final String type;

  void addName(String name) {
    this.name = name;
  }

  String getSize() {
    String size = byteSize.toString();

    return size;
  }

  String getDimSize() {
    return ("$height x $width");
  }

  factory PictureContainer.fromJson(Map<String, dynamic> json) {
    var decoder = const Base64Decoder();
    Image image = Image.memory(decoder.convert(json['Image']));
    var picCon = PictureContainer(
        image, json['Size'], json['Height'], json['Width'], json['Type']);
    picCon.addName(json['Name']);

    return picCon;
  }
}
