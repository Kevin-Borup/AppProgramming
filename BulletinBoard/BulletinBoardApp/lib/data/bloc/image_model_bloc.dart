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
    //On the relevant event, call the method contained in the following parentheses.
  }

  final _api = locator<IApiImages>(); //Using the locator to get the Api interface

  //All the functions follow the same pattern, of initial state. Then the relevant loading or uploading.
  // Then either an error, or completed, typically with an emit, to invoke the new value to any listeners of ImageModelState

    void _onPostImageModel(
        PostImageModelEvent event, Emitter<ImageModelState> emit) async {
      emit(ImageModelState(state: ImageModelStates.uploading));

      ImageModel? updatedImgMdl;

      try {
        updatedImgMdl = await _api.postImageModel(event.imgMdl);
      } on Exception {
        emit(ImageModelState(state: ImageModelStates.error));
      }

      // emit(ImageModelState(state: ImageModelStates.complete, imgs: List.filled(1, updatedImgMdl!)));
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
        _api.deleteImageModel(event.imgMdl);
      } on Exception {
        emit(ImageModelState(state: ImageModelStates.error));
      }

      emit(ImageModelState(state: ImageModelStates.complete));
    }

    void _onDeleteAllImageModels(
        DeleteAllImageModelsEvent event, Emitter<ImageModelState> emit) async {
      emit(ImageModelState(state: ImageModelStates.uploading));

      try {
        _api.deleteAllImageModels();
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
