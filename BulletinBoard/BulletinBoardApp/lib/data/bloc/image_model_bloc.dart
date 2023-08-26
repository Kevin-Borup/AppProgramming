import 'package:bloc/bloc.dart';
import 'package:bulletin_board_app/data/bloc/events/image_model_events.dart';
import 'package:bulletin_board_app/data/bloc/states/image_model_states.dart';
import 'package:bulletin_board_app/data/models/image_model.dart';
import 'package:bulletin_board_app/interfaces/i_api_images.dart';

import '../../services/service_locator.dart';

class ImageModelBloc extends Bloc<ImageModelEvent, ImageModelState> {
  ImageModelBloc() : super(ImageModelState(state: ImageModelStates.initial)) {
    on<PostImageModelEvent>(_onPostImageModel);
    on<UpdateImageModelEvent>(_onUpdateImageModel);
    on<DeleteImageModelEvent>(_onDeleteImageModel);
    on<DeleteAllImageModelsEvent>(_onDeleteAllImageModels);
    on<GetAllImageModelsEvent>(_getAllImageModels);
    on<PostImageModelAndGetAllEvent>(_onPostImageModelAndGetAll);
  }

  final _api = locator<IApiImages>();

    void _onPostImageModel(
        PostImageModelEvent event, Emitter<ImageModelState> emit) async {
      emit(ImageModelState(state: ImageModelStates.uploading));

      try {
        _api.postImageModel(event.imgMdl);
      } on Exception {
        emit(ImageModelState(state: ImageModelStates.error));
      }

      emit(ImageModelState(state: ImageModelStates.complete));
    }

    void _onUpdateImageModel(
        UpdateImageModelEvent event, Emitter<ImageModelState> emit) async {
      emit(ImageModelState(state: ImageModelStates.uploading));

      try {
        _api.updateImageModel(event.imgMdl);
      } on Exception {
        emit(ImageModelState(state: ImageModelStates.error));
      }

      emit(ImageModelState(state: ImageModelStates.complete));
    }

    void _onDeleteImageModel(
        DeleteImageModelEvent event, Emitter<ImageModelState> emit) async {
      emit(ImageModelState(state: ImageModelStates.uploading));

      try {
        // api.postImageModel(event.img);
      } on Exception {
        emit(ImageModelState(state: ImageModelStates.error));
      }

      emit(ImageModelState(state: ImageModelStates.complete));
    }

    void _onDeleteAllImageModels(
        DeleteAllImageModelsEvent event, Emitter<ImageModelState> emit) async {
      emit(ImageModelState(state: ImageModelStates.uploading));

      try {
        // api.postImageModel(event.img);
      } on Exception {
        emit(ImageModelState(state: ImageModelStates.error));
      }

      emit(ImageModelState(state: ImageModelStates.complete));
    }

    void _getAllImageModels(
        GetAllImageModelsEvent event, Emitter<ImageModelState> emit) async {
      emit(ImageModelState(state: ImageModelStates.loading));

      List<ImageModel> imgs = [];
      try {
        imgs = await _api.getAllImageModels();
      } on Exception {
        emit(ImageModelState(state: ImageModelStates.error));
      }

      emit(ImageModelState(state: ImageModelStates.complete, imgs: imgs));
  }

  void _onPostImageModelAndGetAll(
      PostImageModelAndGetAllEvent event, Emitter<ImageModelState> emit) async {
    emit(ImageModelState(state: ImageModelStates.uploading));

    try {
      _api.postImageModel(event.imgMdl);
    } on Exception {
      emit(ImageModelState(state: ImageModelStates.error));
    }

    emit(ImageModelState(state: ImageModelStates.loading));

    List<ImageModel> imgs = [];
    try {
      imgs = await _api.getAllImageModels();
    } on Exception {
      emit(ImageModelState(state: ImageModelStates.error));
    }

    emit(ImageModelState(state: ImageModelStates.complete, imgs: imgs));
  }
}
