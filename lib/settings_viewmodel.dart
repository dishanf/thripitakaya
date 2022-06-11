import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class SettingsViewModel extends BaseViewModel {
  late String? path = '';

  Future init() async {
    setBusy(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    path = prefs.getString("rootdir");
    setBusy(false);
  }

  Future setPath(String? selectedDirectory) async {
    setBusy(true);
    if (selectedDirectory != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("rootdir", selectedDirectory);
      path = selectedDirectory;
    }
    setBusy(false);
  }
}
