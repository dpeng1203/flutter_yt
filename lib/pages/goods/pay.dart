import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_app_yt/dao/goods_dao.dart';
import 'package:flutter_app_yt/dao/pay_dao.dart';
import 'package:flutter_app_yt/model/balance_models.dart';
import 'package:flutter_app_yt/model/goods_models.dart';
import 'package:flutter_app_yt/model/pay_coupon_model.dart';
import 'package:flutter_app_yt/pages/goods/payBloc.dart';
import 'package:flutter_app_yt/common/NumberFormat.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import '../../translations.dart';

class GoodsOrderPay extends StatelessWidget {
  final String goodsCode;

  GoodsOrderPay({this.goodsCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: TopBackIcon(),
          // 支付
          title: Text(Translations.of(context).text('title_goods-order-pay')),
          elevation: 1.0,
        ),
        body: FutureBuilder(
          future: GoodsDao.goodsGet(goodsCode),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: null,
              );
            }
            ModelGoods data = snapshot.data;
            return PayProvider(
              bloc: PayBloc(goods: snapshot.data, context: context),
              child: Container(
                // height: 300,
                child: Stack(
                  children: <Widget>[
                    ListView(
                      children: <Widget>[
                        PayGoodsName(),
                        PayChangeCount(),
                        if (data.packType != 4) PayChangeCoinType(),
                        if (data.packType == 4) PayChangeCoinType4(),
                        OtcExchange(),
                        if (data.packType == 4) PayAmountList(),
                        if (data.packType != 4) PayChangeCoupon(),
                        PayAgreement(),
                        PayAssignAssts(),
                        SizedBox(
                          height: 70,
                        )
                      ],
                    ),
                    if (data.packType == 4) PayBtnTow(),
                    if (data.packType != 4) PayBtn(),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

/// 算力包信息
class PayGoodsName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PayBloc _payBloc = PayProvider.of(context).bloc;
    return Container(
      height: 50,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
          color: Color(0xff232836),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // 算力名称
          Text(Translations.of(context).text('goods_o_computed_name')),
          Text('${_payBloc.goods.goodsName}')
        ],
      ),
    );
  }
}

/// 支付数量控制
class PayChangeCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PayBloc _paybloc = PayProvider.of(context).bloc;
    ModelGoods goods = _paybloc.goods;

    return Container(
      decoration: BoxDecoration(
          color: Color(0xff232836),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // 购买分数
              Text(Translations.of(context).text('goods_o_stock')),
              Container(
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _paybloc.handleChangeCount.add('minus');
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 8, 15, 7),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xff444444), width: 1.0)),
                        child: Text(
                          '-',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                  width: 1.0,
                                  color: Color(0xff444444),
                                ),
                                bottom: BorderSide(
                                  width: 1.0,
                                  color: Color(0xff444444),
                                ))),
                        child: StreamBuilder(
                          initialData: 1,
                          stream: _paybloc.count,
                          builder: (context, snapshot) {
                            return Text('${snapshot.data}');
                          },
                        )),
                    GestureDetector(
                      onTap: () {
                        _paybloc.handleChangeCount.add('add');
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xff444444), width: 1.0)),
                        child: Text('+'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // 应付总额
              Text(
                Translations.of(context).text('goods_o_total_amount'),
                style: TextStyle(height: 3),
              ),
              StreamBuilder(
                initialData: _paybloc.goods.price,
                stream: _paybloc.totalPrice,
                builder: (context, snapshot) {
                  return Text(
                    '${NumberFormat.formatDoubel(snapshot.data)} ${goods.isSuper == 1 ? 'FM' : 'USDT'}',
                    style: TextStyle(
                        color: Color(0xffFFA61A), height: 3, fontSize: 16),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// 支付类型切换
class PayChangeCoinType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PayBloc _paybloc = PayProvider.of(context).bloc;
    return FutureBuilder(
      future: PayDao.getUserBanlance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: null,
          );
        }
        _paybloc.handleChangeBalance.add(snapshot.data);

        return StreamBuilder(
          stream: _paybloc.cointypelist,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: null,
              );
            }

            PayRadioList _radiolist = snapshot.data;
            return Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                    color: Color(0xff232836),
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                child: Column(
                    children: _radiolist.list.map((e) {
                  return Container(
                    child: Row(
                      children: <Widget>[
                        Radio(
                          activeColor: Color(0xffffa61a),
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          onChanged: (value) {
                            _paybloc.handlerRadioClick.add(value);
                          },
                          value: '${e.value}',
                          groupValue: _radiolist.value,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${e.value.toUpperCase()} ${Translations.of(context).text('goods_o_pay')}',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 3),
                              child: Text(
                                // 可用余额
                                '(${Translations.of(context).text('goods_o_after')}：${e.balance} )',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xff666666)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }).toList()));
          },
        );
      },
    );
  }
}

