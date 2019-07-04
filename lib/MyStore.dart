import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'MyStore.g.dart';

class MyStore = MyStoreBase with _$MyStore;

abstract class MyStoreBase implements Store {
  MyStoreBase() {
    _init();
  }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _setTheme(prefs.getBool('darkTheme') || false);
  }

  @observable
  bool darkTheme = false;

  @action
  _setTheme(_darkTheme) {
    darkTheme = _darkTheme;
  }

  changeTheme() async {
    _setTheme(!darkTheme);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', darkTheme);
  }
}