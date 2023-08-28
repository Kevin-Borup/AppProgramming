import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class PictureContainer {
  PictureContainer(this.image, this.bytes, this.byteSize, this.height,
      this.width, this.type);

  final Image image;
  final Uint8List bytes;
  late String name = "";
  final int byteSize;
  final num height;
  final num width;
  final String type;

  void addName(String name) {
    this.name = name;
  }

  String getSize() {
    return formatBytes(bytes.elementSizeInBytes, 2);
  }

  String getDimSize() {
    return ("$height x $width");
  }

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  factory PictureContainer.fromJson(Map<String, dynamic> json) {
    var bytes = base64.decode(json['Image64']);
    Image image = Image.memory(bytes);
    var picCon = PictureContainer(image, bytes, json['Size'], json['Height'],
        json['Width'], json['Type']);
    picCon.addName(json['Name']);

    return picCon;
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'Image64': base64.encode(bytes)});
    result.addAll({'Name': name});
    result.addAll({'Width': width});
    result.addAll({'Height': height});
    result.addAll({'Size': byteSize});
    result.addAll({'Type': type});

    return result;
  }
}
