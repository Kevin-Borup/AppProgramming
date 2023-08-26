
import '../../models/image_model.dart';

abstract class ImageModelEvent {}

class PostImageModelEvent implements ImageModelEvent {
  final ImageModel _imgMdl;

  ImageModel get imgMdl => _imgMdl;

  PostImageModelEvent(this._imgMdl);
}

class UpdateImageModelEvent implements ImageModelEvent {
  final ImageModel _imgMdl;

  ImageModel get imgMdl => _imgMdl;

  UpdateImageModelEvent(this._imgMdl);
}

class DeleteImageModelEvent implements ImageModelEvent {
  final ImageModel _imgMdl;

  ImageModel get imgMdl => _imgMdl;

  DeleteImageModelEvent(this._imgMdl);
}

class DeleteAllImageModelsEvent implements ImageModelEvent {}

class PostImageModelAndGetAllEvent implements ImageModelEvent {
  final ImageModel _imgMdl;

  ImageModel get imgMdl => _imgMdl;

  PostImageModelAndGetAllEvent(this._imgMdl);
}

class GetAllImageModelsEvent implements ImageModelEvent {}