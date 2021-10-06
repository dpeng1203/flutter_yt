import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:flutter_app_yt/dao/bills_item.dart';
import 'package:flutter_app_yt/dao/bills_type.dart';
import 'package:flutter_app_yt/dao/cancel_apply.dart';
import 'package:flutter_app_yt/model/bill_items_model.dart';
import 'package:flutter_app_yt/model/bills_type_model.dart';
import 'package:flutter_app_yt/model/util_model.dart';
import 'package:flutter_app_yt/translations.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillsPage extends StatefulWidget {
  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  ScrollController _scrollController;

  List coinStates;
  List changeTypes;
  List coinTypes;

  String curCoinType;
  String curState;
  String curChangeType;

  int curCoinTypeIndex;
  int curStateIndex;
  int curTypeIndex;

  bool loading = false;

  int pageCount;
  List<BillItemRow> rows = [];

  String curItemId;
  bool cancelRes;

  int page;
  int pageSize;

  @override
  void dispose() {
    super.dispose();
    // 这里不要忘了将监听移除
    _scrollController.dispose();
  }

  RefreshController _controller = RefreshController();
  Future<Null> _refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPullDown', true);
    await loadTypes();
    await loadData();
    prefs.setBool('isPullDown', false);
    _controller.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    curCoinTypeIndex = -1;
    curStateIndex = -1;
    curTypeIndex = -1;

    curCoinType = '-1';
    curState = '-1';
    curChangeType = '-1';

    page = 1;
    pageSize = 10;
    loadTypes();
    loadData();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (Platform.isAndroid &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        if (page < pageCount) {
          page = page + 1;
          loadData();
        }
      } else if (Platform.isIOS &&
          _scrollController.position.pixels >
              _scrollController.position.maxScrollExtent) {
        if (page < pageCount && !loading) {
          setState(() {
            loading = true;
          });
          page = page + 1;
          loadData();
        }
      } else if (Platform.isIOS &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  loadTypes() async {
    try {
      BillsTypeModel types = await BillsTypeDao.fetch();
      setState(() {
        coinStates = types.coinState;
        changeTypes = types.changeType;
        coinTypes = types.coinType;
      });
    } catch (e) {
      print(e);
    }
  }

  List<Widget> createItems(String typeOfSubType) {
    List<Widget> items = [];
    List curSubType;
    if (typeOfSubType == 'type') {
      curSubType = coinTypes;
    } else if (typeOfSubType == 'state') {
      curSubType = coinStates;
    } else if (typeOfSubType == 'changeType') {
      curSubType = changeTypes;
    }

    if (curSubType != null) {
      Widget allItem = Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: GestureDetector(
          onTap: () {
            if (typeOfSubType == 'type') {
              setState(() {
                curCoinType = '-1';
                curCoinTypeIndex = -1;
              });
            } else if (typeOfSubType == 'state') {
              setState(() {
                curState = '-1';
                curStateIndex = -1;
              });
            } else {
              setState(() {
                curChangeType = '-1';
                curTypeIndex = -1;
              });
            }
            setState(() {
              page = 1;
              rows = [];
            });
            loadData();
          },
          child: Text(Translations.of(context).text('assets_cb_all'),
              style: TextStyle(
                color: Color(((typeOfSubType == 'type' &&
                            curCoinTypeIndex == -1) ||
                        (typeOfSubType == 'state' && curStateIndex == -1) ||
                        (typeOfSubType == 'changeType' && curTypeIndex == -1))
                    ? 0xffFFC11C
                    : 0xffFFFFFF),
                height: 1.2,
              )),
        ),
      );

      items.add(allItem);
      curSubType.forEach((ele) {
        Widget item = Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: GestureDetector(
              onTap: () {
                if (typeOfSubType == 'type') {
                  setState(() {
                    page = 1;
                    rows = [];
                    curCoinType = ele.value;
                    curCoinTypeIndex = curSubType.indexOf(ele);
                  });
                } else if (typeOfSubType == 'state') {
                  setState(() {
                    page = 1;
                    rows = [];
                    curState = ele.value;
                    curStateIndex = curSubType.indexOf(ele);
                  });
                } else {
                  setState(() {
                    page = 1;
                    rows = [];
                    curChangeType = ele.value;
                    curTypeIndex = curSubType.indexOf(ele);
                  });
                }
                loadData();
              },
              child: Text(ele.lable,
                  style: TextStyle(
                      color: Color(((typeOfSubType == 'type' &&
                                  curCoinTypeIndex ==
                                      curSubType.indexOf(ele)) ||
                              (typeOfSubType == 'state' &&
                                  curStateIndex == curSubType.indexOf(ele)) ||
                              (typeOfSubType == 'changeType' &&
                                  curTypeIndex == curSubType.indexOf(ele)))
                          ? 0xffFFC11C
                          : 0xffFFFFFF),
                      height: 1.2))),
        );
        items.add(item);
      });
    }
    return items;
  }

  loadData() async {
    try {
      BillsItemsModel model =
          await BillsItemsDao.fetch(page, curCoinType, curState, curChangeType);
      setState(() {
        if (page == 1) {
          rows = model.rows;
        } else {
          rows.addAll(model.rows);
        }
        pageCount = model.pageCount;
      });
    } catch (e) {
      print(e);
    }
  }

  String getIcon(coinType) {
    String url;
    if (coinType == 'otc_in' || coinType == 'otc_out') {
      url = 'assets/images/icon-assets-change-otc.png';
    } else {
      url = 'assets/images/icon_${coinType.toLowerCase()}.png';
    }
    return url;
  }

  Widget getStateDesc(state) {
    if (state == 0) {
      return Text('(${Translations.of(context).text('assets_cbstate0')})',
          style: TextStyle(fontSize: 14)); // 审核中
    } else if (state == 1) {
      return Text('(${Translations.of(context).text('assets_cbstate1')})',
          style: TextStyle(fontSize: 14)); // 处理中
    } else if (state == 99) {
      return Text('(${Translations.of(context).text('assets_cbstate99')})',
          style: TextStyle(fontSize: 14, color: Colors.red)); // 已作废
    } else {
      return Text('');
    }
  }

  Widget getCancelBtn(ele) {
    if (ele.changeType == "out" && ele.state == 0) {
      return FlatButton(
        padding: EdgeInsets.all(0),
        key: UniqueKey(),
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xffFFC11C),
          ),
          child: Text(
            Translations.of(context).text('assets_coin_out_cancel'),
            style: TextStyle(fontSize: 13),
          ), // 撤销申请
        ),
        onPressed: () async {
          setState(() {
            curItemId = ele.recordCode;
          });
          // 撤销后，提币需重新申请
          ModelDialogs<String> _asstsdailog = await MyDialog.passwordDialog(
              context,
              ispwd: false,
              showWdiget: Text(
                Translations.of(context).text('assets_coin_out_cancel_tip'),
                style: TextStyle(color: Colors.black),
              ),
              confirmtxt: Translations.of(context)
                  .text('assets_out_picker_confirm')); // 确定
          if (_asstsdailog.type != 'ok') return;
          cancelRes = await CandelApplyDao.fetch(curItemId);
          if (cancelRes) {
            setState(() {
              page = 1;
            });
            await loadData();
          }
        },
      );
    } else {
      return Text('');
    }
  }

  List<Widget> get recodes {
    List<Widget> items = [];
    if (rows != null) {
      rows.forEach((ele) {
        Widget item = Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: EdgeInsets.fromLTRB(6, 10, 6, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xff232836),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 3, 10, 0),
                      child: Image.asset(getIcon(ele.coinType), width: 20),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(ele.billName,
                                style: TextStyle(fontWeight: FontWeight.w800)),
                            getStateDesc(ele.state)
                          ],
                        ),
                        Container(
                          width: 180,
                          child: Text(
                              ele.billChr == '-'
                                  ? ele.toAddress
                                  : ele.fromAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xffaaaaaa))),
                        ),
                        Text(ele.recordTime,
                            style: TextStyle(
                                fontSize: 12, color: Color(0xffaaaaaa))),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                        '${ele.billChr}${ele.amount.toStringAsFixed(6)} ${ele.coinType.toUpperCase()}',
                        style: TextStyle(
                            color: Color(
                                ele.billChr == '-' ? 0xffFFFFFF : 0xffFFC11C),
                            fontSize: 12)),
                    getCancelBtn(ele)
                  ],
                )
              ],
            ));
        items.add(item);
      });
    }
    return items;
  }

  Widget noData() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/coupon_no_data.png',
            width: 100,
          ),
          Text(Translations.of(context).text('assets_cbNunTip'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/navigator', (route) => false,
            arguments: 3);
        return true;
      },
      child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                leading: TopBackIcon(tap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/navigator', (route) => false,
                      arguments: 3);
                }),
                title: Text(Translations.of(context)
                    .text('title_assets-change-book')), //账单明细
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(30),
                  child: TabBar(
                      tabs: <Widget>[
                        Tab(
                            child: Text(
                                Translations.of(context)
                                    .text('assets_cb_coinType'),
                                style: TextStyle(fontSize: 15))), //币种
                        Tab(
                            child: Text(
                                Translations.of(context)
                                    .text('assets_cb_state'),
                                style: TextStyle(fontSize: 15))), //状态
                        Tab(
                            child: Text(
                                Translations.of(context).text('assets_cb_kind'),
                                style: TextStyle(fontSize: 15))), //类型
                      ],
                      onTap: (index) {
                        if (index == 0) {
                          setState(() {
                            page = 1;
                            rows = [];
                            loadData();
                          });
                        } else if (index == 1) {
                          setState(() {
                            page = 1;
                            rows = [];
                            loadData();
                          });
                        } else if (index == 2) {
                          setState(() {
                            page = 1;
                            rows = [];
                            loadData();
                          });
                        }
                      },
                      indicatorPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      indicatorColor: Color(0xffFFC11C),
                      labelColor: Color(0xffFFC11C),
                      labelStyle: TextStyle(fontSize: 12),
                      unselectedLabelColor: Colors.white),
                )),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        color: Color(0xff232836),
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: createItems('type')),
                      ),
                    ),
                    Positioned(
                      top: 75,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SmartRefresher(
                          controller: _controller,
                          enablePullUp: false,
                          header: GifLoading(),
                          onRefresh: _refresh,
                          child: recodes.length > 0
                              ? ListView(
                                  children: recodes,
                                  controller: _scrollController,
                                )
                              : noData()),
                    )
                  ],
                ),
                Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        color: Color(0xff232836),
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: createItems('state')),
                      ),
                    ),
                    Positioned(
                      top: 75,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SmartRefresher(
                          controller: _controller,
                          enablePullUp: false,
                          header: GifLoading(),
                          onRefresh: _refresh,
                          child: recodes.length > 0
                              ? ListView(
                                  children: recodes,
                                  controller: _scrollController,
                                )
                              : noData()),
                    )
                  ],
                ),
                Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        color: Color(0xff232836),
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: createItems('changeType')),
                      ),
                    ),
                    Positioned(
                      top: 75,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SmartRefresher(
                          controller: _controller,
                          enablePullUp: false,
                          header: GifLoading(),
                          onRefresh: _refresh,
                          child: recodes.length > 0
                              ? ListView(
                                  children: recodes,
                                  controller: _scrollController,
                                )
                              : noData()),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
