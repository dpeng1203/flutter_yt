import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:flutter_app_yt/common/tripleDes.dart';
import 'package:flutter_app_yt/dao/goods_dao.dart';
import 'package:flutter_app_yt/model/goods_models.dart';
import 'package:flutter_app_yt/model/util_model.dart';
import 'package:flutter_app_yt/common/NumberFormat.dart';
import 'package:flutter_app_yt/widget/my_assetes_images.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import '../../translations.dart';

class GoodsDetail extends StatefulWidget {
  final GoodsDetailsParams params;

  GoodsDetail({this.params});

  @override
  _GoodsDetailState createState() => _GoodsDetailState();
}

class _GoodsDetailState extends State<GoodsDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1C212E),
        appBar: AppBar(
          centerTitle: true,
          leading: TopBackIcon(),
          // 算力包详情
          title: Text(Translations.of(context).text('title_goods-detail')),
          elevation: 0.0,
        ),
        body: GoodsDetailProvider(
          bloc: GoodsBloc(params: widget.params, context: context),
          child: GoodsListView(),
        ));
  }
}

class GoodsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoodsBloc _goodsBloc = GoodsDetailProvider.of(context).bloc;

    return Stack(
      children: <Widget>[
        StreamBuilder(
            stream: _goodsBloc.goodsItem,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: Text(''),
                );
              }
              ModelGoodsView goodsview = snapshot.data;
              return ListView(
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  if (goodsview.uplist != null) GoodsSelectUpLevel(),
                  GoodsTopMess(goodsview.goods), // 顶部布局
                  GoodsCenterMess(goodsview.goods), // 中间位置布局
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor),
                    child: null,
                    height: 10,
                  ),
                  GoodsBottomMess(goods: goodsview.goods, context: context),
                ],
              );
            }),
        StreamBuilder(
            stream: _goodsBloc.goodsItem,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: Text(''),
                );
              }
              // ModelGoodsView goodsview = snapshot.data;

              if (_goodsBloc.params.orderCode != null) {
                return Positioned(
                  bottom: 0,
                  height: 130,
                  left: 0,
                  right: 0,
                  // child: Text('asfdadf'),
                  child: GoodsUpGradePay(),
                );
              } else {
                return Positioned(
                  bottom: 50,
                  height: 50,
                  left: 0,
                  right: 0,
                  // child: Text('asfdadf'),
                  child: GoodsGotoPay(),
                );
              }
            }),
        StreamBuilder(
          initialData: false,
          stream: _goodsBloc.goodsSelectUpGrade,
          builder: (context, snapshot) {
            ModelGoodsView goodsview = _goodsBloc.goodsView;
            if (snapshot.data) {
              return Positioned(
                bottom: 0,
                left: 0,
                top: 60,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Color(0xff232836),
                        height: 40,
                        alignment: Alignment.center,
                        // 请先选择你想升级的额度
                        child: Text(
                            Translations.of(context)
                                .text('goods_select_upgrade_list'),
                            style: TextStyle(
                                fontSize: 15, color: Color(0xffaaaaaa))),
                      ),
                      if (goodsview.uplist != null)
                        Column(
                          children: goodsview.uplist
                              .asMap()
                              .keys
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      // print("$e");
                                      _goodsBloc.checkUpGradeList(e);
                                    },
                                    child: Container(
                                      height: 40,
                                      color: Color(0xff232836),
                                      alignment: Alignment.center,
                                      child: Text(
                                          '${NumberFormat.formatDoubel(goodsview.uplist[e].price)} USDT',
                                          style: TextStyle(
                                            fontSize: 15,
                                          )),
                                    ),
                                  ))
                              .toList(),
                        )
                    ],
                  ),
                ),
              );
            } else {
              return SizedBox();
            }
          },
        )
      ],
    );
  }
}

