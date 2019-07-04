import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'MyStore.g.dart';

// This is the class used by rest of your codebase
class MyStore = _MyStore with _$MyStore;

// The store-class
abstract class _MyStore with Store {
  _MyStore() {
    _init();
  }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _setTheme(prefs.getBool('darkTheme'));
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
