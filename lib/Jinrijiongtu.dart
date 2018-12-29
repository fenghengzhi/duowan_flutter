import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class _JinrijiongtuState extends State<Jinrijiongtu>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  List<Post> post = [];
  String test = 'init';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(test);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: post.map((p) {
        final title = p.title;
        final body = p.body;
        return Text('$title');
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    // print("initState");
    getData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
    // post = [];
    // getData();
  }

  void getData() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/posts/1');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      setState(() {
        test = response.body;
      });
      // test = response.body;
      final _post = Post.fromJson(json.decode(response.body));
      post.add(_post);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}

class Jinrijiongtu extends StatefulWidget {
  @override
  _JinrijiongtuState createState() => new _JinrijiongtuState();
}

Future<Post> fetchPost() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