class GoodsSelectUpLevel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoodsBloc _goodsBloc = GoodsDetailProvider.of(context).bloc;
    return GestureDetector(
      onTap: () {
        _goodsBloc.showUpGradeList(true);
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Color(0xff232836),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${_goodsBloc.tip}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Image.asset(
              'assets/images/icon_upgradearrow.png',
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}

// 中间部分组件
class GoodsCenterMess extends StatelessWidget {
  final ModelGoods goods;

  GoodsCenterMess(this.goods);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      color: Color(0xff1C212E),
      child: Column(
        children: <Widget>[
          goods.coinName == "btc" &&
                  goods.isSuper != 1 &&
                  goods.btcDayIncome != 0 &&
                  goods.btcDayIncome != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // 理论收益
                    Text('BTC${Translations.of(context).text('goods_btc_sy')}'),
                    // 日
                    Text(
                      '${goods.btcDayIncome != 0 ? goods.btcDayIncome : '0'} BTC/${Translations.of(context).text('goods_dayunit')}',
                      style: TextStyle(color: Color(0xffaaaaaa), fontSize: 14),
                    ),
                  ],
                )
              : SizedBox(),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // 发币方式
              Text(Translations.of(context).text('goods_fbMonth')),
              // 每日结算，次日发放至本人账户
              Text(
                Translations.of(context).text('goods_fbInfo'),
                style: TextStyle(color: Color(0xffaaaaaa), fontSize: 14),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // 开挖时间
              Text(Translations.of(context).text('goods_kwTime')),
              // 即时开挖
              Text(Translations.of(context).text('goods_jsTime'),
                  style: TextStyle(color: Color(0xffaaaaaa), fontSize: 14)),
            ],
          )
        ],
      ),
    );
  }
}

// 顶部组件
class GoodsTopMess extends StatelessWidget {
  final ModelGoods item;

  GoodsTopMess(this.item);

  _builditem(BuildContext context, ModelGoods goods) {
    if (goods.packType == 4) {
      return Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (goods.unit != null && goods.unit != '')
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 单份算力
                  Text(Translations.of(context).text('goods_unit')),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${goods.unit}',
                    style: TextStyle(color: Color(0xffFFA61A), fontSize: 16),
                  )
                ],
              ),
            ),
          if (goods.unit != null && goods.unit != '')
            Container(
              width: 1,
              height: 50,
              color: Color(0xff444C61),
            ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 月化收益约
                Text(
                    '${goods.coinType.toUpperCase()} ${Translations.of(context).text('goods_rate')}'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${goods.rentIncomeRate - goods.fmRewardNum}%',
                  style: TextStyle(color: Color(0xffFFA61A), fontSize: 16),
                )
              ],
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Color(0xff444C61),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 'FM日产' : 'FM月化收益'
                Text(
                    '${goods.fmRewardType == 1 ? Translations.of(context).text('goods_fmdayNum') : Translations.of(context).text('goods_fmMonthRe')}'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${goods.fmRewardNum}${goods.fmRewardType == 2 ? '%' : ''}',
                  style: TextStyle(color: Color(0xffFFA61A), fontSize: 16),
                )
              ],
            ),
          ),
        ],
      );
    }
    // BTC 类型显示
    else if (goods.coinName == "btc" && goods.isSuper != 1) {
      return Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 单份算力
                Text(Translations.of(context).text('goods_unit')),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${goods.unit}',
                  style: TextStyle(color: Color(0xffFFA61A), fontSize: 16),
                )
              ],
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Color(0xff444C61),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 月化收益约
                Text('BTC${Translations.of(context).text('goods_rate')}'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${goods.rentIncomeRate - goods.fmRewardNum}%',
                  style: TextStyle(color: Color(0xffFFA61A), fontSize: 16),
                )
              ],
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Color(0xff444C61),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 'FM日产' : 'FM月化收益'
                Text(
                    '${goods.fmRewardType == 1 ? Translations.of(context).text('goods_fmdayNum') : Translations.of(context).text('goods_fmMonthRe')}'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${goods.fmRewardNum}${goods.fmRewardType == 2 ? '%' : ''}',
                  style: TextStyle(color: Color(0xffFFA61A), fontSize: 16),
                )
              ],
            ),
          ),
        ],
      );
    } else if (goods.coinName != "btc" || goods.isSuper == 1) {
      return Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (goods.unit != null && goods.unit != '')
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 单份算力
                  Text(Translations.of(context).text('goods_unit')),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${goods.unit}',
                    style: TextStyle(color: Color(0xffFFA61A), fontSize: 16),
                  )
                ],
              ),
            ),
          if (goods.unit != null && goods.unit != '')
            Container(
              width: 1,
              height: 50,
              color: Color(0xff444C61),
            ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 月化收益
                Text(
                    '${goods.coinName.toUpperCase()}${Translations.of(context).text('goods_rateNum')}'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${goods.rentIncomeRate - goods.fmRewardNum}%',
                  style: TextStyle(color: Color(0xffFFA61A), fontSize: 16),
                )
              ],
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Color(0xff444C61),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //  'FM日产' : 'FM月化收益'
                Text(
                    '${goods.fmRewardType == 1 ? Translations.of(context).text('goods_fmdayNum') : Translations.of(context).text('goods_fmMonthRe')}'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${goods.fmRewardNum}${goods.fmRewardType == 2 ? '%' : ''}',
                  style: TextStyle(color: Color(0xffFFA61A), fontSize: 16),
                )
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 240,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                decoration: BoxDecoration(
                    // color: Colors.red,
                    // color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage('assets/images/goods_top_bg.png'),
                        fit: BoxFit.cover)),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MyAssetsImage(
                          assetsUrl:
                              Translations.of(context).text('goods_icon_rent'),
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${item.goodsName}', // 产品名称
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        // 体验
                        item.packType == 2
                            ? Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                    color: Color(0xffffa61a),
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10))),
                                // 体验
                                child: Text(Translations.of(context)
                                    .text('goods_experience')),
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          // 每份售价
                          child: Text(
                              Translations.of(context).text('goods_price')),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${NumberFormat.formatDoubel(item.price)}',
                          style:
                              TextStyle(color: Color(0xffffbe19), fontSize: 40),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Text('${item.isSuper == 1 ? 'FM' : 'USDT'}'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // 月化收益
                        Text(
                          '${Translations.of(context).text('goods_rateNum')}：${item.rentIncomeRate != 0 ? item.rentIncomeRate : '0'}%',
                          style: TextStyle(color: Color(0xffaaaaaa)),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        // 可售份数：
                        Text(
                          '${Translations.of(context).text('goods_stock')}：${item.stock}份',
                          style: TextStyle(color: Color(0xffaaaaaa)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 150,
            left: 10,
            right: 10,
            child: Container(
                height: 80,
                decoration: BoxDecoration(
                    color: Color(0xff232836).withOpacity(0.8),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                // child: GoodsPositionMess(item: item),
                child: _builditem(context, item)),
          )
        ],
      ),
    );
  }
}

