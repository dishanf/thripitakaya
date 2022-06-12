import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipitaka/item.dart';
import 'package:tipitaka/locator.dart';
import 'package:tipitaka/router.dart';
import 'package:path/path.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  late List<Item> items = [];

  Future init() async {
    await onRefreshWithBusy();
  }

  Future reset() async {
    notifyListeners();
  }

  Future onRefreshWithBusy() async {
    setBusy(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rootdir = prefs.getString('rootdir');

    if (rootdir != null) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      items.clear();
      var dir = Directory(rootdir);
      List contents = dir.listSync();
      for (var fileOrDir in contents) {
        String filename = basename(fileOrDir.path);

        if (fileOrDir is File) {
          if (!filename.startsWith('_')) {
            Item item = Item.playableItem(
              displayname: filename,
              file: fileOrDir.path,
            );

            items.add(item);
          }
        } else if (fileOrDir is Directory) {
          Item item = Item.folderItem(
            displayname: filename,
            file: fileOrDir.path,
          );

          items.add(item);
        }
      }
    }
    setBusy(false);
  }

  Future navigateToSuthraListViewPage(
    Item item,
  ) async {
    await _navigationService.navigateTo(
      Routes.suthraListView,
      arguments: item,
    );
  }

  Future navigateToSettingsViewPage() async {
    await _navigationService.navigateTo(
      Routes.settingsView,
    );
  }
}
