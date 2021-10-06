import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/login_model.dart';

class LoginDao {
  static Future fetch(loginAccount, password) async {
    Map<String, dynamic> parms = {
      "loginAccount": loginAccount,
      "password": password
    };
    var res = await HttpRequest.getInstance()
        .request('fm.member.login', params: parms);
    return LoginModel.fromJson(res['data']);
  }

  static Future register(mobile, shortCode,loginPassword,inviteCode) async {
    Map<String, dynamic> parms = {
      "mobile": mobile,
      "verificationCode": shortCode,
      "loginPassword": loginPassword,
      "inviteCode": inviteCode
    };
    var res = await HttpRequest.getInstance()
        .request('fm.member.register', params: parms);
    return res['data'];
  }

  static Future findPassword(mobile,shortCode, newPassword) async {
    Map<String, dynamic> parms = {
      "mobile": mobile,
      "shortCode": shortCode,
      "newPassword": newPassword
    };
    var res = await HttpRequest.getInstance()
        .request('fm.member.findPasswordByMobile', params: parms);
    return res['data'];
  }

  static Future loginOut() async {
    var res = await HttpRequest.getInstance()
        .request('fm.member.quit');
    return res['data'];
  }
}
