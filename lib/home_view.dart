import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tipitaka/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<HomeView> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.greenAccent,
          centerTitle: true,
          elevation: 0.3,
          title: const Text(
            'ත්‍රිපිටකය',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.greenAccent,
              ),
              onPressed: () async {
                await model.navigateToSettingsViewPage();
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
                      onLongPress: () async {
                        await model.navigateToSuthraListViewPage(
                          model.items[index],
                        );
                      },
                      child: Card(
                        shadowColor: Colors.black,
                        elevation: 5,
                        child: ListTile(
                          /* leading: Icon(
                            Icons.auto_stories_rounded,
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
                          /* subtitle: Text(
                            model.items[index].date
                                .replaceFirst('T', ' ')
                                .substring(0, 16),
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ), */
                        ),
                        margin: const EdgeInsets.all(1.0),
                      ),
                    );
                  },
                ),
                onRefresh: model.onRefreshWithBusy,
              ),
        /*  floatingActionButton: Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.yellow),
          child: FloatingActionButton(
            onPressed: () async {
              //await model.navigateToCaptureViewPage();
            },
            child: const Icon(Icons.navigate_next),
          ),
        ), */
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
