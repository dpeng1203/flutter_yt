import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/bill_items_model.dart';

class BillsItemsDao {
  static Future<BillsItemsModel> fetch(int page, coinType, coinState, changeType) async {
    Map<String, dynamic> parms = {
      "page": page,
      "pageSize": 10,
    };

    if(coinType!= '-1') {
      parms['coinType'] = coinType;
    }

    if (coinState != '-1') {
      parms['coinState'] = coinState;
    }

    if (changeType != '-1') {
      parms['changeType'] = changeType;
    }

    try {
      var res = await HttpRequest.getInstance().request('fm.coinChangeBook.queryByParamAndPageForApp', params: parms);
        return BillsItemsModel.fromJson(res['data']);
    } catch (e) {
        return e;
    }
    
  }
}