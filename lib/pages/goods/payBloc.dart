import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:flutter_app_yt/common/tripleDes.dart';
import 'package:flutter_app_yt/dao/pay_dao.dart';

import 'package:flutter_app_yt/model/balance_models.dart';
import 'package:flutter_app_yt/model/coin_type_model.dart';
import 'package:flutter_app_yt/model/goods_models.dart';
import 'package:flutter_app_yt/model/pay_coupon_model.dart';
import 'package:flutter_app_yt/model/util_model.dart';
import 'package:flutter_app_yt/pages/goods/couponmodal.dart';

import '../../translations.dart';

class PayProvider extends InheritedWidget {
  final Widget child;
  final PayBloc bloc;

  PayProvider({
    this.child,
    this.bloc,
  }) : super(child: child);

  // static PayProvider of(BuildContext context) => context.inheritFromWidgetOfExactType(PayProvider);
  static PayProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PayProvider>();

  @override
  bool updateShouldNotify(PayProvider oldWidget) {
    return true;
  }
}

class PayRadioList {
  String value = '';
  List<CoinTypes> list = [];

  PayRadioList({this.value, this.list});
}

class PayBloc {
  final BuildContext context;
  ModelGoods goods; // 商品信息
  List<ModelBalance> balancelist = []; //服务端用余额数据
  List<CoinTypes> listCointype = [];
  PayRadioList radiolist = new PayRadioList(); // 选择框数据
  String totalAmountUsdt; // 暂时未用到
  int _count = 1; // 默认数量
  ModelPayCoupon payViewAmount; // 支付信息
  /// 协议
  bool agreement = true;

  /// 配资显示
  AssignAssets assignAssts;
  final _hanlerChangeCountController = StreamController<String>(); // 改变数量的数据流
  StreamSink<String> get handleChangeCount =>
      _hanlerChangeCountController.sink; // 可获取的值

  final _countController = StreamController<int>.broadcast(); // 定义购买份数  数据流
  Stream<int> get count => _countController.stream;

  // totalPrice 监听事件
  final _totalPriceController = StreamController<double>.broadcast();

  Stream<double> get totalPrice => _totalPriceController.stream;

  // 获取个人账户余额监听
  final _banlanceChangeController = StreamController<List<ModelBalance>>();

  StreamSink<List<ModelBalance>> get handleChangeBalance =>
      _banlanceChangeController;

  // 监听CoinTypelist变化
  final _cointypeChangeController = StreamController<PayRadioList>.broadcast();

  Stream<PayRadioList> get cointypelist => _cointypeChangeController.stream;

  // Radio 数据点击事件
  final _handlerRadioClick = StreamController<String>();

  StreamSink<String> get handlerRadioClick => _handlerRadioClick.sink;

  final _handlerchangePayAmount = StreamController<ModelPayCoupon>.broadcast();

  Stream<ModelPayCoupon> get payAmount => _handlerchangePayAmount.stream;

  final _handleListenAgreement = StreamController<bool>.broadcast(); // 数据流监听
  Stream<bool> get handleAgreement => _handleListenAgreement.stream;

  final _handleChangeArgement = StreamController<bool>();

  StreamSink<bool> get handleChangeArgement => _handleChangeArgement.sink;

  // 初始化
  PayBloc({this.goods, this.context}) {
    _hanlerChangeCountController.stream.listen(changeCount); // 监听数据变化
    _banlanceChangeController.stream.listen(changeBanance);
    _handlerRadioClick.stream.listen(changeRadio);
    _handleChangeArgement.stream.listen((event) {
      agreement = event;
      _handleListenAgreement.add(event);
    });
    if (goods.isSuper == 1) {
      goods.coinType = 'FM';
      goods.coinName = "fm";
    }
    intoTotalPrice(1);
  }

// 购买数量变化
  void changeCount(String type) {
    if (type == 'add') {
      // 最大限制
      if (_count >= goods.stock) {
        return;
      }
      _count = _count + 1;
      _countController.add(_count);
    } else if (type == 'minus') {
      // 最小限制
      if (_count <= 1) {
        return;
      }
      _count = _count - 1;
      _countController.add(_count);
    }

    intoTotalPrice(_count);
    getShowAmountPrice(); // 重新计算价格
  }

  // 修改显示的支付 单位
  void intoTotalPrice(int count) {
    _totalPriceController.add(((goods.price * 10000) * _count) / 10000);
  }

  // 监听 获取Banlance 数据
  void changeBanance(List<ModelBalance> list) {
    if (list != null) {
      balancelist = list;
      formatViewShowPayCoinList(list);
    }
  }

  // 修改支付方式
  void changeRadio(String type) {
    radiolist.value = type;
    _cointypeChangeController.add(radiolist); // 更新视图
    getShowAmountPrice();
  }

  // 初始化支付列表
  void formatViewShowPayCoinList(List<ModelBalance> list) {
    List<CoinTypes> _list = [];

    for (var i = 0; i < cointypelistmodel.length; i++) {
      for (var j = 0; j < list.length; j++) {
        if (cointypelistmodel[i].value == list[j].coinType) {
          cointypelistmodel[i].balance = double.parse(list[j].amount);

          if (list[j].coinType == 'usdt') {
            totalAmountUsdt = list[j].amount; // 显示用户usdt总额
            assignAssts = list[j].assignAssets; // 配资数据
          }
          if (goods.packType != 4) {
            if (cointypelistmodel[i].includeCoinTypes.indexOf(goods.coinName) >
                -1) {
              _list.add(cointypelistmodel[i]);
            }
          } else {
            String ctname = cointypelistmodel[i].value;
            if (['usdt', 'fm'].indexOf(ctname) > -1) {
              _list.add(cointypelistmodel[i]);
            }
          }
        }
      }
    }

    if (_list.length > 0) radiolist.value = _list[0].value;
    radiolist.list = _list;
    _cointypeChangeController.add(radiolist); // 更新视图
    getShowAmountPrice();
  }

