import '../data/api/image_data_http.dart';
import '../interfaces/i_api_images.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupApi() {
  // Repo pattern with Dependency Injection
  // Can now easily change ImageDataHTTP to another Data access layer that implements IApiImages.
  locator.registerLazySingleton<IApiImages>(() => ImageDataHttp());
}