import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../utils/comman/commanWidget.dart';

class MediaPlayerUrl extends StatefulWidget {
  final Map<String,dynamic> urlMap;
  final AudioPlayer audioPlayer;
  const MediaPlayerUrl(this.urlMap,this.audioPlayer,{Key? key}) : super(key: key);

  @override
  State<MediaPlayerUrl> createState() => _MediaPlayerUrlState();
}

class _MediaPlayerUrlState extends State<MediaPlayerUrl> {

  Duration playerDuration = Duration.zero;
  Duration playerPostion = Duration.zero;

  @override
  void initState() {
    // TODO: implement initState
    initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.audioPlayer.dispose();
    super.dispose();
  }

  initPlayer(){
    /*https://www.youtube.com/watch?v=MB3YGQ-O`1lk*/
    widget.audioPlayer.onPlayerStateChanged.listen((state) {
      print("onPlayerStateChanged");
      widget.urlMap["isPlaying"] = CommanWidgets().isPLAYING(state);
     /* setState(() {
      });*/
    });

    widget.audioPlayer.onPlayerComplete.listen((event) {
      playerPostion = Duration.zero;
      widget.audioPlayer.stop();
    });

    widget.audioPlayer.onDurationChanged.listen((newPosition) {
      playerDuration =newPosition;
    });
    widget.audioPlayer.onPositionChanged.listen((newPosition) {
      playerPostion =newPosition;
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return audioPlayerWidget();
  }
  Widget audioPlayerWidget(){
    String twoDigits(int n) => n.toString().padLeft(1);
    final twoDigitMinutes = twoDigits(playerPostion.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(playerPostion.inSeconds.remainder(60));
    return Row(
      children: [
        InkWell(onTap : () async {
          if(widget.urlMap["isPlaying"]){
            await widget.audioPlayer.pause();
            widget.urlMap["isPlaying"] = false;
            setState(() {

            });
          }else{
            await widget.audioPlayer.play(UrlSource(widget.urlMap["url"]));
            widget.urlMap["isPlaying"]  = true;
            setState(() {
            });
          }
        }, child: widget.urlMap["isPlaying"] ? Icon(Icons.stop) : Icon(Icons.play_arrow)),
        SizedBox(width: 16,),
        Expanded(
          child: Slider(
            min: 0,
            max: playerDuration.inSeconds.toDouble(),
            value: playerPostion.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await widget.audioPlayer.seek(position);
            },
          ),
        ),
        SizedBox(width: 16,),
        Text(
          '$twoDigitMinutes:$twoDigitSeconds',
          style: TextStyle(fontSize: 15),
        )
      ],
    );
  }
}
