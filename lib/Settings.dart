import 'package:flutter/material.dart';

import 'CustomCacheManager.dart';

class _Settings extends State<Settings> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _size = 0;

  _Settings();

  @override
  Widget build(BuildContext context) => Scrollbar(
          child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('清除缓存'),
            subtitle: Text('${(_size / 1024 / 1024).toStringAsFixed(2)}mb'),
            trailing: Icon(Icons.chevron_right),
            onTap: _showDialog,
          ),
          Divider()
        ],
      ));

  @override
  void initState() {
    print('initState');
    super.initState();
    getCacheSize();
  }

  getCacheSize() async {
    print('getCacheSize');
    final size = await CustomCacheManager().getSize();
    print('cacheSize${size}');
    setState(() {
      _size = size;
    });
  }

  _clearCache() async {
    await CustomCacheManager().emptyCache();
    await getCacheSize();
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: new Text("确认清除缓存吗？"),
//          content: new Text("Alert Dialog body"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                FlatButton(
                  child: new Text("取消"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                    child: new Text("确认"),
                    onPressed: () async {
                      await _clearCache();
                      Navigator.of(context).pop();
                    }),
              ],
            ));
  }
}

class Settings extends StatefulWidget {
  Settings();

  static _Settings _instance;

  @override
  _Settings createState() {
    _instance = _Settings();
    return _instance;
  }

  getCacheSize() async {
    if (_instance != null) {
      _instance.getCacheSize();
    } else {
      print('instance null');
    }
  }
}
