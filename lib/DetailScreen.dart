import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ImageViewer.dart';
import 'PicInfo.dart';


class _DetailScreen extends State<DetailScreen> {
  // This widget is the root of your application.

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
        body: ListView.builder(
            itemCount: picInfos.length,
            itemBuilder: (context, i) {
              final picInfo = picInfos[i];
              return Center(
                  child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageViewer(picInfo)));
                      },
                      child: Column(children: [
                        AspectRatio(
                            aspectRatio:
                                picInfo.file_width / picInfo.file_height,
                            child: CachedNetworkImage(
                                placeholder: new CircularProgressIndicator(),
                                fit: BoxFit.fitWidth,
                                imageUrl: picInfo.source)),
                        // Image.network(picInfo.source),
                        Text(picInfo.add_intro)
                      ])));
            }));
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
      print('success');
      // If server returns an OK response, parse the JSON
      final data = json.decode(response.body);
      final List<dynamic> picInfosJson = data['picInfo'].toList();
      final _picInfos = picInfosJson.map((picInfos) {
        // print(1);
        // print('1');
        // print(picInfos['file_height']);

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

  Widget buildItem() {
    return null;
  }
}

class DetailScreen extends StatefulWidget {
  // This widget is the root of your application.
  final String title;
  final String id;
  DetailScreen({@required this.title, @required this.id});
  @override
  _DetailScreen createState() => new _DetailScreen(title: title, id: id);
}
