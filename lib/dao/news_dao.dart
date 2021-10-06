import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/news_model.dart';

class NewsDao {
  static Future<NewsModel> fetch({num page = 1, num pageSize = 10}) async {
    var res = await HttpRequest.getInstance().request(
        'fm.SbyyNews.queryDailyNew',
        params: {'pageSize': pageSize, 'page': page});
    try {
      return NewsModel.fromJson(res['data']);
    } catch (e) {
      return new NewsModel();
    }
  }
}
