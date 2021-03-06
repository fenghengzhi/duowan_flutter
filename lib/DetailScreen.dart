import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'CustomCacheManager.dart';
import 'ImageViewer.dart';
import 'PicInfo.dart';
import 'VideoPlayer.dart';

class _DetailScreen extends State<DetailScreen> {
  final String title;
  final String id;

  _DetailScreen({@required this.title, @required this.id});

  List<PicInfo> _picInfos = [];

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Scrollbar(
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _picInfos.length,
              itemBuilder: (context, i) => _Item(_picInfos[i]))));

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
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

      final picInfos = picInfosJson.map((picInfo) {
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
        _picInfos = picInfos;
      });
    } else {
      throw Exception('Failed to load post');
    }
  }
}

class _Item extends StatelessWidget {
  const _Item(this.picInfo);

  final PicInfo picInfo;

  @override
  Widget build(BuildContext context) {
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
          // AspectRatio(
          // aspectRatio: picInfo.file_width / picInfo.file_height,
          // child:
          CachedNetworkImage(
              placeholder: (context, url) => AspectRatio(
                  aspectRatio: picInfo.file_width / picInfo.file_height,
                  child: Center(child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => AspectRatio(
                  aspectRatio: picInfo.file_width / picInfo.file_height,
                  child: Icon(Icons.error)),
              cacheManager: CustomCacheManager(),
              fit: BoxFit.fitWidth,
              width: double.infinity,
              imageUrl: picInfo.url),
          // imageUrl: 'https://via.placeholder.com/1000x1000'),
          Center(child: Text(picInfo.add_intro))
        ]));
  }
}

class DetailScreen extends StatefulWidget {
  final String title;
  final String id;

  DetailScreen({@required this.title, @required this.id});

  @override
  _DetailScreen createState() => _DetailScreen(title: title, id: id);
}
