import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/numberFormat.dart';
import 'package:flutter_app_yt/dao/pay_dao.dart';
import 'package:flutter_app_yt/model/pay_coupon_model.dart';
import 'package:flutter_app_yt/model/util_model.dart';
import '../../translations.dart';

enum CouponConfirmType { OKKEY, OK, NOUSE }

class CononModal {
  /// 显示 底部弹层
  static Future<ModelDialogs<ModelPayCoupon>> openModalBottomSheet(context,
      {String goodsCode,
      int number,
      String payType,
      ModelPayCoupon selected}) async {
    MediaQueryData mq = MediaQuery.of(context);
    // 屏幕高(注意是dp)
    double height = mq.size.height * (9.0 / 16.0);

    int page = 1;
    int pageSize = 30;

    /// 当前选择
    List<int> _selected = selected.selectedCoupon.map((e) => e.id).toList();

    ///最优列表
    List<int> _optimumList = selected.selectedCoupon.map((e) => e.id).toList();
    ModelSelectCoupon datas;
    List<ModelSelectCouponPageRowsItem> listdb;
    final _handleChangePageController =
        StreamController<List<ModelSelectCouponPageRowsItem>>.broadcast();
    var _stream = _handleChangePageController.stream;
    // Stream<String> get datalist => _handleChangePageController.stream;

    final _scrollViewStreamController = StreamController<int>(); // 触发分页
    _scrollViewStreamController.stream.listen((size) async {
      datas = await PayDao.getSelectCoupon(
          goodsCode: goodsCode,
          number: number,
          payType: payType,
          page: page,
          pageSize: size,
          selected: _selected);
      listdb = datas.couponPage.rows;
      // if()
      _handleChangePageController.add(listdb);
    });

    /// 点击修改状态
    void handleChangeItemState(int index, {bool disable = false}) {
      if (!disable) {
        listdb[index].currentState = listdb[index].currentState == 2 ? 1 : 2;
        _selected = listdb
            .where((e) => e.currentState == 1)
            .toList()
            .map((e) => e.id)
            .toList();
      } else {
        _selected = [listdb[index].id];
      }
      // List<ModelSelectCouponPageRowsItem> _db = List.from(listdb);

      _scrollViewStreamController.add(pageSize);
    }

    /// 滚动监听
    ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (pageSize < datas.couponPage.total) {
          pageSize += pageSize;
          _scrollViewStreamController.add(pageSize);
        }
        print("daodil");
      }
    });

    _scrollViewStreamController.add(pageSize);

    Widget _lineItem(BuildContext context, int index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      ' ${NumberFormat.formatDoubel(listdb[index].value)} ${listdb[index].unit != null ? listdb[index].unit.toUpperCase() : ''}',
                      style: TextStyle(color: Color(0xffFFA61A), fontSize: 14),
                    ),
                    _optimumList.contains(listdb[index].id)
                        ? Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 2, bottom: 12),
                            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                            decoration: BoxDecoration(
                                color: Color(0xffFFA61A),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  topRight: Radius.circular(7),
                                  bottomRight: Radius.circular(7),
                                )),
                            // 推荐
                            child: Text(
                              Translations.of(context)
                                  .text('goods_c_recommend'),
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ))
                        : SizedBox(),
                  ],
                ),
                Text('${listdb[index].typeName}')
              ],
            ),
          ),
          // 有效至
          Text(
            '${Translations.of(context).text('goods_c_valid_till')}:${listdb[index].endTime}',
            style: TextStyle(fontSize: 12, color: Color(0xffaaaaaa)),
          ),
          Container(
              alignment: Alignment.centerRight,
              child: Checkbox(
                value: listdb[index].currentState == 1 ? true : false,
                activeColor: Color(0xffFFA61A),
                onChanged: (bool val) {
                  if (listdb[index].currentState != 3) {
                    handleChangeItemState(index);
                  } else {
                    handleChangeItemState(index, disable: true);
                  }
                  // val 是布尔值
                },
              ))
        ],
      );
    }

    Widget _listItem(BuildContext context, int index) {
      return Container(
        // padding: EdgeInsets.all(5.0),
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: listdb[index].currentState == 3
            ? Opacity(
                opacity: 0.6,
                child: _lineItem(context, index),
              )
            : _lineItem(context, index),
      );
    }

    final option = await showModalBottomSheet(
        backgroundColor: Color(0xff232836),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        builder: (BuildContext context) {
          return Container(
            // height: 1000.0,
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    height: 60.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, 'cancle');
                          },
                          child: Container(
                              alignment: Alignment.centerLeft,
                              width: 100,
                              child: Icon(Icons.close)),
                        ),
                        // 优惠方案
                        Text(
                          Translations.of(context).text('goods_c_scheme'),
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 4),
                          width: 100,
                          child: GestureDetector(
                            // 不使用优惠
                            child: Text(Translations.of(context)
                                .text('goods_c_nonuse')),
                            onTap: () {
                              Navigator.pop(context, CouponConfirmType.NOUSE);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 1.0, color: Color(0xff1C202C)))),
                    height: height - 150.0,
                    child: StreamBuilder(
                        stream: _stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                              child: Text('loading...'),
                            );
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: listdb.length,
                            itemBuilder: _listItem,
                          );
                        }),
                  ),
                  Column(
                    children: <Widget>[
                      StreamBuilder(
                        stream: _stream,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return SizedBox();
                          }
                          return Container(
                            height: 20,
                            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    // 已选
                                    Text(
                                      Translations.of(context)
                                          .text('goods_c_selected'),
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(' ${datas.selectedCount} ',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xffFFA61A),
                                        )),
                                    // 张  剩余
                                    Text(
                                        '${Translations.of(context).text('goods_c_coupon_unit')}  ${Translations.of(context).text('goods_c_coupon_surplus')}',
                                        style: TextStyle(
                                          fontSize: 13,
                                        )),
                                    Text(' ${datas.remainingCount} ',
                                        style: TextStyle(
                                          color: Color(0xffFFA61A),
                                          fontSize: 15,
                                        )),
                                    // 张可选
                                    Text(
                                        '${Translations.of(context).text('goods_c_coupon_unit')}${Translations.of(context).text('goods_c_coupon_unit_can_use')}',
                                        style: TextStyle(
                                          fontSize: 13,
                                        )),
                                  ],
                                ),
                                // 可优惠：

                                Text(
                                  ' ${Translations.of(context).text('goods_c_can_be_preferential')}：${datas != null ? datas.couponAmount : ''} (${payType.toUpperCase()})',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xffFFA61A),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                                color: Color(0xffFFA61A), width: 1.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  // color: Colors.red,
                                  // 一键选推荐
                                  child: Text(Translations.of(context)
                                      .text('goods_c_recommendation')),
                                ),
                                onTap: () {
                                  Navigator.pop(
                                      context, CouponConfirmType.OKKEY);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, CouponConfirmType.OK);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xffFFA61A),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20))),
                                  alignment: Alignment.center,
                                  // color: Colors.red,
                                  // 确定
                                  child: Text(Translations.of(context)
                                      .text('mining_modalPwd_confirmText')),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });

    _scrollViewStreamController.close();
    _handleChangePageController.close();
    ModelDialogs<ModelPayCoupon> confirm =
        ModelDialogs<ModelPayCoupon>(type: 'cancle', message: ModelPayCoupon());
    if (option == CouponConfirmType.OK) {
      confirm.type = 'ok';
      confirm.message = await PayDao.confirmSelectedCoupon(
          goodsCode: goodsCode,
          count: number,
          payType: payType,
          selectedCoupon: _selected);
    } else if (option == CouponConfirmType.OKKEY) {
      confirm.type = 'ok';
      confirm.message = await PayDao.getPayAmount(
          goodsCode: goodsCode,
          count: number,
          payType: payType,
          isUseCoupon: true);
    } else if (option == CouponConfirmType.NOUSE) {
      confirm.type = 'ok';
      confirm.message = await PayDao.confirmSelectedCoupon(
          goodsCode: goodsCode,
          count: number,
          payType: payType,
          selectedCoupon: []);
    }

    // print('---');
    return confirm;
  }
}
