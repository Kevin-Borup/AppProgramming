import 'package:flutter_application_datagrid_app1/data/image_data_http.dart';

import '../models/picture_container.dart';

class ImageDataController {
  var imageHttp = ImageDataHttp();

  List<PictureContainer> getAllPicCons() {
    late List<PictureContainer> picList = [];

    //THis is where it fails. PicList is always 0 at the end.
    imageHttp.getPicCons().then((value) {
      picList = value;
    });
    return picList;
  }

  void postPicCon(PictureContainer picCon) {
    imageHttp.postPictureContainer(picCon);
  }
}
