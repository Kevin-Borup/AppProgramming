import 'package:bulletin_board_app/data/models/image_model.dart';

enum ImageModelStates { initial, uploading, loading, deleting, complete, error }

class ImageModelState {
  final ImageModelStates _state;
  final List<ImageModel> _imgs;

  ImageModelStates get currentState => _state;

  List<ImageModel> get imgs => _imgs;

  ImageModelState({required ImageModelStates state, List<ImageModel>? imgs})
      : _state = state,
        _imgs = imgs ?? [];
}