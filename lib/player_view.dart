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
  //@override
  //int maxduration = 100;
  //int currentpos = 0;
  //String currentpostlabel = "00:00";
  bool isPlaying = false;
  bool audioPlayed = false;

  bool altIsPlaying = false;
  bool altAudioPlayed = false;
  bool altIsCurrent = false;

  //String textData = '';
  //late Uint8List audiobytes;

  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer altAudioPlayer = AudioPlayer();
  AudioPlayer audioClipPlayer = AudioPlayer();

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

      if (!isPlaying && !audioPlayed) {
        int result = await audioPlayer.play(widget.item.file, isLocal: true);
        if (result == 1) {
          //play success
          setState(() {
            isPlaying = true;
            audioPlayed = true;
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
          // Swiping
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
                  // Lang change
                  onLongPress: () async {
                    // pause the current playing file
                    if (altIsPlaying) {
                      int result = await altAudioPlayer.pause();
                      if (result == 1) {
                        altIsPlaying = false;
                      }
                    }
                    if (isPlaying) {
                      int result = await audioPlayer.pause();
                      if (result == 1) {
                        isPlaying = false;
                      }
                    }
                    // switch
                    if (altIsCurrent) {
                      // main lang file
                      int result = await audioPlayer.resume();
                      if (result == 1) {
                        isPlaying = true;
                      }
                      altIsCurrent = false;
                    } else {
                      // alt file
                      if (widget.item.altFile.isNotEmpty) {
                        if (altAudioPlayed) {
                          int result = await altAudioPlayer.resume();
                          if (result == 1) {
                            altIsPlaying = true;
                          }
                        } else {
                          int result = await altAudioPlayer.play(
                            widget.item.altFile,
                            isLocal: true,
                          );
                          if (result == 1) {
                            altAudioPlayed = true;
                            altIsPlaying = true;
                          }
                        }
                        altIsCurrent = true;
                      }
                    }
                  },
                  onTap: () async {
                    // pause or resume
                    /* if (!isPlaying && !audioPlayed) {
                      int result = await audioPlayer.play(
                        widget.item.file,
                        isLocal: true,
                      );

                      if (result == 1) {
                        //play success
                        setState(() {
                          isPlaying = true;
                          audioPlayed = true;
                        });
                      }
                    } */

                    if (altIsCurrent) {
                      if (altAudioPlayed && !altIsPlaying) {
                        int result = await altAudioPlayer.resume();
                        if (result == 1) {
                          altIsPlaying = true;
                        }
                      } else {
                        int result = await altAudioPlayer.pause();
                        if (result == 1) {
                          altIsPlaying = false;
                        }
                      }
                    } else {
                      if (audioPlayed && !isPlaying) {
                        int result = await audioPlayer.resume();
                        if (result == 1) {
                          isPlaying = true;
                        }
                      } else {
                        int result = await audioPlayer.pause();
                        if (result == 1) {
                          isPlaying = false;
                        }
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
                    await audioPlayer.stop();
                    if (altAudioPlayed) {
                      await altAudioPlayer.stop();
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
