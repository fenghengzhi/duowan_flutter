import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'PicInfo.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:cached_network_image/cached_network_image.dart';

class ImageViewer extends StatelessWidget {
  final PicInfo picInfo;
  ImageViewer(this.picInfo);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: _Viewer(picInfo));
  }
}

class _ViewerState extends State<_Viewer> {
  final PicInfo picInfo;
  _ViewerState(this.picInfo);
  double _scale = 1.0;
  double _startScale = 1.0;
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  double _startOffsetX = 0.0;
  double _startOffsetY = 0.0;

  Offset _startFocal = Offset.zero;

  Offset _origin = Offset(0, 0);
  GlobalKey _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Center(
            child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                child: Transform(
                    origin: _origin,
                    transform: Matrix4.identity()
                      ..translate(_offsetX, _offsetY)
                      ..scale(_scale, _scale),
                    child: Container(
                        width: picInfo.file_width.toDouble(),
                        height: picInfo.file_height.toDouble(),
                        child: GestureDetector(
                            onDoubleTap: doubleTapHandler,
                            onScaleUpdate: scaleUpdateHandler,
                            onScaleStart: scaleStartHandler,
                            child: CachedNetworkImage(
                                key: _key,
                                fit: BoxFit.fitWidth,
                                imageUrl: picInfo.source)))))));
  }

  doubleTapHandler() {
    FocusScope.of(context).requestFocus(FocusNode());
    this._openInWebview(
        'http://www.duowan.com/mComment/index.html?domain=tu.duowan.com&uniqid=${picInfo.cmt_md5}&url=/');
  }

  scaleStartHandler(ScaleStartDetails details) {
    final RenderBox renderBox = _key.currentContext.findRenderObject();
    final leftTop = renderBox.localToGlobal(Offset.zero);
    final origin =
        (details.focalPoint - leftTop) / _scale; //点击的像素距图片左上角坐标（换算成scale=1下）

    _offsetX = _offsetX + (origin.dx - _origin.dx) * (_scale - 1.0);
    _offsetY = _offsetY + (origin.dy - _origin.dy) * (_scale - 1.0);

    _origin = origin;
    _startOffsetX = _offsetX;
    _startOffsetY = _offsetY;
    _startScale = _scale;

    _startFocal = details.focalPoint;
  }

  scaleUpdateHandler(ScaleUpdateDetails details) {
    setState(() {
      _scale = details.scale * _startScale;
      _offsetX = details.focalPoint.dx - _startFocal.dx + _startOffsetX;
      _offsetY = details.focalPoint.dy - _startFocal.dy + _startOffsetY;
    });
  }

  Future<Null> _openInWebview(String url) async {
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
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (ctx) => WebviewScaffold(
      //           initialChild: Center(child: CircularProgressIndicator()),
      //           url: url,
      //           appBar: AppBar(title: Text(url)),
      //         ),
      //   ),
      // );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('URL $url can not be launched.'),
        ),
      );
    }
  }
}

class _Viewer extends StatefulWidget {
  final PicInfo picInfo;
  _Viewer(this.picInfo);
  @override
  _ViewerState createState() => _ViewerState(picInfo);
}
