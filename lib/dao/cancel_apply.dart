import 'package:flutter_app_yt/common/daoUtils.dart';

class CandelApplyDao {
  static Future fetch(id) async {
    Map<String, dynamic> par = {
      'state': 99,
      'recordCode': id,
    };
    bool success;
    var res = await HttpRequest.getInstance().request('fm.coinChangeBook.revocationCoinChangeBook', params: par);
    if (res != null && res['code'] == '2000') {
      success = true;
    } else {
      success = false;
    }
    return success;
  }
}