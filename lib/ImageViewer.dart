import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'PicInfo.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class _ImageViewer extends State<ImageViewer> {
  double offsetX = 0;
  double offsetY = 0;
  double scale = 1;
  Offset startOffset;
  double startScale = 1;
  double startOffsetX = 0;
  double startOffsetY = 0;

  final PicInfo picInfo;
  _ImageViewer(this.picInfo);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                child: Transform.translate(
                    offset: Offset(offsetX, offsetY),
                    child: Transform.scale(
                        scale: scale,
                        child: GestureDetector(
                            onDoubleTap: doubleTapHandler,
                            onScaleUpdate: scaleUpdateHandler,
                            onScaleStart: scaleStartHandler,
                            child: CachedNetworkImage(
                                fit: BoxFit.none,
                                imageUrl: picInfo.source)))))));
  }

  doubleTapHandler() {
    FocusScope.of(context).requestFocus(FocusNode());
    this._openInWebview(
        'http://www.duowan.com/mComment/index.html?domain=tu.duowan.com&uniqid=${picInfo.cmt_md5}&url=/');
 
  }

  scaleStartHandler(ScaleStartDetails details) {
    startOffset = details.focalPoint;
    startOffsetX = offsetX;
    startOffsetY = offsetY;
    startScale = scale;
  }

  scaleUpdateHandler(ScaleUpdateDetails details) {
    setState(() {
      offsetX = startOffsetX + details.focalPoint.dx - startOffset.dx;
      offsetY = startOffsetY + details.focalPoint.dy - startOffset.dy;
      scale = startScale * details.scale;
    });
  }

  Future<Null> _openInWebview(String url) async {
    if (await url_launcher.canLaunch(url)) {
      print(url);
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

class ImageViewer extends StatefulWidget {
  final PicInfo picInfo;
  ImageViewer(this.picInfo);
  @override
  _ImageViewer createState() => _ImageViewer(picInfo);
}
