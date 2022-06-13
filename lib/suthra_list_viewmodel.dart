import 'dart:io';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tipitaka/item.dart';
import 'package:tipitaka/locator.dart';
import 'package:tipitaka/router.dart';
import 'package:path/path.dart';

class SuthraListViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  late List<Item> items = [];
  late Item _parent;

  Future init(Item parent) async {
    _parent = parent;
    await onRefreshWithBusy();
  }

  Future reset() async {
    notifyListeners();
  }

  Future onRefreshWithBusy() async {
    setBusy(true);

    items.clear();
    var dir = Directory(_parent.file);
    List contents = dir.listSync();
    for (var fileOrDir in contents) {
      String filename = basename(fileOrDir.path);

      if (fileOrDir is File) {
        if (!filename.startsWith('_') && !filename.endsWith('.txt')) {
          Item item = Item.playableItem(
              displayname: filename,
              //titleFile: '_' + filename,
              file: fileOrDir.path);

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

    items.sort((a, b) => a.displayname.compareTo(b.displayname));

    setBusy(false);
  }

  Future navigateToListViewPage(
    Item item,
  ) async {
    await _navigationService.navigateTo(
      Routes.suthraListView,
      arguments: item,
    );
  }

  Future navigateToPlayerViewPage(
    Item item,
  ) async {
    await _navigationService.navigateTo(
      Routes.playerView,
      arguments: item,
    );
  }
}
