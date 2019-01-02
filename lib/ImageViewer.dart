import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class _ImageViewer extends State<ImageViewer> {
  final source =
      'https://upload-images.jianshu.io/upload_images/6770730-62b5fa84a90c5ccd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/674/format/webp';
  double offsetX = 0;
  double offsetY = 0;
  double scale = 1;
  Offset startOffset;
  double startScale = 1;
  double lastOffsetX = 0;
  double lastOffsetY = 0;
  final String imageUrl;
  _ImageViewer(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    print(scale);
    return Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
            // onPanUpdate: panUpdateHandler,
            onScaleUpdate: scaleUpdateHandler,
            onScaleStart: scaleStartHandler,
            child: Center(
                child: Container(
                    child: Transform.scale(
                        scale: scale,
                        child: Transform.translate(
                            // transform: new Matrix4.identity()..translate(0),
                            offset: Offset(offsetX, offsetY),
                            child: CachedNetworkImage(
                                // placeholder: new CircularProgressIndicator(),
                                // fit: BoxFit.none,
                                imageUrl: imageUrl)))))));
  }

  scaleStartHandler(ScaleStartDetails details) {
    startOffset = details.focalPoint;
    lastOffsetX = offsetX;
    lastOffsetY = offsetY;
    startScale = scale;
  }

  scaleUpdateHandler(ScaleUpdateDetails details) {
    setState(() {
      offsetX = lastOffsetX + details.focalPoint.dx - startOffset.dx;
      offsetY = lastOffsetY + details.focalPoint.dy - startOffset.dy;
      scale = startScale * details.scale;
    });
  }
}

class ImageViewer extends StatefulWidget {
  final String imageUrl;
  ImageViewer(this.imageUrl);
  @override
  _ImageViewer createState() => _ImageViewer(imageUrl);
}
