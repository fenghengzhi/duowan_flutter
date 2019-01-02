import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'DetailScreen.dart';
import 'Resource.dart';

class _Gifjiongtu extends State<Gifjiongtu>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<Resource> resources = [];
  String test = 'init';
  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget buildBody() {
    return RefreshIndicator(
        onRefresh: getData,
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, _) {
              final rightLength = resources.length ~/ 2;
              final leftLength = (resources.length % 2) + rightLength;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                        children: List.generate(leftLength, (i) => i * 2)
                            .map(buildItem)
                            .toList()),
                    flex: 1,
                  ),
                  Expanded(
                    child: Column(
                        children: List.generate(leftLength, (i) => i * 2 + 1)
                            .map(buildItem)
                            .toList()),
                    flex: 1,
                  ),
                ],
              );
            }));
  }

  Widget buildItem(int i) {
    final p = resources[i];
    return FlatButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailScreen(title: p.title, id: p.id)));
      },
      child: Column(children: [Image.network(p.coverUrl), Text(p.title)]),
    );
  }

  Future<void> getData() async {
    final response =
        await http.get('http://tu.duowan.com/m/bxgif?offset=0&order=created&math=1');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      final body = json.decode(response.body);
      final String html = body["html"];

      final document = parse(html);
      final liboxes = document.querySelectorAll('li.box');
      final _resources = liboxes.map((box) {
        final title = box.querySelector('em a').text;
        final String coverUrl = box.querySelector('img').attributes['src'];
        final exp = new RegExp(r"([0-9]*)(?=.html$)");
        final String href = box.querySelector('a').attributes['href'];
        final id = exp.stringMatch(href);
        // ^http:\/\/tu.duowan.com\/gallery\/
        return Resource(title: title, coverUrl: coverUrl, id: id);
      }).toList();

      setState(() {
        resources = _resources;
      });
    } else {
      throw Exception('Failed to load post');
    }
  }
}

class Gifjiongtu extends StatefulWidget {
  @override
  _Gifjiongtu createState() => new _Gifjiongtu();
}
