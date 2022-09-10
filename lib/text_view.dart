import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tipitaka/suthra_list_viewmodel.dart';
import 'package:tipitaka/item.dart';
import 'package:tipitaka/text_viewmodel.dart';
import 'globals.dart' as globals;

class TextView extends StatefulWidget {
  final Item item;
  const TextView({Key? key, required this.item}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<TextView> {
  AudioPlayer audioPlayer = AudioPlayer();
  final player = AudioCache();

  @override
  Widget build(BuildContext context) {
    double fontSize = 20;
    return ViewModelBuilder<TextViewModel>.reactive(
      onModelReady: (model) => model.init(
        widget.item,
      ),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          foregroundColor: Colors.greenAccent,
          centerTitle: true,
          elevation: 0.3,
          title: Text(
            widget.item.displayname,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.font_download,
                color: Colors.greenAccent,
              ),
              onPressed: () async {
                model.changeFontSize();
              },
            )
          ],
        ),
        body: model.isBusy
            ? const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.greenAccent,
                ),
              )
            : RefreshIndicator(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: Text(
                        model.playtextcontent,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: model.getFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
                onRefresh: model.onRefreshWithBusy,
              ),
      ),
      viewModelBuilder: () => TextViewModel(),
    );
  }
}
