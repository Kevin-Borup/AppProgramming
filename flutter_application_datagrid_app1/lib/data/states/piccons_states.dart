import 'package:flutter_application_datagrid_app1/models/models.dart';

enum PicConStates { initial, uploading, loading, complete, error }

class PicConState {
  final PicConStates _state;
  final List<PictureContainer> _picCons;

  PicConStates get currentState => _state;

  List<PictureContainer> get picCons => _picCons;

  PicConState({required PicConStates state, List<PictureContainer>? picCons})
      : _state = state,
        _picCons = picCons ?? [];
}
