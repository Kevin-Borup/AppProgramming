import 'package:flutter_application_datagrid_app1/models/models.dart';

abstract class PicConEvent {}

class PostPicConEvent implements PicConEvent {
  final PictureContainer _picCon;

  PictureContainer get picCon => _picCon;

  PostPicConEvent(this._picCon);
}

class PostPicConAndGetAllEvent implements PicConEvent {
  final PictureContainer _picCon;

  PictureContainer get picCon => _picCon;

  PostPicConAndGetAllEvent(this._picCon);
}

class GetAllPicConsEvent implements PicConEvent {}
