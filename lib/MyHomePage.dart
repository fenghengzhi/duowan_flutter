import 'package:flutter/material.dart';

import 'Gifjiongtu.dart';
import 'Jinrijiongtu.dart';
import 'Zuixinjiongtu.dart';

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  int _selectedIndex = 0;
  final _widgetOptions = [
    Zuixinjiongtu(),
    Jinrijiongtu(),
    Gifjiongtu(),
    Gifjiongtu()
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      // body: Center(
      //   // child: _widgetOptions.elementAt(_selectedIndex),
      //   child: _widgetOptions[_selectedIndex],
      // ),
      body: PageView(
        controller: _controller,
        children: _widgetOptions,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.fiber_new), title: Text('最新囧图')),
          BottomNavigationBarItem(icon: Icon(Icons.today), title: Text('今日囧图')),
          BottomNavigationBarItem(icon: Icon(Icons.gif), title: Text('GIF囧图'))
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ));

  void _onItemTapped(int index) {
    _controller.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }
}
