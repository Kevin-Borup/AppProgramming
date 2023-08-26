import 'package:bloc/bloc.dart';
import 'package:bulletin_board_app/data/bloc/states/image_states.dart';
import 'package:bulletin_board_app/interfaces/i_api_images.dart';
import 'package:flutter/material.dart';

import '../../services/service_locator.dart';
import 'events/image_events.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageState(state: ImageStates.initial)) {
    on<PostImageEvent>(_onPostImage);
    on<DeleteImageEvent>(_onDeleteImage);
    on<GetAllImagesEvent>(_getAllImage);
    on<PostImageAndGetAllEvent>(_onPostImageAndGetAll);
  }

  final _api = locator<IApiImages>();

  void _onPostImage(
      PostImageEvent event, Emitter<ImageState> emit) async {
    emit(ImageState(state: ImageStates.uploading));

    try {
      _api.postImage(event.imgBytes);
    } on Exception {
      emit(ImageState(state: ImageStates.error));
    }

    emit(ImageState(state: ImageStates.complete));
  }

  void _onDeleteImage(
      DeleteImageEvent event, Emitter<ImageState> emit) async {
    emit(ImageState(state: ImageStates.deleting));

    try {
      _api.deleteImage(event.imgBytes);
    } on Exception {
      emit(ImageState(state: ImageStates.error));
    }

    emit(ImageState(state: ImageStates.complete));
  }

  void _getAllImage(
      GetAllImagesEvent event, Emitter<ImageState> emit) async {
    emit(ImageState(state: ImageStates.loading));

    List<Image> imgs = [];
    try {
      imgs = await _api.getAllImages();
    } on Exception {
      emit(ImageState(state: ImageStates.error));
    }

    emit(ImageState(state: ImageStates.complete, imgs: imgs));
  }

  void _onPostImageAndGetAll(
      PostImageAndGetAllEvent event, Emitter<ImageState> emit) async {
    emit(ImageState(state: ImageStates.uploading));

    try {
      _api.postImage(event.imgBytes);
    } on Exception {
      emit(ImageState(state: ImageStates.error));
    }

    emit(ImageState(state: ImageStates.loading));

    List<Image> imgs = [];
    try {
      imgs = await _api.getAllImages();
    } on Exception {
      emit(ImageState(state: ImageStates.error));
    }

    emit(ImageState(state: ImageStates.complete, imgs: imgs));
  }
}
