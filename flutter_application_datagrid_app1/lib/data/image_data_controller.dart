import 'package:flutter_application_datagrid_app1/data/image_data_http.dart';

import '../models/picture_container.dart';

class ImageDataController {
  var imageHttp = ImageDataHttp();

  List<PictureContainer> GetAllPicCons() {
    List<PictureContainer> picList = [];

    imageHttp.getPicCons().then((value) {
      for (var image in value) {
        picList.add(image);
      }
    });
    return picList;
  }

  void postPicCon(PictureContainer picCon) {
    imageHttp.postPictureContainer(picCon);
  }
}
