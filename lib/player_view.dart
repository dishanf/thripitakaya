import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tipitaka/item.dart';
import 'package:tipitaka/player_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'globals.dart' as globals;

class PlayerView extends StatefulWidget {
  final Item item;
  const PlayerView({Key? key, required this.item}) : super(key: key);

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  @override
  //int maxduration = 100;
  int currentpos = 0;
  String currentpostlabel = "00:00";
  bool isplaying = false;
  bool audioplayed = false;
  String textData = '';
  late Uint8List audiobytes;

  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer audioClipPlayer = AudioPlayer();
  //final player = AudioCache();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      //ByteData bytes = await rootBundle.load(audioasset); //load audio from assets
      //audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      //convert ByteData to Uint8List

      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      /* player.onDurationChanged.listen((Duration d) {
        //get the duration of audio
        maxduration = d.inMilliseconds;
        setState(() {});
      }); */

      /* player.onAudioPositionChanged.listen((Duration p) {
        currentpos =
            p.inMilliseconds; //get the current position of playing audio

        //generating the duration label
        int shours = Duration(milliseconds: currentpos).inHours;
        int sminutes = Duration(milliseconds: currentpos).inMinutes;
        int sseconds = Duration(milliseconds: currentpos).inSeconds;

        int rhours = shours;
        int rminutes = sminutes - (shours * 60);
        int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

        currentpostlabel = "$rhours:$rminutes:$rseconds";

        setState(() async {
          //textData = await File(widget.item.textPath).readAsString();
        });
      }); */

      if (!isplaying && !audioplayed) {
        int result = await audioPlayer.play(widget.item.file, isLocal: true);
        if (result == 1) {
          //play success
          setState(() {
            isplaying = true;
            audioplayed = true;
          });
        } else {
          //print("Error while playing audio.");
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PlayerViewModel>.reactive(
      onModelReady: (model) => model.init(),
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
              fontSize: 18,
            ),
          ),
        ),
        body: GestureDetector(
          onPanUpdate: (details) async {
            // Swiping in right direction.
            if (details.delta.dx > 0) {
              int duration = await audioPlayer.getDuration();
              int pos = await audioPlayer.getCurrentPosition();
              if (pos + 10000 < duration) {
                await audioPlayer.seek(
                  Duration(
                    milliseconds: pos + 10000,
                  ),
                );
              } else {
                if (globals.seekEndClip.isNotEmpty) {
                  audioClipPlayer.play(
                    globals.seekEndClip,
                    isLocal: true,
                  );
                }
              }
            }

            // Swiping in left direction.
            if (details.delta.dx < 0) {
              int pos = await audioPlayer.getCurrentPosition();
              if (10000 < pos) {
                await audioPlayer.seek(
                  Duration(
                    milliseconds: pos - 10000,
                  ),
                );
              } else {
                if (globals.seekEndClip.isNotEmpty) {
                  audioClipPlayer.play(
                    globals.seekEndClip,
                    isLocal: true,
                  );
                }
                await audioPlayer.seek(
                  const Duration(
                    milliseconds: 0,
                  ),
                );
              }
            }
          },
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (!isplaying && !audioplayed) {
                      int result = await audioPlayer.play(widget.item.file,
                          isLocal: true);
                      if (result == 1) {
                        //play success
                        setState(() {
                          isplaying = true;
                          audioplayed = true;
                        });
                      } else {
                        //print("Error while playing audio.");
                      }
                    } else if (audioplayed && !isplaying) {
                      int result = await audioPlayer.resume();
                      if (result == 1) {
                        //resume success
                        setState(() {
                          isplaying = true;
                          audioplayed = true;
                        });
                      } else {
                        //print("Error on resume audio.");
                      }
                    } else {
                      int result = await audioPlayer.pause();
                      if (result == 1) {
                        //pause success
                        setState(() {
                          isplaying = false;
                        });
                      } else {
                        //print("Error on pause audio.");
                      }
                    }
                  },
                  child: const Center(
                    child: Icon(
                      Icons.volume_up_rounded,
                      size: 100,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                child: MaterialButton(
                  height: 80,
                  minWidth: double.infinity,
                  color: Colors.greenAccent,
                  onPressed: () async {
                    if (globals.backButtonVoice.isNotEmpty) {
                      audioPlayer.play(
                        globals.backButtonVoice,
                        isLocal: true,
                      );
                    }
                  },
                  onLongPress: () async {
                    int result = await audioPlayer.stop();
                    if (result == 1) {
                      //stop success
                      setState(() {
                        isplaying = false;
                        audioplayed = false;
                        currentpos = 0;
                      });
                    } else {
                      //print("Error on stop audio.");
                    }
                    Navigator.pop(context);
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
        ),
      ),
      viewModelBuilder: () => PlayerViewModel(),
    );
  }
}
