import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/mining_model.dart';

class MiningDao {
  /// 获取挖矿账单信息
  /// index 类型
  /// page 页码
  /// pagesize 每页行数
  static Future<MiningData> fetch({MiningPages pages}) async {
    Map<String, dynamic> parms = {
      "index": pages.index,
      "page": pages.page,
      "pageSize": pages.pagesize,
    };

    try {
      var res = await HttpRequest.getInstance()
          .request('fm.mining.getMiningDataNew', params: parms);
      return MiningData.fromJson(res['data']);
    } catch (e) {
      return new MiningData();
    }
  }
}
