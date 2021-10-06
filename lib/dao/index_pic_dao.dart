import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/index_pic_model.dart';

class IndexPicDao {
  static Future fetch(int id) async {
    Map<String, dynamic> params = {
      'id': id
    };
    var res = await HttpRequest.getInstance()
        .request('fm.appIndexPic.selectDetailAndTitleById', params: params);
    return IndexPicModel.fromJson(res['data']);
  }
}