import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/home_model.dart';

class HomeDao {
  static Future fetch() async {
    Map<String, dynamic> parms = {"isTop": 1, "page": 1, "pageSize": 5};
    var res = await HttpRequest.getInstance()
        .request('fm.member.getAppHomeData', params: parms);
    return HomeModel.fromJson(res['data']);
  }

  static Future coinFetch() async {
    var res =
        await HttpRequest.getInstance().request('fm.member.getAppCoinPrice');
    return res['data'];
  }
}
