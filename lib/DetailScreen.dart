import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ImageViewer.dart';
import 'PicInfo.dart';

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
                itemCount: picInfos.length, itemBuilder: buildItem)));
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
      final _picInfos = picInfosJson.map((picInfos) {
        return PicInfo(
          add_intro: picInfos['add_intro'],
          source: picInfos['source'],
          pic_id: picInfos['pic_id'],
          file_height: int.parse(picInfos['file_height'].toString()),
          file_width: int.parse(picInfos['file_width'].toString()),
          cover_url: picInfos['cover_url'],
          cmt_md5: picInfos['cmt_md5'],
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ImageViewer(picInfo)));
        },
        child: Column(children: [
          AspectRatio(
              aspectRatio: picInfo.file_width / picInfo.file_height,
              child: CachedNetworkImage(
                  placeholder: new CircularProgressIndicator(),
                  fit: BoxFit.fitWidth,
                  imageUrl: picInfo.source)),
          Center(child:Text(picInfo.add_intro))
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
