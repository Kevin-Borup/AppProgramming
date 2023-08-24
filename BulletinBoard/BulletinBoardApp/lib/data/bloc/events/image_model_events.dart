import 'package:flutter/material.dart';

import '../../models/image_model.dart';

abstract class ImageModelEvent {}

class PostImageModelEvent implements ImageModelEvent {
  final ImageModel _img;

  ImageModel get img => _img;

  PostImageModelEvent(this._img);
}

class PostImageModelAndGetAllEvent implements ImageModelEvent {
  final ImageModel _img;

  ImageModel get img => _img;

  PostImageModelAndGetAllEvent(this._img);
}

class GetAllImageModelsEvent implements ImageModelEvent {}

class SaveImageModelEvent implements ImageModelEvent {
  final Image _img;

  Image get img => _img;

  SaveImageModelEvent(this._img);
}