class CheckItemssss {
  String title;
  int index;

  CheckItemssss(this.title, this.index);
}

// 底部组件
class GoodsBottomMess extends StatefulWidget {
  final BuildContext context;
  final ModelGoods goods;

  GoodsBottomMess({this.goods, this.context});

  @override
  _GoodsBottomMessState createState() => _GoodsBottomMessState();
}

class _GoodsBottomMessState extends State<GoodsBottomMess> {
  int _currentIndex = 0;
  ModelGoods goods;
  List<CheckItemssss> _checklist = new List();
  String detail = '';

  // _GoodsBottomMessState({this.goods});

  void handleChangeCurrentIndex(int index) {
    setState(() {
      print(index);
      _currentIndex = index;
      if (index == 0) {
        detail = goods.detail;
      } else if (index == 1) {
        detail = goods.contractDescription;
      } else if (index == 2) {
        detail = goods.riskWarning;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  initData() {
    setState(() {
      goods = widget.goods;
    });
    if (goods.isSuper != 1) {
      _checklist.removeRange(0, _checklist.length);
      // 算力介绍

      _checklist.add(new CheckItemssss(
          Translations.of(widget.context)
              .text('component_goodsNotice_introduce'),
          0));
      detail = goods.detail;
    } else {
      _currentIndex = 1;
      detail = goods.contractDescription;
    }
    // 合约说明
    _checklist.add(new CheckItemssss(
        Translations.of(widget.context).text('component_goodsNotice_contract'),
        1));
    // 风险提示
    _checklist.add(new CheckItemssss(
        Translations.of(widget.context).text('component_goodsNotice_risk'), 2));
    handleChangeCurrentIndex(0);
  }

  // checklist.(a);

  Color onColor = Color(0xffFFA61A);

  @override
  Widget build(BuildContext context) {
    if (goods == null || goods.goodsCode != widget.goods.goodsCode) {
      initData();
    }
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 130),
      color: Color(0xff1C212E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 40,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _checklist
                    .map((e) => Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Text(
                                '${e.title}',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: e.index == _currentIndex
                                        ? onColor
                                        : Colors.white),
                              ),
                              onTap: () {
                                handleChangeCurrentIndex(e.index);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: e.index == _currentIndex ? 1 : 0,
                              width: 20,
                              color: onColor,
                            )
                          ],
                        ))
                    .toList()),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              detail,
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Color(0xffaaaaaa), fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}

class GoodsGotoPay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoodsBloc _goodsBloc = GoodsDetailProvider.of(context).bloc;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: Container(
            height: 40,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(80)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xffEDB94D), Color(0xffD2722E)],
              ),
            ),
            child: Center(
              // 立即挖矿
              child: Text(
                Translations.of(context).text('goods_btn'),
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          onTap: () {
            _goodsBloc.goToPay(context);
            // var openMo = CononModal.openModalBottomSheet(context);
          },
        )
      ],
    );
  }
}

