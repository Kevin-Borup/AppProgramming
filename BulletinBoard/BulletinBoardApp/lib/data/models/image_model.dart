import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io' as Io;
import 'dart:ui';
import 'package:bulletin_board_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';

class ImageModel {
  ImageModel(this.img, this.bytes);

  final Image img;
  final Uint8List bytes;
  late Offset position;
  late Size size;
  late double ang;

  void updatePositionOffset(Offset p) => position = p;
  void updatePositionXY(double x, double y) => position = Offset(x, y);

  void updateSizeXY(double x, double y) => size = Size(x, y);
  void updateSizeS(Size s) => size = s;

  void updateAngle(double a) => ang = a;

  ImageWidget toImageWidget(){
    return ImageWidget(img: img, position: position, size: size, ang: ang);
  }

  factory ImageModel.fromJson(Map<String, dynamic> json){
    var byte =base64.decode(json['Image64']);
    var image = Image.memory(byte);;
    var pos = Offset(double.parse(json['X']), double.parse(json['Y']));
    var s = Size(double.parse(json['Width']), double.parse(json['Height']));
    var a = double.parse(json['Angle']);

    var imgMdl = ImageModel(image, byte);
    imgMdl.updatePositionOffset(pos);
    imgMdl.updateSizeS(s);
    imgMdl.updateAngle(a);

    return imgMdl;
  }

  String toJson() => json.encode(toMap());

  Future<Map<String, dynamic>> toMap() async {
    final result = <String, dynamic>{};
    result.addAll({'Image64': base64.encode(bytes)});
    result.addAll({'X': position.dx});
    result.addAll({'Y': position.dy});
    result.addAll({'Width': size.width});
    result.addAll({'Height': size.height});
    result.addAll({'Angle': ang});

    return result;
  }
}