import 'package:flutter_app_yt/common/daoUtils.dart';

class MyQuestionDao {
  static Future fetch() async {
    Map<String, dynamic> parms = {
      "page": 1,
      "pageSize": 50
    };
    var res = await HttpRequest.getInstance()
        .request('fm.question.selectAllQuestion', params: parms);
    return res['data'];
  }

  static Future getMyWorkOrder(memberId) async {
    Map<String, dynamic> parms = {
      "memberId": memberId,
      "page": 1,
      "pageSize": 20
    };
    var res = await HttpRequest.getInstance()
        .request('fm.workOrder.queryByParamAndPage', params: parms);
    return res['data']['rows'];
  }

  static Future getMyWorkOrderSubmit(memberId,detail) async {
    Map<String, dynamic> parms = {
      "memberId": memberId,
      "detail": detail,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.workOrder.add', params: parms);
    return res['data'];
  }
}