import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ImageViewer.dart';
import 'PicInfo.dart';
import 'VideoPlayer.dart';

class _DetailScreen extends State<DetailScreen> {
  final String title;
  final String id;

  _DetailScreen({@required this.title, @required this.id});

  List<PicInfo> picInfos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Scrollbar(
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: picInfos.length,
                itemBuilder: buildItem)));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final response = await http
        .get('http://tu.duowan.com/index.php?r=show/getByGallery/&gid=$id');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> picInfosJson = data['picInfo'].toList();
      String format(String str) {
        if (RegExp(r'^\/\/.*$').hasMatch(str)) {
          return 'http:' + str;
        } else {
          return str;
        }
      }

      final _picInfos = picInfosJson.map((picInfo) {
        ['url', 'video_url', 'mp4_url', 'cover_url'].forEach((key) {
          picInfo[key] = format(picInfo[key]);
        });

        return PicInfo(
          add_intro: picInfo['add_intro'],
          pic_id: picInfo['pic_id'],
          file_height: int.parse(picInfo['file_height'].toString()),
          file_width: int.parse(picInfo['file_width'].toString()),
          cover_url: picInfo['cover_url'],
          cmt_md5: picInfo['cmt_md5'],
          url: picInfo['url'],
          video_url: picInfo['video_url'],
          mp4_url: picInfo['mp4_url'],
        );
      }).toList();
      setState(() {
        picInfos = _picInfos;
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  Widget buildItem(context, i) {
    final picInfo = picInfos[i];
    return FlatButton(
        onPressed: () {
          // print(picInfo.url);
          // print(picInfo.mp4_url);
          // print(picInfo.video_url);
          if (picInfo.video_url.isNotEmpty) {
            // print('videoplayer');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VideoPlayer(picInfo)));
          } else {
            // print('iamgeviewer');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ImageViewer(picInfo)));
          }
        },
        child: Column(children: [
          AspectRatio(
              aspectRatio: picInfo.file_width / picInfo.file_height,
              child: CachedNetworkImage(
                  placeholder: (BuildContext context, String url) {
                    return new CircularProgressIndicator();
                  },
                  fit: BoxFit.fitWidth,
                  imageUrl: picInfo.url)),
          Center(child: Text(picInfo.add_intro))
        ]));
  }
}

class DetailScreen extends StatefulWidget {
  final String title;
  final String id;

  DetailScreen({@required this.title, @required this.id});

  @override
  _DetailScreen createState() => new _DetailScreen(title: title, id: id);
}
