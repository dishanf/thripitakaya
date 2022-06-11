import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tipitaka/locator.dart';
import 'package:tipitaka/router.dart';

class SplashViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    await Future.delayed(const Duration(seconds: 3));

    await _navigationService.replaceWith(Routes.homeView);
  }
}
