import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/bills_type_model.dart';

class BillsTypeDao {
  static Future fetch() async {
    var res = await HttpRequest.getInstance().request('fm.coinChangeBook.queryType');
    return BillsTypeModel.fromJson(res['data']);
  }
}