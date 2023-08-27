import 'dart:typed_data';

abstract class ImageEvent {}

class PostImageEvent implements ImageEvent {
  final Uint8List _imgBytes;

  Uint8List get imgBytes => _imgBytes;

  PostImageEvent(this._imgBytes);
}

class DeleteImageEvent implements ImageEvent {
  final Uint8List _imgBytes;

  Uint8List get imgBytes => _imgBytes;

  DeleteImageEvent(this._imgBytes);
}

class GetAllImagesEvent implements ImageEvent {
}

class PostImageAndGetAllEvent implements ImageEvent {
  final Uint8List _imgBytes;

  Uint8List get imgBytes => _imgBytes;

  PostImageAndGetAllEvent(this._imgBytes);
}
