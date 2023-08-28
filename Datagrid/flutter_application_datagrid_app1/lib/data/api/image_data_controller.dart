import 'package:flutter_application_datagrid_app1/data/api/image_data_http.dart';
import 'package:flutter_application_datagrid_app1/data/repo/i_ApiPicCons.dart';

import '../../models/picture_container.dart';

class ImageDataController implements IApiPicCons {
  var imageHttp = ImageDataHttp();

  @override
  Future<List<PictureContainer>> getAllPicCons() async {
    late List<PictureContainer> picList = [];

    return await imageHttp.getPicCons();
  }

  @override
  void postPicCon(PictureContainer picCon) {
    imageHttp.postPictureContainer(picCon);
  }
}
