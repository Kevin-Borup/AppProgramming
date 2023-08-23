import 'package:flutter_application_datagrid_app1/data/image_data_http.dart';

import '../models/picture_container.dart';

class ImageDataController {
  var imageHttp = ImageDataHttp();

  List<PictureContainer> GetAllPicCons() {
    List<PictureContainer> picList = [];

    imageHttp.fetchPictureContainers().then((value) {
      if (value != null) value.forEach((image) => picList.add(image));
    });
    return picList;
  }

  void PostPicCon(PictureContainer picCon) {
    imageHttp.postPictureContainer(picCon);
  }
}