class PayChangeCoinType4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PayBloc _paybloc = PayProvider.of(context).bloc;
    return FutureBuilder(
      future: PayDao.getUserBanlance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: null,
          );
        }
        _paybloc.handleChangeBalance.add(snapshot.data);

        return StreamBuilder(
          stream: _paybloc.cointypelist,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: null,
              );
            }

            PayRadioList _radiolist = snapshot.data;
            return Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                    color: Color(0xff232836),
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                child: Column(
                    children: _radiolist.list.map((e) {
                  return Container(
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          activeColor: Color(0xffcccccc),
                          onChanged: (bool value) {},
                          value: true,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${e.value.toUpperCase()} ${Translations.of(context).text('goods_o_pay')}',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 3),
                              child: Text(
                                // 可用余额
                                '(${Translations.of(context).text('goods_o_after')}：${e.balance} )',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xff666666)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }).toList()));
          },
        );
      },
    );
  }
}

// 优惠券部分
class PayChangeCoupon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PayBloc _payBloc = PayProvider.of(context).bloc;
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
          color: Color(0xff232836),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      child: StreamBuilder(
        stream: _payBloc.payAmount,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          ModelPayCoupon _data = snapshot.data;
          if (_data == null) {
            return SizedBox();
          }
          return Column(
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // 优惠方案
                    Text(
                      Translations.of(context).text('goods_c_scheme'),
                      style: TextStyle(fontSize: 14),
                    ),
                    _data.availableCouponNum == 0
                        // 暂无可用
                        ? Text(
                            Translations.of(context).text('goods_c_no_use'),
                            style: TextStyle(
                                fontSize: 14, color: Color(0xffaaaaaa)),
                          )
                        : GestureDetector(
                            onTap: () {
                              _payBloc.openSheetBottomModal(context);
                            },
                            child: Row(
                              children: <Widget>[
                                // 可用

                                Text(
                                  '${_data.availableCouponNum} ${Translations.of(context).text('goods_c_coupon_unit')}${Translations.of(context).text('goods_o_usedNum')}',
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xffFFA61A)),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                )
                              ],
                            ),
                          )
                  ],
                ),
              ),
              _data.selectedCoupon.length == 0
                  ? SizedBox()
                  : Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 1.0, color: Color(0xff1C202C)))),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // 已选  张，共优惠

                          Text(
                            '${Translations.of(context).text('goods_c_selected')} ${_data.selectedCoupon.length}${Translations.of(context).text('goods_c_preferential')}',
                            style: TextStyle(
                              color: Color(0xffaaaaaa),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                              '- ${_data.selectedCouponSumValue} (${_payBloc.radiolist.value != null ? _payBloc.radiolist.value.toUpperCase() : ''})',
                              style: TextStyle(
                                color: Color(0xffFFA61A),
                                fontSize: 14,
                              ))
                        ],
                      ),
                    )
            ],
          );
        },
      ),
    );
  }
}

