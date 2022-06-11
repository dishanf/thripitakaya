import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tipitaka/settings_viewmodel.dart';
import 'dart:io';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SettingsView> {
  final player = AudioCache();
  Directory? rootPath;

  String? filePath;
  String? dirPath;

  Directory findRoot(FileSystemEntity entity) {
    final Directory parent = entity.parent;
    if (parent.path == entity.path) return parent;
    return findRoot(parent);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.greenAccent,
          centerTitle: true,
          elevation: 0.3,
          title: const Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          ),
          /* actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.greenAccent,
              ),
              onPressed: () async {
                //await model.navigateToLoginViewPage();
              },
            )
          ], */
        ),
        body: model.isBusy
            ? const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.greenAccent,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(model.path ?? ''),
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.greenAccent,
                      ),
                    ),
                    onPressed: () async {
                      //rootPath = '/';
                      String? selectedDirectory =
                          await FilePicker.platform.getDirectoryPath();

                      model.setPath(selectedDirectory);
                    },
                    icon: const Icon(
                      Icons.folder_open,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Browse",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
      ),
      viewModelBuilder: () => SettingsViewModel(),
    );
  }
}
