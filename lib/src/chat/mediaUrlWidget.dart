import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class MediaPlayerUrl extends StatefulWidget {

  final List<Map<String, dynamic>> audioList;
  final int audioListindex;
  final List<AudioPlayer> audioPLayerList;

  const MediaPlayerUrl(this.audioList,this.audioPLayerList, this.audioListindex,{Key? key}) : super(key: key);

  @override
  State<MediaPlayerUrl> createState() => _MediaPlayerUrlState();
}

class _MediaPlayerUrlState extends State<MediaPlayerUrl> with AutomaticKeepAliveClientMixin{


  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          widget.audioPLayerList[widget.audioListindex].positionStream,
          widget.audioPLayerList[widget.audioListindex].bufferedPositionStream,
          widget.audioPLayerList[widget.audioListindex].durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void initState() {
    // TODO: implement initState
    initPlayer();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //widget.audioPlayer.dispose();
    super.dispose();
  }

  initPlayer() async {
    /*https://www.youtube.com/watch?v=MB3YGQ-O`1lk*/

    widget.audioPLayerList[widget.audioListindex].playbackEventStream.listen((event) {
    },
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    widget.audioPLayerList[widget.audioListindex].playerStateStream.listen((event) async {
      switch (event.processingState) {
        case ProcessingState.completed:
          {
            print("completed;");
            print(widget.audioList[widget.audioListindex]["index"]);
            widget.audioPLayerList[widget.audioListindex].seek(Duration.zero);
            widget.audioList[widget.audioListindex]["isPlaying"] = false;
            await widget.audioPLayerList[widget.audioListindex].pause();
            setState(() {});
            break;
          }
        case ProcessingState.idle:
          print("IDLE;");
          break;
        case ProcessingState.loading:
          print("loading;");
          break;
        case ProcessingState.buffering:
          print("buffering;");
          break;
        case ProcessingState.ready:
          print("ready;");
          break;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    print("widget.urlMapindex");
    print(widget.audioList[widget.audioListindex]["index"]);
    print(widget.audioList[widget.audioListindex]);
    return audioPlayerWidget();
  }

  Widget audioPlayerWidget() {
    return StreamBuilder<PositionData>(
      stream: _positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;

        return Row(
          children: [
            InkWell(
                onTap: () async {
                  for(int i = 0; i < widget.audioList.length;i++){
                    if(i != widget.audioListindex){
                      if(widget.audioList[i]["isPlaying"]){
                        print("uybybuno");
                        widget.audioList[i]["isPlaying"] = false;
                        await widget.audioPLayerList[i].pause();

                        i == widget.audioList.length;
                      }
                    }
                  }
                  if (widget.audioList[widget.audioListindex]["isPlaying"]) {
                    //await widget.audioPlayer.pause();
                    widget.audioList[widget.audioListindex]["isPlaying"] = false;

                    await widget.audioPLayerList[widget.audioListindex].pause();
                    setState(() {});
                  } else {
                    widget.audioList[widget.audioListindex]["isPlaying"] = true;
                    final session = await AudioSession.instance;
                    await session.configure(const AudioSessionConfiguration.music());
                    await widget.audioPLayerList[widget.audioListindex].setUrl(widget.audioList[widget.audioListindex]["url"]);
                    await widget.audioPLayerList[widget.audioListindex].play();
                    setState(() {});

                  }
                },
                child: widget.audioList[widget.audioListindex]["isPlaying"]
                    ? Icon(Icons.stop)
                    : Icon(Icons.play_arrow)),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: SeekBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                onChangeEnd: (newPosition) {
                  widget.audioPLayerList[widget.audioListindex].seek(newPosition);
                },
              ),
            ),
            /* SizedBox(width: 16,),
              Text(
                '$twoDigitMinutes:$twoDigitSeconds',
                style: TextStyle(fontSize: 15),
              )*/
          ],
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            activeTrackColor: Colors.blue.shade100,
            inactiveTrackColor: Colors.grey.shade300,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
