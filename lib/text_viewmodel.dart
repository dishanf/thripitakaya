import 'dart:io';
import 'package:stacked/stacked.dart';
import 'item.dart';

class TextViewModel extends BaseViewModel {
  late Item item;
  String playtextcontent = '';
  double fontSize = 20;

  Future init(Item item) async {
    setBusy(true);
    item = item;

    if (item.txtFile.isEmpty) {
      playtextcontent = '';
    } else {
      File titleFilePath = File(item.txtFile);
      playtextcontent = await titleFilePath.readAsString();
    }
    setBusy(false);
  }

  Future changeFontSize() async {
    fontSize++;
    if (fontSize > 30) fontSize = 10;
    setBusy(false);
  }

  get getFontSize => fontSize;

  Future onRefreshWithBusy() async {}
}
