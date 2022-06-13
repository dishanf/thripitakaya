import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tipitaka/suthra_list_viewmodel.dart';
import 'package:tipitaka/item.dart';
import 'globals.dart' as globals;

class SuthraListView extends StatefulWidget {
  final Item item;
  const SuthraListView({Key? key, required this.item}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SuthraListView> {
  AudioPlayer audioPlayer = AudioPlayer();
  final player = AudioCache();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SuthraListViewModel>.reactive(
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
            : RefreshIndicator(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemExtent: 120.0,
                        itemCount: model.items.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              if (model.items[index].titleFile != '') {
                                audioPlayer.play(
                                  model.items[index].titleFile,
                                  isLocal: true,
                                );
                              }
                            },
                            onDoubleTap: () async {
                              if (model.items[index].isPlayable) {
                                await model.navigateToPlayerViewPage(
                                  model.items[index],
                                );

                                if (widget.item.titleFile != '') {
                                  audioPlayer.play(
                                    widget.item.titleFile,
                                    isLocal: true,
                                  );
                                }
                              } else {
                                await model.navigateToListViewPage(
                                  model.items[index],
                                );

                                if (widget.item.titleFile != '') {
                                  audioPlayer.play(
                                    widget.item.titleFile,
                                    isLocal: true,
                                  );
                                }
                              }
                            },
                            child: Card(
                              shadowColor: Colors.black,
                              elevation: 5,
                              child: ListTile(
                                /* leading: Icon(
                                  model.items[index].isPlayable
                                      ? Icons.play_circle_outlined
                                      : Icons.auto_stories_rounded,
                                  color: model.items[index].titleFile != ''
                                      ? Colors.greenAccent
                                      : Colors.red,
                                ), */
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    model.items[index].displayname,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: model.items[index].titleFile != ''
                                          ? Colors.greenAccent
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              margin: const EdgeInsets.all(1.0),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: MaterialButton(
                        height: 80,
                        minWidth: double.infinity,
                        color: Colors.greenAccent,
                        onLongPress: () async {
                          Navigator.pop(context);
                        },
                        onPressed: () async {
                          if (globals.backButtonVoice.isNotEmpty) {
                            audioPlayer.play(
                              globals.backButtonVoice,
                              isLocal: true,
                            );
                          }
                        },
                        child: const Text(
                          "ආපසු",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                onRefresh: model.onRefreshWithBusy,
              ),
        /* floatingActionButton: Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.yellow),
          child: FloatingActionButton(
            onPressed: () async {
              //await model.navigateToCaptureViewPage();
            },
            child: const Icon(Icons.navigate_next),
          ),
        ), */
      ),
      viewModelBuilder: () => SuthraListViewModel(),
    );
  }
}
