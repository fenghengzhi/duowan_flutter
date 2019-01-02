import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
            // onPanUpdate: panUpdateHandler,
            onScaleUpdate: scaleUpdateHandler,
            onScaleStart: scaleStartHandler,
            child: Transform.scale(
                scale: scale,
                child: Transform.translate(
                    // transform: new Matrix4.identity()..translate(0),
                    offset: Offset(offsetX, offsetY),
                    child: Image.network(source)))));
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
  @override
  _ImageViewer createState() => _ImageViewer();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ImageViewer(),
    );
  }
}
