import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/utils/merInfo.dart';

class MyWalletListDao {
  static Future fetch() async {
    var memberId = await MerInfo.getMemId();
    Map<String, dynamic> parms = {
      "memberId": memberId
    };
    var res = await HttpRequest.getInstance()
        .request('fm.memberWallet.findList', params: parms);
    return res['data'];
  }

  static Future addWallet(String address,String coinType,String memo,String remarks) async {
    var memberId = await MerInfo.getMemId();
    Map<String, dynamic> parms = {
      "memberId": memberId,
      "address": address,
      "coinType": coinType,
      "memo": memo,
      "remarks":remarks
    };
    var res = await HttpRequest.getInstance()
        .request('fm.memberWallet.add', params: parms);
    return res['data'];
  }
  static Future<bool> delWallet(String coinType,String address) async {
    await MerInfo.getMemId();
    Map<String, dynamic> parms = {
      "coinType": coinType,
      "address": address
    };
    var res = await HttpRequest.getInstance()
        .request('fm.memberWallet.deleteByMember', params: parms);
    return res['data'];
  }

}