import 'BaseList.dart';

class Gifjiongtu extends BaseList {
  @override
  getApiUrl() {
    return 'http://tu.duowan.com/m/bxgif?offset=0&order=created&math=1';
  }
}
