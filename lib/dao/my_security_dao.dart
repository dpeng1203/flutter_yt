import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/my_security_cert_model.dart';
import 'package:flutter_app_yt/utils/merInfo.dart';

class MySecurityDao {
  static Future getCode(String mobile,String modityType) async {
    Map<String, dynamic> parms = {
      "operateType": modityType,
      "target": mobile,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.shortCode.send', params: parms,isNeedLoading: false);
    return res['data'];
  }

  static Future getFindPasswordCode(String mobile,String modityType) async {
    Map<String, dynamic> parms = {
      "operateType": modityType,
      "target": mobile,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.shortCode.findPwd', params: parms,isNeedLoading: false);
    return res['data'];
  }

  static Future resetPassword(code, newPassword, mobile) async {
    Map<String, dynamic> parms = {
      "shortCode": code,
      "newPassword": newPassword,
      "mobile": mobile,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.member.resetPasswordByMobile', params: parms);
    return res['data'];
  }

  static Future resetConfirmPassword(code, newPassword, mobile) async {
    Map<String, dynamic> parms = {
      "shortCode": code,
      "newPassword": newPassword,
      "mobile": mobile,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.member.resetConfirmPasswordByMobile', params: parms);
    return res['data'];
  }

  static Future addCert(name, certData) async {
    var memberId = await MerInfo.getMemId();
    Map<String, dynamic> parms = {
      "memberId": memberId,
      "certProfileType": "pcard",
      "realName": name,
      "certData": certData
    };
    var res = await HttpRequest.getInstance()
        .request('fm.memberCert.add', params: parms);
    return res['data'];
  }

  static Future upDateCert(name, certData) async {
    var memberId = await MerInfo.getMemId();
    Map<String, dynamic> parms = {
      "memberId": memberId,
      "certProfileType": "pcard",
      "realName": name,
      "certData": certData
    };
    var res = await HttpRequest.getInstance()
        .request('fm.memberCert.update', params: parms);
    return res['data'];
  }

  static Future getCertInfo() async {
    var memberId = await MerInfo.getMemId();
    Map<String, dynamic> parms = {
      "memberId": memberId,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.memberCert.get', params: parms);
    if(res['data'] != null) {
      return MySecurityCertModel.fromJson(res['data']);
    }else {
      return null;
    }

  }

}
