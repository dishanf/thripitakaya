import 'dart:io';

class Item {
  String headerkey = '';
  late String displayname;
  late String titleFile;
  late String file;
  late String altFile;
  late String txtFile;
  late bool isPlayable = false;

  Item();

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

    // title file
    titleFile = path + '/_' + displayname + '.mp3';
    File titleFilePath = File(titleFile);
    if (!titleFilePath.existsSync()) {
      titleFile = '';
    }

    // alternative file (other lang file)
    altFile = path + '/__' + displayname + '.mp3';
    File altFilePath = File(altFile);
    if (!altFilePath.existsSync()) {
      altFile = '';
    }

    // text file
    txtFile = path + '/_' + displayname + '.txt';
    File txtFilePath = File(txtFile);
    if (!txtFilePath.existsSync()) {
      txtFile = '';
    }
  }
}
