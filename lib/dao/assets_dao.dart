import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/assets_coin_in_model.dart';
import 'package:flutter_app_yt/utils/merInfo.dart';

class AssetsDao {
  static Future fetch() async {
    var memberId = await MerInfo.getMemId();
    Map<String, dynamic> parms = {
      "memberId": memberId,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.memberBalance.getNew', params: parms);
    return res['data'];
  }

  static Future updateDisplayOrder(List order) async {
    Map<String, dynamic> parms = {
      "order": order,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.memberBalance.updateDisplayOrder', params: parms);
    return res['data'];
  }

  static Future coinOutType() async {
    var res =
        await HttpRequest.getInstance().request('fm.systemProperties.withdraw');
    return res['data'];
  }

  static Future walletList() async {
    var memberId = await MerInfo.getMemId();
    Map<String, dynamic> parms = {
      "memberId": memberId,
      "page": 1,
      "pageSize": 100
    };
    var res = await HttpRequest.getInstance()
        .request('fm.memberWallet.findList', params: parms);
    return res['data'];
  }

  static Future checkConfirmPasswordIsNull() async {
    var res = await HttpRequest.getInstance()
        .request('fm.order.checkConfirmPasswordIsNull');
    return res['data'];
  }

  static Future outSubmit(
      coinType, outNum, address, shortCode, confirmPassword, currentTag) async {
    var memberId = await MerInfo.getMemId();
    Map<String, dynamic> parms = {
      "memberId": memberId,
      "coinType": coinType,
      "changeType": 'out',
      'amount': outNum,
      "changeReason": '提币',
      "toAddress": address,
      "shortCode": shortCode,
      "confirmPassword": confirmPassword,
      "remarks": currentTag
    };
    var res = await HttpRequest.getInstance()
        .request('fm.coinChangeBook.submit', params: parms);
    return res;
  }

  static Future assetsIn(String coinType) async {
    var memberId = await MerInfo.getMemId();
    Map<String, dynamic> parms = {"memberId": memberId, "coinType": coinType};
    var res = await HttpRequest.getInstance()
        .request('fm.memberPrivateWallet.queryByParam', params: parms);
    return AssetsCoinInModel.fromJson(res['data']);
  }

  static Future transferCoinList() async {
    Map<String, dynamic> parms = {"transfer": 1};
    var res = await HttpRequest.getInstance()
        .request('fm.memberPrivateWallet.queryByCoinType', params: parms);
    return res['data'];
  }

  static Future transferSubmit(
      toMemberId,outNum,confirmPassword,coinType,shortCode) async {
    Map<String, dynamic> parms = {
      "toMemberId": toMemberId,
      "coinType": coinType,
      'amount': outNum,
      "shortCode": shortCode,
      "confirmPassword": confirmPassword,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.coinChangeBook.transfer', params: parms);
    return res;
  }
}
