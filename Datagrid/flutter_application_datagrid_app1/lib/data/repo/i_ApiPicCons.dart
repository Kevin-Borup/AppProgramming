import '../../models/picture_container.dart';

abstract class IApiPicCons {
  Future<List<PictureContainer>> getAllPicCons();

  void postPicCon(PictureContainer picCon);
}
