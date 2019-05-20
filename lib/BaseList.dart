import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'CustomCacheManager.dart';
import 'DetailScreen.dart';
import 'Resource.dart';

class _BaseListState extends State<BaseList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<Resource> resources = [];
  final String apiUrl;

  _BaseListState(this.apiUrl);

  @override
  Widget build(BuildContext context) => RefreshIndicator(
      onRefresh: getData,
      child: Scrollbar(
          child: StaggeredGridView.countBuilder(
        physics: BouncingScrollPhysics(),
        primary: false,
        crossAxisCount: 4,
        itemCount: resources.length,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        itemBuilder: (BuildContext context, int index) =>
            _Item(resources[index]),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      )));

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      final body = json.decode(response.body);
      final String html = body["html"];

      final document = parse(html);
      final liboxes = document.querySelectorAll('li.box');
      final _resources = liboxes.map((box) {
        final title = box.querySelector('em a').text;
        final String coverUrl = box.querySelector('img').attributes['src'];
        final exp = RegExp(r"([0-9]*)(?=.html$)");
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

abstract class BaseList extends StatefulWidget {
  @override
  _BaseListState createState() => _BaseListState(getApiUrl());

  @protected
  String getApiUrl();
}

class IntSize {
  const IntSize(this.width, this.height);

  final int width;
  final int height;
}

class _Item extends StatelessWidget {
  final IntSize size = IntSize(100, 100);
  final Resource resource;

  _Item(this.resource);

  @override
  Widget build(BuildContext context) => FlatButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailScreen(title: resource.title, id: resource.id))),
      child: Column(children: [
        CachedNetworkImage(
          fit: BoxFit.fitWidth,
          imageUrl: resource.coverUrl,
          cacheManager: CustomCacheManager(),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Text(resource.title)
      ]));
}
