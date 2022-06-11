import 'dart:io';

class Item {
  String headerkey = '';
  late String displayname;
  late String titleFile;
  late String file;
  late bool isPlayable = false;
  late String textPath;

  String getTitleFile() {
    return titleFile;
  }

  Item.folderItem({
    required this.displayname,
    required this.file,
  }) {
    int index = file.lastIndexOf('/');
    String path = file.substring(0, index);
    titleFile = path + '/_' + displayname + '.mp3';

    File tf = File(titleFile);
    if (!tf.existsSync()) {
      titleFile = '';
    }
  }

  Item.playableItem({
    required this.displayname,
    required this.file,
  }) {
    isPlayable = true;

    // remove .mp3 ext from the name
    displayname = displayname.replaceAll('.mp3', '');

    int index = file.lastIndexOf('/');
    String path = file.substring(0, index);
    titleFile = path + '/_' + displayname + '.mp3';

    File titleFilePath = File(titleFile);
    if (!titleFilePath.existsSync()) {
      titleFile = '';
    }
  }
}
