import 'package:flutter/material.dart';

class _DetailScreen extends State<DetailScreen> {
  // This widget is the root of your application.

  final String title;
  final String id;
  _DetailScreen({@required this.title, @required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
            itemCount: 100,
            itemBuilder: (context, i) {
              return Center(child: Text('test' + (id == null ? "null" : id)));
            }));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {}
}

class DetailScreen extends StatefulWidget {
  // This widget is the root of your application.
  final String title;
  final String id;
  DetailScreen({@required this.title, @required this.id});
  @override
  _DetailScreen createState() => new _DetailScreen(title: title, id: id);
}

class ItemInfo {
  String add_intro;
  String source;
  String pic_id;
  String file_height;
  String file_width;
  String cover_url;
  String cmt_md5;

  // Item({this.id, this.title, this.coverUrl});
}
