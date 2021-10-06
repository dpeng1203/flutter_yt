import 'package:flutter_app_yt/common/daoUtils.dart';

class NoticeDao {
  static Future fetch() async {
    var res = await HttpRequest.getInstance()
        .request('fm.notice.selectAllTitleAndPublishTimeAndId', params: {'pageSize':50, 'page': 1});
    return res['data'];
  }
}