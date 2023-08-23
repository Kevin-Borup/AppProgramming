import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_datagrid_app1/data/image_data_controller.dart';
import 'package:flutter_application_datagrid_app1/models/models.dart';

class PicImageProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  final ImageDataController imgController = ImageDataController();
  final List<PictureContainer> _picCons = [];

  // PicImageProvider() {
  //   var httpImage = ImageDataHttp();
  //   for ()
  //     httpImage.fetchPictureContainers();
  // }

  /// An unmodifiable view of the items in the cart.
  // UnmodifiableListView<PictureContainer> get picCons =>
  //     UnmodifiableListView(_picCons);

  UnmodifiableListView<PictureContainer> get picCons =>
      UnmodifiableListView(imgController.GetAllPicCons());

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(PictureContainer picCon) {
    imgController.PostPicCon(picCon);
    // _picCons.add(picCon);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
