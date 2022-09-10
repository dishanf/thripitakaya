import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tipitaka/item.dart';
import 'package:tipitaka/locator.dart';
import 'package:tipitaka/router.dart';
import 'dart:io';

class PlayerViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  AudioPlayer player = AudioPlayer();
  int maxduration = 100;
  int currentpos = 0;
  String currentpostlabel = "00:00";
  bool isplaying = false;
  bool audioplayed = false;
  String textData = '';
  late Uint8List audiobytes;
  late Item item;

  Future init(Item item) async {
    item = item;
  }

  Future handleStartUpLogic() async {
    await Future.delayed(const Duration(seconds: 1));

    await _navigationService.replaceWith(Routes.homeView);
  }

  Future navigateToListViewPage(
    Item item,
  ) async {
    await _navigationService.navigateTo(
      Routes.textView,
      arguments: item,
    );
  }
}
