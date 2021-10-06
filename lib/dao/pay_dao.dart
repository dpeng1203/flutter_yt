import 'package:flutter_app_yt/common/daoUtils.dart';
import 'package:flutter_app_yt/model/balance_models.dart';
import 'package:flutter_app_yt/model/pay_coupon_model.dart';

class PayDao {
// 获取账户余额
  static Future<List<ModelBalance>> getUserBanlance() async {
    Map<String, dynamic> parms = {};
    var res = await HttpRequest.getInstance()
        .request('fm.memberBalance.getNew', params: parms);
    List<ModelBalance> obj;
    try {
      List maps = res['data'];

      obj = maps.map((item) {
        return ModelBalance.fromJson(item);
      }).toList();
    } catch (e) {
      print(e);
    }
    return obj;
  }

  /// 获取支付金额
  static Future<ModelPayCoupon> getPayAmount(
      {String goodsCode, int count, String payType, bool isUseCoupon}) async {
    Map<String, dynamic> parms = {
      "goodsCode": goodsCode,
      "num": count,
      "payType": payType,
      "isUseCoupon": isUseCoupon
    };
    var res = await HttpRequest.getInstance()
        .request('fm.coupon.changePayInfo', params: parms);
    try {
      ModelPayCoupon obj;
      obj = ModelPayCoupon.fromJson(res['data']);
      return obj;
    } catch (e) {
      print(e);
      return new ModelPayCoupon();
    }
  }

  /// 获取支付金额
  static Future<ModelAssignCheck> getAssignCheck(
      {String goodsCode, int count}) async {
    Map<String, dynamic> parms = {
      "goodsCode": goodsCode,
      "num": count,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.assign.check', params: parms);
    try {
      ModelAssignCheck obj;
      obj = ModelAssignCheck.fromJson(res['data']);
      return obj;
    } catch (e) {
      print(e);
      return ModelAssignCheck();
    }
  }

  /// 确认优惠券
  static Future<ModelPayCoupon> confirmSelectedCoupon(
      {String goodsCode,
      int count,
      String payType,
      List<int> selectedCoupon}) async {
    Map<String, dynamic> parms = {
      "goodsCode": goodsCode,
      "num": count,
      "payType": payType,
      "selectedCoupon": selectedCoupon
    };
    var res = await HttpRequest.getInstance()
        .request('fm.coupon.confirmSelectedCoupon', params: parms);
    try {
      ModelPayCoupon obj;
      obj = ModelPayCoupon.fromJson(res['data']);
      return obj;
    } catch (e) {
      print(e);
      return new ModelPayCoupon();
    }
  }

  /// 下单
  /// goodsCode: this.goodsCode,
  /// goodsName: this.goods.goodsName,
  /// num: this.number,
  /// payType: this.payTypeObj.value,
  /// useAssign: '0', // 0 不使用配资 1 使用配资
  /// selectedCoupon: this.selectedCoupon

  static Future<bool> placeAnOrder(
      {String goodsCode,
      String goodsName,
      int number,
      String payType,
      String useAssign = '0',
      String pwd,
      List<int> selectedCoupon}) async {
    Map<String, dynamic> parms = {
      "goodsCode": goodsCode,
      "goodsName": goodsName,
      "num": number,
      "payType": payType,
      "useAssign": useAssign,
      "confirmPassword": pwd,
      "selectedCoupon": selectedCoupon
    };
    var res =
        await HttpRequest.getInstance().request('fm.order.add', params: parms);
    try {
      bool result = res['data'] as bool;
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 检测用户是否存在交易密码
  static Future<bool> checkUserIsHaveTransactionPwd() async {
    Map<String, dynamic> parms = {};
    var res = await HttpRequest.getInstance()
        .request('fm.order.checkConfirmPasswordIsNull', params: parms);
    try {
      return !(res['data'] as bool);
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// 获取劵包列表
  static Future<ModelSelectCoupon> getSelectCoupon(
      {String goodsCode,
      int number,
      String payType,
      List<int> selected,
      int page,
      int pageSize}) async {
    Map<String, dynamic> parms = {
      "goodsCode": goodsCode,
      "num": number,
      "payType": payType,
      "selectedCoupon": selected,
      "page": page,
      "pageSize": pageSize
    };
    var res = await HttpRequest.getInstance()
        .request('fm.coupon.selectCoupon', params: parms);
    try {
      ModelSelectCoupon _data = ModelSelectCoupon.fromJson(res['data']);
      return _data;
    } catch (e) {
      return ModelSelectCoupon();
    }
  }

  /// 赎回
  static Future<bool> userRedeemGoods({
    String confirmPassword,
    String orderCode,
  }) async {
    Map<String, dynamic> parms = {
      "orderCode": orderCode,
      "confirmPassword": confirmPassword,
    };
    var res = await HttpRequest.getInstance()
        .request('fm.order.ransom', params: parms);
    try {
      // ModelSelectCoupon _data = ModelSelectCoupon.fromJson(res['data']);
      return (res['data'] as bool);
    } catch (e) {
      return false;
    }
  }

  /// 获取劵包分类获取
  static Future<CouponData> getQueryCouponType(
      {int state,
      int type,
      int page,
      int pageSize,
      bool needload = true}) async {
    Map<String, dynamic> parms = {
      "state": state,
      "type": type,
      "page": page,
      "pageSize": pageSize
    };
    CouponData obj = new CouponData();
    var res = await HttpRequest.getInstance().request(
        'fm.coupon.queryCouponType',
        params: parms,
        isNeedLoading: needload);
    try {
      obj = CouponData.fromJson(res['data']);
      return obj;
    } catch (e) {
      return obj;
    }
  }

  /// 黄宝兑换
  static Future<bool> couponUseTopaz({
    int id,
  }) async {
    Map<String, dynamic> parms = {
      "id": id,
    };
    // CouponData obj = new CouponData();
    var res = await HttpRequest.getInstance()
        .request('fm.coupon.useTopaz', params: parms);
    try {
      // var abc = CouponData.fromJson(res['data']);
      return (res['data'] as bool);
    } catch (e) {
      return false;
    }
  }

  /// 兑换码兑换
  static Future<bool> couponExchangeCouponCode({
    String code,
  }) async {
    Map<String, dynamic> parms = {
      "code": code,
    };
    // CouponData obj = new CouponData();
    var res = await HttpRequest.getInstance()
        .request('fm.couponCode.exchangeCouponCode', params: parms);
    try {
      // var abc = CouponData.fromJson(res['data']);
      if (res['data'] == null) return false;
      return (res['data'] as bool);
    } catch (e) {
      return false;
    }
  }
}
