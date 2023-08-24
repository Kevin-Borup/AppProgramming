import 'package:bulletin_board_app/data/models/image_model.dart';

abstract class IApiImages {
  Future<List<ImageModel>> getAllImages();

  void postImage(ImageModel picCon);
}