  // 显示支付总额
  void getShowAmountPrice() async {
    payViewAmount = await PayDao.getPayAmount(
        goodsCode: goods.goodsCode,
        payType: radiolist.value,
        isUseCoupon: true,
        count: _count);
    _handlerchangePayAmount.add(payViewAmount);
  }

  void openSheetBottomModal(context) async {
    ModelDialogs<ModelPayCoupon> _dialog =
        await CononModal.openModalBottomSheet(context,
            goodsCode: goods.goodsCode,
            number: _count,
            payType: radiolist.value,
            selected: payViewAmount);

    if (_dialog.type != 'ok') {
      return;
    }

    payViewAmount = _dialog.message;
    _handlerchangePayAmount.add(_dialog.message);
    // print("_dialog");
  }

  /// 开始支付
  void startPay(context) async {
    /// 检测服务协议
    // / 请同意服务协议
    if (!agreement) {
      EasyLoading.showToast(
          Translations.of(context).text('goods_agreement_toast_check'));
      return;
    }

    String isUseAssign = "0"; // 是否使用配资
    //// 配资校验
    if (assignAssts != null &&
        assignAssts.state == "0" &&
        assignAssts.assignAmount != "0" &&
        radiolist.value.toLowerCase() == 'usdt') {
      isUseAssign = "1";
      ModelAssignCheck _assigncheck = await PayDao.getAssignCheck(
          goodsCode: goods.goodsCode, count: _count);

      Widget showwidget() {
        return Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              // 使用余额

              Text(
                '${Translations.of(context).text('goods_o_useAfter')}：${_assigncheck.useAmount} USDT',
                style: TextStyle(fontSize: 14, color: Color(0xffFFC11C)),
              ),
              SizedBox(
                height: 5,
              ),
              // 使用配资

              Text(
                  '${Translations.of(context).text('goods_o_useAssign')}：${_assigncheck.useAssignAmount} USDT',
                  style: TextStyle(fontSize: 14, color: Color(0xffFFC11C)))
            ],
          ),
        );
      }

// 确认支付
      ModelDialogs<String> _asstsdailog = await MyDialog.passwordDialog(context,
          ispwd: false,
          showWdiget: showwidget(),
          confirmtxt: Translations.of(context).text('goods_o_payBtn'));
      if (_asstsdailog.type != 'ok') return;
    }

    /// 检测用户名交易密码
    bool isTransactionPwd = await PayDao.checkUserIsHaveTransactionPwd();
    if (!isTransactionPwd) {
      EasyLoading.showToast(
          Translations.of(context).text('assets_out_ruleredit'),
          duration: Duration(seconds: 1));

      // 请先修改交易密码
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamed(context, '/my-security-modify-password',
            arguments: 2);
      });
      return;
    }
    // ModelDialog _dailog = await MyDialog.openAlertDialog(context);
    // 请输入交易密码
    ModelDialogs<String> _dailog = await MyDialog.passwordDialog(context,
        title: Translations.of(context).text('assets_out_rulerIncode'));
    if (_dailog.type != 'ok') return;

    bool payresult = await PayDao.placeAnOrder(
        goodsCode: goods.goodsCode,
        goodsName: goods.goodsName,
        payType: radiolist.value,
        number: _count,
        useAssign: isUseAssign,
        selectedCoupon: payViewAmount.selectedCoupon.map((e) => e.id).toList(),
        pwd: TripleDesUtil.generateDes(_dailog.message));

    if (payresult) {
      // 支付成功
      Navigator.pushNamed(context, '/paysuccess',
          arguments: Translations.of(context).text('goods_o_order_paid'));
    }
  }

  void showAgreement(context) async {
    double _height = MediaQuery.of(context).size.height * 0.6;
    double _width = MediaQuery.of(context).size.width * 0.85;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.white,
          content: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              height: _height,
              width: _width,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    // 平台服务协议

                    child: Text(
                        Translations.of(context).text('goods_agreement_title'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ),
                  Container(
                    height: _height - 100,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Color(0xffF6F6F6))),
                    child: CustomScrollView(
                      shrinkWrap: true,
                      slivers: <Widget>[
                        new SliverPadding(
                          padding: EdgeInsets.all(10),
                          sliver: new SliverList(
                              delegate: new SliverChildListDelegate(<Widget>[
                            Text(
                              Translations.of(context)
                                  .text('goods_agreement_html'),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            )
                          ])),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4))),
                      alignment: Alignment.center,
                      // 确定
                      child: Text(
                          Translations.of(context)
                              .text('goods_agreement_affirm'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          )),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  /// 验证是否有支付密码
  Future<bool> checkPwd() async {
    return true;
  }

  // 页面注销执行
  void dispose() {
    _hanlerChangeCountController.close();
    _countController.close();
    _totalPriceController.close();
    _banlanceChangeController.close();
    _cointypeChangeController.close();
    _handlerRadioClick.close();
    _handlerchangePayAmount.close();
    _handleListenAgreement.close();
    _handleChangeArgement.close();
  }
}
