import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class MediaPlayerUrl extends StatefulWidget {
  final Map<String, dynamic> urlMap;

  const MediaPlayerUrl(this.urlMap, {Key? key}) : super(key: key);

  @override
  State<MediaPlayerUrl> createState() => _MediaPlayerUrlState();
}

class _MediaPlayerUrlState extends State<MediaPlayerUrl> {
  final player = AudioPlayer();

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
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
    player.dispose();
    super.dispose();
  }

  initPlayer() async {
    /*https://www.youtube.com/watch?v=MB3YGQ-O`1lk*/
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    await player.setUrl(widget.urlMap["url"]) ?? Duration.zero;
    player.playbackEventStream.listen((event) {
    },
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    player.playerStateStream.listen((event) async {
      switch (event.processingState) {
        case ProcessingState.completed:
          {
            print("completed;");
            widget.urlMap["isPlaying"] = false;
            await player.pause();
            player.seek(Duration.zero);
            setState(() {
            });
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
                  if (widget.urlMap["isPlaying"]) {
                    //await widget.audioPlayer.pause();
                    await player.pause();
                    widget.urlMap["isPlaying"] = false;
                    setState(() {});
                  } else {
                    await player.play();
                    widget.urlMap["isPlaying"] = true;
                    setState(() {});
                  }
                },
                child: widget.urlMap["isPlaying"]
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
                  player.seek(newPosition);
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