class PayAmountList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PayBloc _payBloc = PayProvider.of(context).bloc;
    return StreamBuilder(
        initialData: ModelPayCoupon(),
        stream: _payBloc.payAmount,
        builder: (context, snapshot) {
          ModelPayCoupon _data = snapshot.data;

          if (_data.payAmount == null) {
            return SizedBox();
          }
          if (_data.selectedCouponSumValue == '0' &&
              _data.selectedCouponSumValue2 == '0') {
            // 无优惠金额
            return Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                  color: Color(0xff232836),
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          // color: Colors.red,
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: Color(0xff373737)))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            // 支付方案
                            Translations.of(context)
                                .text('goods_o_order_pay_type'),
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'FM+USDT',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            // 需支付
                            '${Translations.of(context).text('goods_o_order_pay_can_pays')}${_data.payType2.toUpperCase()}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${_data.payType2.toUpperCase() == 'FM' ? '≈' : ''} ${_data.payAmount2} (${_data.payType2.toUpperCase()})',
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).accentColor),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            // 需支付
                            '${Translations.of(context).text('goods_o_order_pay_can_pays')}${_data.payType.toUpperCase()}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${_data.payType.toUpperCase() == 'FM' ? '≈' : ''} ${_data.payAmount} (${_data.payType.toUpperCase()})',
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).accentColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // 有优惠金额
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                      color: Color(0xff232836),
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                              // color: Colors.red,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Color(0xff373737)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                // 支付方案
                                Translations.of(context)
                                    .text('goods_o_order_pay_type'),
                                style: TextStyle(fontSize: 14),
                              ),
                              // _data.selectedCouponSumValue == '0' && _data.selectedCouponSumValue2 == '0'
                              Text(
                                'FM+USDT',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                // 需支付
                                '${Translations.of(context).text('goods_o_order_pay_can_pays')}${_data.payType2.toUpperCase()}',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '${_data.payType2.toUpperCase() == 'FM' ? '≈' : ''} ${_data.originalAmount2} (${_data.payType2.toUpperCase()})',
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xffaaaaaa)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                // 需支付
                                '${Translations.of(context).text('goods_o_order_pay_can_pays')}${_data.payType.toUpperCase()}',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '${_data.payType.toUpperCase() == 'FM' ? '≈' : ''} ${_data.originalAmount} (${_data.payType.toUpperCase()})',
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xffaaaaaa)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                      color: Color(0xff232836),
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                              // color: Colors.red,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Color(0xff373737)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                // 平台优惠
                                Translations.of(context)
                                    .text('goods_o_order_pay_reduced'),
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '${_data.selectedCouponSumValue != '0' ? '- ${_data.selectedCouponSumValue} (${_data.payType.toUpperCase()})' : ''} ${_data.selectedCouponSumValue2 != '0' ? '- ${_data.selectedCouponSumValue2} (${_data.payType2.toUpperCase()})' : ''}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                // 实际FM支付
                                '${Translations.of(context).text('goods_o_order_pay_actual')}${_data.payType2.toUpperCase()}${Translations.of(context).text('goods_o_order_pay_actual_pay')}',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '${_data.payType2.toUpperCase() == 'FM' ? '≈' : ''} ${_data.payAmount2} (${_data.payType2.toUpperCase()})',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).accentColor),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                // 实际USDT支付
                                '${Translations.of(context).text('goods_o_order_pay_actual')}${_data.payType.toUpperCase()}${Translations.of(context).text('goods_o_order_pay_actual_pay')}',

                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '${_data.payType.toUpperCase() == 'FM' ? '≈' : ''} ${_data.payAmount} (${_data.payType.toUpperCase()})',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).accentColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        });
  }
}

// 协议控制

class PayAgreement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PayBloc _payBloc = PayProvider.of(context).bloc;
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Row(
        children: <Widget>[
          StreamBuilder(
            stream: _payBloc.handleAgreement,
            initialData: true,
            builder: (context, snapshot) {
              return Checkbox(
                activeColor: Color(0xffffa61a),
                onChanged: (bool value) {
                  // print("bo $value");
                  _payBloc.handleChangeArgement.add(value);
                },
                value: snapshot.data,
              );
            },
          ),
          // 我已阅读并同意

          Text(Translations.of(context).text('goods_agreement_argee')),
          // 《平台服务协议》
          GestureDetector(
            onTap: () {
              _payBloc.showAgreement(context);
            },
            child: Text(
              '《${Translations.of(context).text('goods_agreement_title')}》',
              style: TextStyle(color: Color(0xffffa61a)),
            ),
          ),
        ],
      ),
    );
  }
}

