import 'BaseList.dart';

class Zuixinjiongtu extends BaseList {
  @override
  getApiUrl() {
    return 'http://tu.duowan.com/tu?offset=0&order=created&math=1';
  }
}
