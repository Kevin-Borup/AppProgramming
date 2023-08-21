import 'dart:io';

import 'package:flutter/material.dart';

enum FillType { jpeg, png }

class PictureContainer {
  PictureContainer(Image? image, this.name, this.height, this.width, this.type);

  late Image image;
  final String name;
  final int height;
  final int width;
  final FillType type;
}
