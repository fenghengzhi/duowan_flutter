import 'package:video_player/video_player.dart' as vp;
import 'package:flutter/material.dart';
import 'PicInfo.dart';

class _VideoPlayerState extends State<VideoPlayer> {
  final PicInfo picInfo;
  _VideoPlayerState(this.picInfo);

  vp.VideoPlayerController _controller;
  bool _isPlaying = false;
  @override
  void deactivate() {
    super.deactivate();
    _controller.pause();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    String videoUrl;
    if (picInfo.mp4_url.isNotEmpty) {
      videoUrl = picInfo.mp4_url;
    } else {
      videoUrl = picInfo.video_url;
    }

    _controller = vp.VideoPlayerController.network(videoUrl)
      ..setLooping(true)
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        // _controller.play();
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _controller.value.initialized
            ? GestureDetector(
                onTap: () {
                  if (_isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: vp.VideoPlayer(_controller),
                ))
            : Container(),
      ),
    );
  }
}

class VideoPlayer extends StatefulWidget {
  final PicInfo picInfo;
  VideoPlayer(this.picInfo);

  @override
  _VideoPlayerState createState() => _VideoPlayerState(picInfo);
}
