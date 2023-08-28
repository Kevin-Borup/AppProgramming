import 'package:flutter_application_datagrid_app1/data/api/image_data_controller.dart';
import 'package:flutter_application_datagrid_app1/data/repo/i_ApiPicCons.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupApi() {
  locator.registerLazySingleton<IApiPicCons>(() => ImageDataController());
}