class GoodsUpGradePay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoodsBloc _goodsBloc = GoodsDetailProvider.of(context).bloc;
    return Column(
      children: [
        Container(
          color: Color(0xff171D2A),
          padding: EdgeInsets.only(left: 10, top: 10),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // 升级份数
              Text(
                Translations.of(context).text('goods_upgrade_count'),
                style: TextStyle(fontSize: 15),
              ),
              Container(
                padding: EdgeInsets.only(left: 14),
                width: 140,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _goodsBloc._handleChangeController.add('minus');
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
                          stream: _goodsBloc.count,
                          builder: (context, snapshot) {
                            return Text('${snapshot.data}');
                          },
                        )),
                    GestureDetector(
                      onTap: () {
                        _goodsBloc._handleChangeController.add('add');
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
        ),
        Container(
          color: Color(0xff171D2A),
          child: Row(
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                  stream: _goodsBloc.upAmount,
                  builder: (context, snapshot) {
                    GoodsUpGradeAmount obj = new GoodsUpGradeAmount();
                    if (snapshot.data == null) {
                      return Container(child: null);
                    }
                    obj = snapshot.data;
                    if (obj.unit == null) {
                      return Container(child: null);
                    }

                    return Container(
                        height: 80,
                        padding: EdgeInsets.only(left: 10, top: 10),
                        // color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              // 剩余${obj.unit2.toUpperCase()}支付:

                              text: TextSpan(
                                  text:
                                      '${Translations.of(context).text('goods_c_coupon_surplus')}${obj.unit2.toUpperCase()}${Translations.of(context).text('mining_hashrateOrder_pay')}: ',
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xffaaaaaa)),
                                  children: [
                                    TextSpan(
                                        text:
                                            '≈ ${obj.remainPayAmount2} (${obj.unit2.toUpperCase()})',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Theme.of(context).accentColor))
                                  ]),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              // 还需支付
                              text: TextSpan(
                                  text:
                                      '${obj.unit.toUpperCase()}${Translations.of(context).text('mining_hashrateOrder_pay')}: ',
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xffaaaaaa)),
                                  children: [
                                    TextSpan(
                                        text:
                                            '${obj.remainPayAmount} (${obj.unit.toUpperCase()})',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Theme.of(context).accentColor))
                                  ]),
                            ),
                          ],
                        ));
                  },
                ),
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(80)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Color(0xffEDB94D), Color(0xffD2722E)],
                    ),
                  ),
                  child: Center(
                    // 确定升级
                    child: Text(
                      Translations.of(context).text('goods_confirm_upgrade'),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                onTap: () {
                  _goodsBloc.goToUpGrade(context);
                  // var openMo = CononModal.openModalBottomSheet(context);
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

class GoodsDetailProvider extends InheritedWidget {
  final Widget child;
  final GoodsBloc bloc;

  GoodsDetailProvider({
    this.child,
    this.bloc,
  }) : super(child: child);

  static GoodsDetailProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GoodsDetailProvider>();

  @override
  bool updateShouldNotify(GoodsDetailProvider oldWidget) {
    return true;
  }
}

class GoodsBloc {
  BuildContext context;
  GoodsDetailsParams params;
  ModelGoodsView goodsView = new ModelGoodsView();
  bool isChangeUpGradeItem = false;
  int _count = 1; // 默认数量
  String tip = '请先选择你想升级的额度';
  String upGradeCode = '';
  String remainPayAmount = '';

  final _goodsItem = StreamController<ModelGoodsView>.broadcast();

  Stream<ModelGoodsView> get goodsItem => _goodsItem.stream;

  final _goodsSelectUpGrade = StreamController<bool>();

  Stream<bool> get goodsSelectUpGrade => _goodsSelectUpGrade.stream;

  final _countController = StreamController<int>();
  Stream<int> get count => _countController.stream;

  final _handleChangeController = StreamController<String>();
  StreamSink<String> get handleChangeCount => _handleChangeController.sink;

  final _upgradeAmountController = StreamController<GoodsUpGradeAmount>();
  Stream<GoodsUpGradeAmount> get upAmount => _upgradeAmountController.stream;

  GoodsBloc({this.params, this.context}) {
    _handleChangeController.stream.listen(changeCount);
    if (params.orderCode != null) {
      getUpGradeList(params.orderCode);
    } else {
      getGoods(params.goodsCode);
    }
    tip = Translations.of(context).text('goods_select_upgrade_list');
  }

  void getUpGradeList(String orderCode) async {
    List<ModelUpGrade> _list = await GoodsDao.getLevelUpSelectList(orderCode);
    if (_list != null) {
      goodsView.uplist = _list;
      remainPayAmountFun(0);
      upGradeCode = _list[0].goodsCode;
      getGoods(_list[0].goodsCode);
      // getShowAmountPrice();
    }
  }

  // 购买数量变化
  void changeCount(String type) {
    if (!isChangeUpGradeItem) {
      EasyLoading.showToast(
          Translations.of(context).text('goods_select_upgrade_list'),
          duration: Duration(seconds: 2));
      return;
    }

    if (type == 'add') {
      // 最大限制

      if (_count >= 10 || _count >= params.totalcount) {
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

    getShowAmountPrice();
  }

  void getShowAmountPrice() async {
    GoodsUpGradeAmount obj = await GoodsDao.goodsUpGradeGetPrice(
        params.orderCode, goodsView.goods.goodsCode, _count);

    _upgradeAmountController.add(obj);
  }

  /// 获取单个产品
  void getGoods(String goodscode) async {
    ModelGoods goods = await GoodsDao.goodsGet(goodscode);

    goodsView.goods = ModelGoods.fromJson(goods.toJson());
    _goodsItem.add(goodsView);
    // 重新计算价格
    if (params.orderCode != null) {
      _count = 1;
      _countController.add(_count);
      getShowAmountPrice();
    }
  }

  /// 显示选择图层
  void showUpGradeList(bool type) {
    _goodsSelectUpGrade.add(type);
  }

  /// 显示选择图层
  void checkUpGradeList(int index) {
    _goodsSelectUpGrade.add(false);
    isChangeUpGradeItem = true;
    upGradeCode = goodsView.uplist[index].goodsCode;
    remainPayAmountFun(index);
    tip = '${NumberFormat.formatDoubel(goodsView.uplist[index].price)} USDT';
    getGoods(goodsView.uplist[index].goodsCode);
  }

  void goToPay(context) {
    Navigator.pushNamed(context, '/goods-pay',
        arguments: goodsView.goods.goodsCode);
  }

  /// 订单升级
  void goToUpGrade(context) async {
    // 必须选择一个后才能升级
    // 请先选择你想升级的额度
    if (!isChangeUpGradeItem) {
      EasyLoading.showToast(
          Translations.of(context).text('goods_select_upgrade_list'),
          duration: Duration(seconds: 2));
      return;
    }
    // 请输入交易密码

    ModelDialogs<String> _dailog = await MyDialog.passwordDialog(context,
        title: Translations.of(context).text('mining_modalPwd_title'));
    if (_dailog.type != 'ok') return;

    bool istrue = await GoodsDao.goodsUpGradeTwo(params.orderCode, upGradeCode,
        TripleDesUtil.generateDes(_dailog.message), _count);

    // if (!istrue) {
    //   EasyLoading.showToast('升级失败', duration: Duration(seconds: 2));
    //   return;
    // }
    // 支付成功
    if (istrue)
      Navigator.pushNamed(context, '/paysuccess',
          arguments: Translations.of(context).text('goods_o_order_paid'));
  }

  void remainPayAmountFun(int index) {
    remainPayAmount = '${goodsView.uplist[index].remainPayAmount} USDT';
  }

  dispse() {
    _countController.close();
    _upgradeAmountController.close();
    _handleChangeController.close();
    _goodsItem.close();
    _goodsSelectUpGrade.close();
  }
}