class PayAssignAssts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PayBloc _payBloc = PayProvider.of(context).bloc;
    return StreamBuilder(
      stream: _payBloc.cointypelist,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container(child: null);
        }
        AssignAssets _assets = _payBloc.assignAssts;
        if (_assets != null &&
            _assets.state == "0" &&
            _payBloc.radiolist.value.toLowerCase() == 'usdt') {
          return Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      size: 18.0,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    // 可增加配资 可用

                    Text(
                      '${Translations.of(context).text('goods_o_addAmount')} ${_assets.assignAmount} USDT,${Translations.of(context).text('goods_o_usedNum')}${double.parse(_payBloc.totalAmountUsdt) + double.parse(_assets.assignAmount)} USDT。',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 22),
                  // 配资部分根据账户当前余额动态调整，但仅限于第一次租赁算力包时使用。
                  child: Text(
                    Translations.of(context).text('goods_o_assignInfo'),
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          );
        }
        return Container(child: null);
      },
    );
  }
}

class PayBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PayBloc _payBloc = PayProvider.of(context).bloc;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 60,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        color: Color(0xff232836),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (_payBloc.goods.packType != 4)
              Row(
                children: <Widget>[
                  // 共计
                  Text('${Translations.of(context).text('goods_o_total')}：'),
                  StreamBuilder(
                    initialData: ModelPayCoupon(),
                    stream: _payBloc.payAmount,
                    builder: (context, snapshot) {
                      ModelPayCoupon _data = snapshot.data;

                      if (_data.payAmount == null) {
                        return SizedBox();
                      }

                      return Text(
                        '${_payBloc.radiolist.value != null && _payBloc.radiolist.value.toUpperCase() == 'USDT' || _payBloc.goods.isSuper == 1 ? '' : '≈'} ${_data.payAmount} ${_payBloc.radiolist.value != null ? _payBloc.radiolist.value.toUpperCase() : ''}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffFFA61A),
                        ),
                      );
                    },
                  ),
                ],
              ),
            if (_payBloc.goods.packType == 4) SizedBox(),
            StreamBuilder(
              initialData: true,
              stream: _payBloc.handleAgreement,
              builder: (context, snapshot) {
                return GestureDetector(
                  child: Container(
                    height: 60,
                    width: 120,
                    color:
                        snapshot.data ? Color(0xffFFA61A) : Color(0xffcccccc),
                    alignment: Alignment.center,
                    // 确认支付
                    child: Text(
                      Translations.of(context).text('goods_o_payBtn'),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  onTap: () async {
                    if (!snapshot.data) {
                      EasyLoading.showToast(Translations.of(context)
                          .text('goods_agreement_toast_check'));
                      return;
                    }
                    // openAlertDialog(context);
                    _payBloc.startPay(context);
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class PayBtnTow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PayBloc _payBloc = PayProvider.of(context).bloc;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20,
      child: Container(
          height: 50,
          padding: EdgeInsets.fromLTRB(62, 0, 62, 0),
          // color: Color(0xff232836),
          child: StreamBuilder(
            initialData: true,
            stream: _payBloc.handleAgreement,
            builder: (context, snapshot) {
              bool _ischeck = snapshot.data;
              return GestureDetector(
                child: Container(
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _ischeck
                            ? <Color>[Color(0xffEDB94D), Color(0xffD2722E)]
                            : <Color>[Color(0xffcccccc), Color(0xffcccccc)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  alignment: Alignment.center,
                  // 确认支付
                  child: Text(
                    Translations.of(context).text('goods_o_payBtn'),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                onTap: () async {
                  if (!snapshot.data) {
                    EasyLoading.showToast(Translations.of(context)
                        .text('goods_agreement_toast_check'));
                    return;
                  }
                  // openAlertDialog(context);
                  _payBloc.startPay(context);
                },
              );
            },
          )),
    );
  }
}

class OtcExchange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // PayBloc _payBloc = PayProvider.of(context).bloc;
    return SizedBox();
    // return _payBloc.goods.isSuper != 1
    //     ? Container(
    //         padding: EdgeInsets.fromLTRB(0, 3, 10, 3),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: <Widget>[
    //             // 支付币种余额不足

    //             Text(
    //                 '${Translations.of(context).text('goods_o_payType_insufficient_balance')}？',
    //                 style: TextStyle(
    //                   fontSize: 12,
    //                 )),
    //             GestureDetector(
    //               onTap: () {},
    //               // 点击兑换
    //               child: Text(
    //                 '${Translations.of(context).text('goods_o_payType_exchange')}?',
    //                 style: TextStyle(fontSize: 12, color: Color(0xffFFA61A)),
    //               ),
    //             )
    //           ],
    //         ))
    //     : SizedBox();
  }
}
