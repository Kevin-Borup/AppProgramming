import 'package:flutter_application_datagrid_app1/data/image_data_http.dart';

import '../models/picture_container.dart';

class ImageDataController {
  var imageHttp = ImageDataHttp();

  Future<List<PictureContainer>> getAllPicCons() async {
    return imageHttp.getPicCons();
  }

  void postPicCon(PictureContainer picCon) {
    imageHttp.postPictureContainer(picCon);
  }
}
