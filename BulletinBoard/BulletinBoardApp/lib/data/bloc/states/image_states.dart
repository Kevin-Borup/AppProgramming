import 'package:flutter/material.dart';

enum ImageStates { initial, uploading, loading, deleting, complete, error }

class ImageState {
  final ImageStates _state;
  final List<Image> _imgs;

  ImageStates get currentState => _state;

  List<Image> get imgs => _imgs;

  ImageState({required ImageStates state, List<Image>? imgs})
      : _state = state,
        _imgs = imgs ?? [];
}