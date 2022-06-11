import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(ThemeService.getInstance());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => DialogService());
  //locator.registerLazySingleton(() => Globals());
}
