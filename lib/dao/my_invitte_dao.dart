import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/my_invitte_model.dart';

class MyInvitteDao {
  static Future fetch() async {
    var res = await HttpRequest.getInstance()
        .request('fm.inviteCode.getInviteImage');
    return MyInvitteModel.fromJson(res['data']);
  }
}
