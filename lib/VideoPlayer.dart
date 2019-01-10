import 'package:video_player/video_player.dart' as vp;
import 'package:flutter/material.dart';
import 'PicInfo.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

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
                onTap: tapHandler,
                onDoubleTap: doubleTapHandler,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: vp.VideoPlayer(_controller),
                ))
            : Container(),
      ),
    );
  }

  tapHandler() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  doubleTapHandler() {
    FocusScope.of(context).requestFocus(FocusNode());
    this._openInWebview(
        'http://www.duowan.com/mComment/index.html?domain=tu.duowan.com&uniqid=${picInfo.cmt_md5}&url=/');
  }

  Future<void> _openInWebview(String url) async {
    if (await url_launcher.canLaunch(url)) {
      // print(url);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => WebviewScaffold(
                    initialChild: Center(child: CircularProgressIndicator()),
                    url: url,
                    appBar: AppBar(title: Text(url)),
                  )));
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('URL $url can not be launched.'),
        ),
      );
    }
  }
}

class VideoPlayer extends StatefulWidget {
  final PicInfo picInfo;
  VideoPlayer(this.picInfo);

  @override
  _VideoPlayerState createState() => _VideoPlayerState(picInfo);
}
