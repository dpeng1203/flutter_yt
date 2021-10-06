import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/goods_model.dart';
import 'package:flutter_app_yt/model/goods_models.dart';

class GoodsDao {
  static Future fetch(coinName, packType, {bool isNeedLoading = true}) async {
    Map<String, dynamic> parms = {
      "state": 1,
      "page": 1,
      "goodsType": 'rent',
      "coinName": coinName,
      "pageSize": 1000,
      "packType": packType
    };
    var res = await HttpRequest.getInstance().request(
        'fm.goods.queryByParamAndPage',
        params: parms,
        isNeedLoading: isNeedLoading);
    return GoodsModel.fromJson(res['data']);
  }

  static Future<ModelGoods> goodsGet(String goodsCode) async {
    Map<String, dynamic> parms = {
      "goodsCode": goodsCode,
    };
    var res =
        await HttpRequest.getInstance().request('fm.goods.get', params: parms);
    ModelGoods obj;
    try {
      obj = ModelGoods.fromJson(res['data']);
    } catch (e) {
      print(e);
    }
    return obj;
  }

  static Future<List<ModelUpGrade>> getLevelUpSelectList(
      String orderCode) async {
    Map<String, dynamic> parms = {
      "orderCode": orderCode,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.goods.levelUpSelectList', params: parms);
    List<ModelUpGrade> obj = new List<ModelUpGrade>();
    try {
      res['data'].forEach((v) {
        obj.add(new ModelUpGrade.fromJson(v));
      });
      return obj;
    } catch (e) {
      return null;
    }
  }

  /// 算力包升级
  static Future<bool> goodsUpGrade(
      String orderCode, String goodsCode, String payPassword) async {
    Map<String, dynamic> parms = {
      "orderCode": orderCode,
      "goodsCode": goodsCode,
      "payPassword": payPassword
    };
    var res = await HttpRequest.getInstance()
        .request('fm.order.upgrade', params: parms);
    try {
      bool result = res['data'] as bool;
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 算力包升级2
  static Future<bool> goodsUpGradeTwo(
      String orderCode, String goodsCode, String payPassword, int count) async {
    Map<String, dynamic> parms = {
      "orderCode": orderCode,
      "goodsCode": goodsCode,
      "payPassword": payPassword,
      "num": count,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.order.upgrade', params: parms);
    try {
      bool result = res['data'] as bool;
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 算力包升级 获取支付信息
  static Future<GoodsUpGradeAmount> goodsUpGradeGetPrice(
      String orderCode, String goodsCode, num count) async {
    Map<String, dynamic> parms = {
      "orderCode": orderCode,
      "goodsCode": goodsCode,
      "num": count
    };
    var res = await HttpRequest.getInstance()
        .request('fm.goods.levelUpRemainPayAmount', params: parms);
    GoodsUpGradeAmount obj = new GoodsUpGradeAmount();
    // try {
    //   bool result = res['data'] as bool;
    //   return result ?? false;
    // } catch (e) {
    //   return false;
    // }
    try {
      obj = GoodsUpGradeAmount.fromJson(res['data']);
    } catch (e) {
      print(e);
    }
    return obj;
  }
}
