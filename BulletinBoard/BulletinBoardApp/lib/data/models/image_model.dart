import 'dart:convert';
import 'dart:typed_data';
import 'package:bulletin_board_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';

class ImageModel {
  ImageModel(
      {this.dbID,
      required this.img,
      required this.bytes,
      this.position = Offset.zero,
      this.size = Size.zero,
      this.angle = 0});

  late String? dbID;
  final Image img;
  final Uint8List bytes;
  late Offset position;
  late Size size;
  late double angle;

  void updateOffsetSizeAngle(Offset p, Size s, double a) {
    position = p;
    size = s;
    angle = a;
  }

  ImageWidget toImageWidget() {
    return ImageWidget(
        imgMdl: this, img: img, position: position, size: size, ang: angle);
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    // internal function to help parsing to double.
    double tryParseToDouble(dynamic value) {
      double newValue = 0;

      try {
        //Json issues parsin whole numbers to double.
        //Forcing it to double, if it success
        if (value is int) {
          int tempInt = value;
          newValue = tempInt + 0.0;
        } else if (value is double) {
          newValue = value;
        }
      } on Exception {
        newValue = value as double;
      }

      return newValue;
    }

    var byte = base64.decode(json['Image64'] as String);
    var image = Image.memory(byte);

    return ImageModel(
        dbID: json['_id'].toString(),
        img: image,
        bytes: byte,
        position:
            Offset(tryParseToDouble(json['X']), tryParseToDouble(json['Y'])),
        size: Size(
            tryParseToDouble(json['Width']), tryParseToDouble(json['Height'])),
        angle: tryParseToDouble(json['Angle']));
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    //Only include if an ID is found, if not, MongoDB will assume it's a new entry and add it.
    dbID ?? result.addAll({'_id': dbID});
    result.addAll({'Image64': base64.encode(bytes)});
    result.addAll({'X': position.dx});
    result.addAll({'Y': position.dy});
    result.addAll({'Width': size.width});
    result.addAll({'Height': size.height});
    result.addAll({'Angle': angle});

    return result;
  }
}
