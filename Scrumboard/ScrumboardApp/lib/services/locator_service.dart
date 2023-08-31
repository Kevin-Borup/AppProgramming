
import 'package:get_it/get_it.dart';
import 'package:scrumboard_app/data/apis/http_data_api.dart';
import 'package:scrumboard_app/interfaces/IApiHttp.dart';

GetIt locator = GetIt.instance;

void setupApi() {
  // Repo pattern with Dependency Injection
  // Can now easily change ImageDataHTTP to another Data access layer that implements IApiImages.
  locator.registerLazySingleton<IApiHttp>(() => HttpDataApi());
}