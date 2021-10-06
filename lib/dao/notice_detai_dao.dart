import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/notice_detail_model.dart';

class NoticeDetailDao {
  static Future fetch(int id) async {
    Map<String, dynamic> params = {
      'id': id
    };
    var res = await HttpRequest.getInstance()
        .request('fm.notice.selectAllNoticeById', params: params);
    return NoticeDetailModel.fromJson(res['data']);
  }
}