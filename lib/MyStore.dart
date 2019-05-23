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
    darkTheme = prefs.getBool('darkTheme');
  }

  @observable
  bool darkTheme = false;

  @action
  void changeTheme() async {
    darkTheme = !darkTheme;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', darkTheme);
  }
}
