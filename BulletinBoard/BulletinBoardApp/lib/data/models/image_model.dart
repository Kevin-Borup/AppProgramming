import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io' as Io;
import 'dart:ui';
import 'package:bulletin_board_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';

class ImageModel {
  ImageModel(
      {this.dbID,
      required this.img,
      required this.bytes,
      this.position = Offset.zero,
      this.size = Size.zero,
      this.ang = 0});

  late String? dbID;
  final Image img;
  final Uint8List bytes;
  late Offset position;
  late Size size = Size(40, 40);
  late double ang = 0;

  void updatePositionOffset(Offset p) => position = p;

  void updatePositionXY(double x, double y) => position = Offset(x, y);

  void updateSizeXY(double x, double y) => size = Size(x, y);

  void updateSizeS(Size s) => size = s;

  void updateAngle(double a) => ang = a;

  ImageWidget toImageWidget() {
    return ImageWidget(img: img, position: position, size: size, ang: ang);
  }

  // factory ImageModel.fromImage(Image imgW){
  //     imgw.
  //
  //
  // }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    // internal function to help parsing to double.
    double tryParseToDouble(dynamic value) {
      double newValue = 0;

      try {
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

    // var id = json['_id'];
    var byte = base64.decode(json['Image64'] as String);
    var image = Image.memory(byte);

    // var x = json['X'];

    // var pos = Offset(double.parse(json['X']), double.parse(json['Y']));
    // var s = Size(double.parse(json['Width']), double.parse(json['Height']));
    // var a = double.parse(json['Angle']);

    // var pos = Offset(json['X'], json['Y']);
    // var s = Size(json['Width'], json['Height']);
    // var a = json['Angle'];
    //
    // String testId = json['_id'].toString();
    //
    // double tempX = tryParseToDouble(json['X']);
    // double tempY = tryParseToDouble(json['Y']);
    //
    // double tempW = tryParseToDouble(json['Width']);
    // double tempH = tryParseToDouble(json['Height']);
    //
    // double tempA = tryParseToDouble(json['Angle']);

    // var imgMdl = ImageModel(
    //     dbID: json['_id'].toString(),
    //     img: image,
    //     bytes: byte,
    //     position: Offset(tryParseToDouble(json['X']), tryParseToDouble(json['Y'])),
    //     size: Size(tryParseToDouble(json['Width']), tryParseToDouble(json['Height'])),
    //     ang: tryParseToDouble(json['Angle']));
    // imgMdl._setID(json['_id'] as ObjectId);
    // imgMdl.updatePositionOffset(Offset(json['X'] as double, json['Y'] as double));
    // imgMdl.updateSizeS(Size(json['Width'] as double, json['Height'] as double));
    // imgMdl.updateAngle(json['Angle'] as double);

    return ImageModel(
        dbID: json['_id'].toString(),
        img: image,
        bytes: byte,
        position: Offset(tryParseToDouble(json['X']), tryParseToDouble(json['Y'])),
        size: Size(tryParseToDouble(json['Width']), tryParseToDouble(json['Height'])),
        ang: tryParseToDouble(json['Angle']));;
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    dbID ?? result.addAll({'_id': dbID});
    result.addAll({'Image64': base64.encode(bytes)});
    result.addAll({'X': position.dx});
    result.addAll({'Y': position.dy});
    result.addAll({'Width': size.width});
    result.addAll({'Height': size.height});
    result.addAll({'Angle': ang});

    return result;
  }
}
