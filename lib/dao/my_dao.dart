import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/my_model.dart';
import 'package:flutter_app_yt/utils/merInfo.dart';

class MyDao {
  static Future fetch() async {
    var memberId = await MerInfo.getMemId();
    try{
      Map<String, dynamic> parms = {
        "memberId": memberId
      };
      var res = await HttpRequest.getInstance()
          .request('fm.member.get', params: parms);
      return MyModel.fromJson(res['data']);
    }catch(e){
      print(e);
    }

  }

  static Future upLoadImage(file) async {
    var res = await HttpRequest.getInstance().upLoad(file);
    return res;
  }

  static Future updateImg(memberId,logoPath) async {
    Map<String, dynamic> parms = {
      "memberId": memberId,
      "logoPath": logoPath,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.member.update', params: parms);
    return res['data'];
  }
}