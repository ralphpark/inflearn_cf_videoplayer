import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({super.key, required this.video, required this.onNewVideoPressed});

  final XFile video;
  final VoidCallback onNewVideoPressed;

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;
  bool showControls = false;
  Duration currentPosition = Duration();

  @override
  void initState() {
    super.initState();
    initialzedController();
  }
//didUpateWidget은 위젯이 업데이트 될 때 호출되는 메서드입니다. 이 메서드는 위젯이 업데이트 될 때 호출되는데, 이때 이전 위젯과 새로운 위젯을 비교하여 업데이트가 필요한 경우 호출됩니다.
  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.video.path != widget.video.path){
      initialzedController();
    }
  }

  initialzedController() async {
    currentPosition = Duration();
    videoController = VideoPlayerController.file(
      File(widget.video.path),
    );
    await videoController!.initialize();
    videoController!.addListener(() {
      setState(() {
        currentPosition = videoController!.value.position;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return CircularProgressIndicator();
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
              aspectRatio: videoController!.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(videoController!),
                  if(showControls)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                    )
                ],
              )),
            if(showControls)
              _Controls(
              onPlayPressed: onPlayPressed,
              onRotateLeftPressed: onRotateLeftPressed,
              onRotateRightPressed: onRotateRightPressed,
              isPlaying: videoController!.value.isPlaying,
              ),
            if(showControls)
              _NewVideo(
                onPressed:widget.onNewVideoPressed,
              ),
          _SliderBottom(
            currentPosition: currentPosition,
            maxPosition: videoController!.value.duration,
            onSliderChanged: onSliderChanged,
          ),
        ],
      ),
    );
  }
  void onSliderChanged(value) {
      videoController!.seekTo(Duration(seconds: value.toInt()));
    }


  void onPlayPressed(){
    if(videoController!.value.isPlaying){
      videoController!.pause();
    }else{
      videoController!.play();
    }
    setState(() {});
  }
  void onRotateLeftPressed(){
    final currentPosition = videoController!.value.position;
    Duration position = Duration();
    if(currentPosition.inSeconds > 3){
      position = currentPosition - Duration(seconds: 3);
    }
    videoController!.seekTo(position);
    setState(() {});
  }
  void onRotateRightPressed(){
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;
    Duration position = Duration();
    if((maxPosition - Duration(seconds: 3)).inSeconds > currentPosition.inSeconds){
      position = currentPosition + Duration(seconds: 3);
    }
    videoController!.seekTo(position);
    setState(() {});
  }
}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onRotateLeftPressed;
  final VoidCallback onRotateRightPressed;
  final bool isPlaying;
  const _Controls({super.key, required this.onPlayPressed, required this.onRotateLeftPressed, required this.onRotateRightPressed, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _renderIconButton(
          onPressed: onRotateLeftPressed,
          iconData: Icons.rotate_left,
        ),
        _renderIconButton(
          onPressed: onPlayPressed,
          iconData: isPlaying ? Icons.pause : Icons.play_arrow,
        ),
        _renderIconButton(
          onPressed: onRotateRightPressed,
          iconData: Icons.rotate_right,
        ),
      ],
    );
  }

  Widget _renderIconButton({
    required VoidCallback onPressed,
    required IconData iconData,
  }) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 30,
      color: Colors.white,
      icon: Icon(
        iconData,
      ),
    );
  }
}

class _NewVideo extends StatelessWidget {
  const _NewVideo({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.photo_camera_back,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class _SliderBottom extends StatelessWidget {
  const _SliderBottom({super.key, required this.currentPosition, required this.maxPosition, required this.onSliderChanged});
  final Duration currentPosition;
  final Duration maxPosition;
  final ValueChanged<double> onSliderChanged;


  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Text(
              '${currentPosition!.inMinutes}:${(currentPosition!.inSeconds % 60).toString().padLeft(2, '0')}/${maxPosition.inMinutes}'':${(maxPosition.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Slider(
                value: currentPosition!.inSeconds.toDouble(),
                max: maxPosition.inSeconds.toDouble(),
                min: 0,
                onChanged: onSliderChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
