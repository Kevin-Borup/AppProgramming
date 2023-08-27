import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:bulletin_board_app/data/models/image_model.dart';

//The api repository, to be implemented for all to-be data access layers.
abstract class IApiImages {

  Future<List<ImageModel>> getAllImageModels();
  void postImageModel(ImageModel imgMdl);
  void updateImageModel(ImageModel imgMdl);
  void deleteImageModel(ImageModel imgMdl);
  void deleteAllImageModels();

  Future<List<Image>> getAllImages();
  void postImage(Uint8List imgBytes);
  void deleteImage(Uint8List imgBytes);
  void deleteAllImages();
}