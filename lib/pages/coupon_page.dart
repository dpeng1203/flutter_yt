import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:flutter_app_yt/dao/pay_dao.dart';
import 'package:flutter_app_yt/model/pay_coupon_model.dart';
import 'package:flutter_app_yt/model/util_model.dart';
import 'package:flutter_app_yt/widget/list_no_data.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../translations.dart';

class CouponPage extends StatefulWidget {
  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: TopBackIcon(),
            title: Text(Translations.of(context).text('my_mining_coupon')),
            bottom: TabBar(
              unselectedLabelColor: Colors.white,
              // indicatorColor: Theme.of(context).accentColor,
              labelColor: Theme.of(context).accentColor,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: <Widget>[
                Tab(text: Translations.of(context).text('my_coupon_tobeuse')),
                Tab(text: Translations.of(context).text('my_coupon_used')),
                Tab(text: Translations.of(context).text('my_coupon_pastdue')),
              ],
              onTap: (index) {
                print("$index");
              },
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              UnusedCouponPage(
                context: context,
              ),
              UsedCouponPage(
                pagestate: 1,
              ),
              UsedCouponPage(
                pagestate: 2,
              ),
            ],
          )),
    );
  }
}

// 二级Tab数据类型
class CouponSecondTabbar {
  String name;
  Color color;
  int type;
  String image;
  bool ac;

  CouponSecondTabbar({this.name, this.color, this.type, this.image, this.ac});
}

/// 未使用页面
class UnusedCouponPage extends StatefulWidget {
  final BuildContext context;
  UnusedCouponPage({this.context});
  @override
  _UnusedCouponPageState createState() => _UnusedCouponPageState();
}

class _UnusedCouponPageState extends State<UnusedCouponPage> {
  List<CouponSecondTabbar> tabbar = [
    CouponSecondTabbar(
      ac: true,
      name: '全部',
      color: Color(0xffFFA61A),
      type: 0,
      image: 'assets/images/coupon_choose_icon_default.png',
    ),
    CouponSecondTabbar(
      ac: false,
      name: '红宝',
      color: Color(0xffD56064),
      type: 2,
      image: 'assets/images/coupon_choose_icon_red.png',
    ),
    CouponSecondTabbar(
      ac: false,
      name: '蓝宝',
      color: Color(0xff54A7F1),
      type: 1,
      image: 'assets/images/coupon_choose_icon_blue.png',
    ),
    CouponSecondTabbar(
      ac: false,
      name: '绿宝',
      color: Color(0xff5DB29C),
      type: 3,
      image: 'assets/images/coupon_choose_icon_green.png',
    ),
    CouponSecondTabbar(
      ac: false,
      name: '黄宝',
      color: Color(0xffE0AB54),
      type: 4,
      image: 'assets/images/coupon_choose_icon_yellow.png',
    ),
  ];
  int page = 1;
  int selectTabIndex = 0;
  String selectTabDefaultImage = 'assets/images/coupon_choose_icon_default.png';
  final TextEditingController controllerTextField = TextEditingController();
  bool canExchange = false;

  /// 滚动监听
  ScrollController _scrollController = ScrollController();

  CouponData datalist;

  @override
  void initState() {
    super.initState();

    setState(() {
      tabbar[0].name =
          Translations.of(widget.context).text('my_coupon_state_all');
      tabbar[1].name =
          Translations.of(widget.context).text('my_coupon_state_red');
      tabbar[2].name =
          Translations.of(widget.context).text('my_coupon_state_blue');
      tabbar[3].name =
          Translations.of(widget.context).text('my_coupon_state_green');
      tabbar[4].name =
          Translations.of(widget.context).text('my_coupon_state_yellow');
    });
    datalist = new CouponData();
    controllerTextField.addListener(() {
      String currentStr = controllerTextField.text;

      if (currentStr.length > 20) {
        setState(() {
          canExchange = true;
        });
      } else {
        setState(() {
          canExchange = false;
        });
      }

      // print("$currentStr");
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("到底了");

        if (page < datalist.pageCount) {
          page = page + 1;
          _loadData(page);
        }
      }
    });
    _loadData(page);
  }

  /// 加载数据
  void _loadData(int page, {bool needloading = true}) async {
    CouponData data = await PayDao.getQueryCouponType(
        state: 0,
        type: tabbar[selectTabIndex].type,
        page: page,
        pageSize: 30,
        needload: needloading);

    if (page == 1) {
      if (this.mounted) {
        setState(() {
          datalist = data;
        });
      }
    } else {
      datalist.rows.addAll(data.rows);
      setState(() {
        datalist = datalist;
      });
    }
  }

  /// 点击切换类型
  void _changeTabIndex(int index) {
    setState(() {
      selectTabIndex = index;
      page = 1;
    });
    _loadData(page);
  }

  /// 兑换黄码
  void yellowCouponExchange(int index) async {
    if (datalist.rows[index].ischange ?? false) return;

    ModelDialogs<String> _dailog = await MyDialog.passwordDialog(context,
        ispwd: false,
        showCloseIcon: true,
        title:
            '${Translations.of(context).text('my_coupon_exchange_to_asset')}',
        showWdiget: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Translations.of(context).text('my_coupon_exchange_type'),
                    style: TextStyle(color: Color(0xff888888), fontSize: 12),
                  ),
                  Text('${datalist.rows[index].unit?.toUpperCase()}',
                      style: TextStyle(color: Color(0xff888888), fontSize: 12))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Translations.of(context).text('convers_usdt_num'),
                    style: TextStyle(color: Color(0xff888888), fontSize: 12),
                  ),
                  Text('${datalist.rows[index].value}',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 15))
                ],
              ),
            ],
          ),
        ),
        cancletxt: Translations.of(context).text('goods_o_payTipU'),
        confirmtxt: Translations.of(context).text('my_coupon_exchange_btn'));
    if (_dailog.type == 'ok') {
      await PayDao.couponUseTopaz(id: datalist.rows[index].id);

      datalist.rows[index].ischange = true;
      EasyLoading.showToast(
          Translations.of(context).text('my_coupon_exchange_success'),
          duration: Duration(seconds: 1));
      Future.delayed(Duration(milliseconds: 2500), () {
        setState(() {
          page = 1;
        });
        _loadData(page);
      });
    } else if (_dailog.type == 'cancle') {
      Navigator.pushNamedAndRemoveUntil(context, '/navigator', (route) => false,
          arguments: 1);
    }
  }

  // final _controller = TextEditingController();

  void toExchangeCoupon() async {
    String code = controllerTextField.text.trim();
    bool isExchange = await PayDao.couponExchangeCouponCode(code: code);
    if (!isExchange) return;
    EasyLoading.showToast(
        Translations.of(context).text('my_coupon_exchange_success'));
    setState(() {
      page = 1;
    });
    _loadData(page);
    controllerTextField.clear();
  }

  Widget _header() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      color: Color(0xff232836),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: tabbar
                .asMap()
                .keys
                .map((index) => Expanded(
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            _changeTabIndex(index);
                          },
                          child: Container(
                            color: Color(0xff232836),
                            alignment: Alignment.center,
                            height: 44,
                            child: index == 0
                                ? Text(
                                    tabbar[index].name,
                                    style: TextStyle(
                                        color: selectTabIndex == 0
                                            ? Theme.of(context).accentColor
                                            : Colors.white),
                                  )
                                : Row(
                                    children: <Widget>[
                                      if (index == selectTabIndex)
                                        Image.asset(
                                          tabbar[index].image,
                                          width: 20,
                                        )
                                      else
                                        Image.asset(
                                          selectTabDefaultImage,
                                          width: 20,
                                        ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          tabbar[index].name,
                                          style: TextStyle(
                                              color: index == selectTabIndex
                                                  ? tabbar[index].color
                                                  : Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          Container(
            color: Color(0xff171d2a),
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Container(
                    height: 44,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                        controller: controllerTextField,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff232836)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            border: InputBorder.none,
                            hintText: Translations.of(context)
                                .text('my_coupon_exchange_into_code'),
                            fillColor: Color(0xff232836)))),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (canExchange) {
                        toExchangeCoupon();
                      } else {
                        EasyLoading.showToast(Translations.of(context)
                            .text('my_coupon_exchange_error_len'));
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: !canExchange
                              ? Color(0xff888888)
                              : Theme.of(context).accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      height: 44,
                      child: Text(Translations.of(context)
                          .text('my_coupon_exchange_btn')),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  RefreshController _controller = RefreshController();
  Future<Null> _refresh() async {
    setState(() {
      page = 1;
    });
    _loadData(page, needloading: false);

    _controller.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _controller,
      enablePullUp: false,
      header: GifLoading(),
      onRefresh: _refresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _header(),
          ),
          SliverGrid(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              if (datalist.rows == null) {
                return PageNoData();
              } else {
                return CouponItem(
                  data: datalist.rows[index],
                  index: index,
                  exchange: yellowCouponExchange,
                );
              }
            }, childCount: datalist.rows != null ? datalist.rows.length : 1),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: datalist.rows != null ? 2 : 1,
                childAspectRatio: 2 / 2.3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0),
          )
        ],
      ),
    );
  }
}

class UsedCouponPage extends StatefulWidget {
  final int pagestate;

  UsedCouponPage({this.pagestate = 2});

  @override
  _UsedCouponPageState createState() => _UsedCouponPageState();
}

class _UsedCouponPageState extends State<UsedCouponPage> {
  int page = 1;

  /// 滚动监听1
  ScrollController _scrollController = ScrollController();

  CouponData datalist;

  @override
  void initState() {
    super.initState();
    datalist = new CouponData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("到底了");
        // _miningBloc.handleChangePageSize.add('a');
        if (page < datalist.pageCount) {
          page = page + 1;
          _loadData(page);
        }
      }
    });
    _loadData(page);
  }

  /// 加载数据
  void _loadData(int page, {bool needloading = true}) async {
    CouponData data = await PayDao.getQueryCouponType(
        state: widget.pagestate,
        type: 0,
        page: page,
        pageSize: 30,
        needload: needloading);

    if (page == 1) {
      if (this.mounted) {
        setState(() {
          datalist = data;
        });
      }
    } else {
      datalist.rows.addAll(data.rows);
      setState(() {
        datalist = datalist;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  RefreshController _controller = RefreshController();
  Future<Null> _refresh() async {
    setState(() {
      page = 1;
    });
    _loadData(page, needloading: false);
    _controller.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    if (datalist.rows == null)
      return SmartRefresher(
        controller: _controller,
        enablePullUp: false,
        header: GifLoading(),
        onRefresh: _refresh,
        child: PageNoData(),
      );
    else
      return SmartRefresher(
        controller: _controller,
        enablePullUp: false,
        header: GifLoading(),
        onRefresh: _refresh,
        child: GridView.builder(
          controller: _scrollController,
          itemCount: datalist.rows.length,
          itemBuilder: (context, index) {
            return CouponItem(
              data: datalist.rows[index],
              index: index,
              isTimeout: true,
              // abc: abc,
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 2.3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0),
        ),
      );
  }
}

class CouponItem extends StatefulWidget {
  final CouponDataItem data;
  final int index;
  final bool isTimeout;
  final exchange;

  CouponItem({this.data, this.index, this.isTimeout = false, this.exchange});

  @override
  _CouponItemState createState() => _CouponItemState();
}

//class _CouponItemState extends State<CouponItem> {
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}

class _CouponItemState extends State<CouponItem>
    with SingleTickerProviderStateMixin {
  // 初始opacityLevel为1.0为可见状态，为0.0时不可见
  AnimationController _animationController;
  // bool isclick = false;
  // double _width = 0;
  double _aniValue = 0;
  @override
  void initState() {
    super.initState();
    //lowerBound和upperBound值只能在0.0到1.0之间变化
    _animationController = new AnimationController(
        vsync: this,
        lowerBound: 0,
        upperBound: 1,
        duration: new Duration(milliseconds: 100));
// 添加监听
    _animationController.addListener(() {
      setState(() {
        // _width = _animationController.value *
        //     (MediaQuery.of(context).size.width / 2);
        _aniValue = _animationController.value;
      });
      // setState(() {});
    });
    // _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    num _itemheight =
        ((MediaQuery.of(context).size.width - 10) / 2) / (2 / 2.3);
    // String rule =
    //     '1，折扣券使用订单金额不超过10000USDT。---2，使用该券90天内不可赎回。---3，领取该券后限3天内使用有效，过期作废。---4，使用该券实际支付金额为订单金额的90%，每人限领2张。';

    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/coupon_bg.png'))),
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.data.type == 1)
                Image.asset(
                  'assets/images/coupon_blue_icon.png',
                  width: 54,
                  height: 47,
                )
              else if (widget.data.type == 2)
                Image.asset(
                  'assets/images/coupon_red_icon.png',
                  width: 54,
                  height: 47,
                )
              else if (widget.data.type == 3)
                Image.asset(
                  'assets/images/coupon_green_icon.png',
                  width: 54,
                  height: 47,
                )
              else if (widget.data.type == 4)
                Image.asset(
                  'assets/images/coupon_yellow_icon.png',
                  width: 54,
                  height: 47,
                ),
              SizedBox(
                height: 4,
              ),
              Text(
                '${widget.data.value}${widget.data.unit?.toUpperCase()}',
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).accentColor),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '${widget.data.name}',
                style: TextStyle(
                    fontSize: 13,
                    color: widget.isTimeout
                        ? Color(0xffaaaaaa)
                        : Color(0xffD9EFFF)),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '${widget.data.typeName}',
                style: TextStyle(
                    fontSize: 13,
                    color: widget.isTimeout
                        ? Color(0xffaaaaaa)
                        : Color(0xffD9EFFF)),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                padding: EdgeInsets.only(
                    left: (MediaQuery.of(context).size.width) / 8),
                child: GestureDetector(
                  onTap: () {
                    _animationController.forward();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Translations.of(context).text('my_coupon_rule'),
                        style: TextStyle(
                            fontSize: 13,
                            color: widget.isTimeout
                                ? Color(0xffaaaaaa)
                                : Color(0xffD9EFFF)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.help_outline,
                        size: 15,
                        color: widget.isTimeout
                            ? Color(0xffaaaaaa)
                            : Color(0xffD9EFFF),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              SecondTimer(
                context: context,
                data: widget.data,
                pcolor:
                    widget.isTimeout ? Color(0xffaaaaaa) : Color(0xffD9EFFF),
              ),
              SizedBox(
                height: 2,
              ),
              GestureDetector(
                onTap: () {
                  // 1 未开始 不能使用
                  if (widget.data.tagState != 1) {
                    // 0 可使用
                    if (widget.data.state == 0) {
                      //  4 现金劵（黄宝）不使用
                      // print("$data");
                      if (widget.data.type != 4) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/navigator', (route) => false,
                            arguments: 1);
                      } else {
                        widget.exchange(widget.index);
                      }
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 2),
                  // color: Colors.red,
                  alignment: Alignment.center,
                  height: 25,
                  width: (MediaQuery.of(context).size.width / 2) - 40,
                  decoration: BoxDecoration(
                      color: widget.isTimeout
                          ? Color(0xff888888)
                          : Color(0xff448790),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  // 立即使用
                  child: Text(
                    widget.data
                        .stateName, // Translations.of(context).text('my_coupon_rule'),
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              Container(
                height: 15,
                width: (MediaQuery.of(context).size.width / 2) - 40,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                      Color(0xff00f5ff).withOpacity(0.1),
                      Color(0xff00f5ff).withOpacity(0)
                    ])),
              ),
            ],
          ),
          // if (opacityLevel > 0)
          Positioned(
            top: 0,
            left: ((MediaQuery.of(context).size.width / 2) -
                    ((MediaQuery.of(context).size.width / 2) - 35)) /
                2,
            // right: 0,
            bottom: 0,
            child: Container(
                width:
                    _aniValue * ((MediaQuery.of(context).size.width / 2) - 40),
                color: Color(0xff232836).withOpacity(0.95),
                padding: const EdgeInsets.only(top: 10, bottom: 0), //内边距
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Container(
                          height: (_itemheight / 2) + 38,
                          padding: const EdgeInsets.only(
                              bottom: 0, top: 8, left: 10, right: 10), //内边距
                          child: ListView(children: [
                            if (_aniValue > 0.5)
                              Text(
                                  widget.data.ruleContent
                                      .replaceAll('---', '\r\n'),
                                  style: TextStyle(
                                    fontSize: 12,
                                  ))
                          ]),
                        )),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: (_itemheight / 2) + 32,
                      // top: -20,
                      child: GestureDetector(
                        onTap: () {
                          _animationController.reverse();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          height: 25,
                          decoration: BoxDecoration(
                              color: widget.isTimeout
                                  ? Color(0xff888888)
                                  : Color(0xff448790),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text(Translations.of(context)
                              .text('my_coupon_return')),
                        ),
                      ),
                    )
                  ],
                )),
          )
        ]));
  }
}

/// 计数器
class SecondTimer extends StatefulWidget {
  final BuildContext context;
  final Color pcolor;
  final CouponDataItem data;

  SecondTimer({this.data, this.pcolor, this.context});

  @override
  _SecondTimerState createState() => _SecondTimerState();
}

class _SecondTimerState extends State<SecondTimer> {
  String _showtitle;
  CouponDataItem data;
  Color color;

  //定义变量
  Timer _timer;

  @override
  void initState() {
    super.initState();
    color = widget.pcolor;
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    if (this.mounted) update(widget.data);
  }

  void update(CouponDataItem _data) {
    String showtxt = '';
    CouponDataItem data = _data;
    // 0,待使用;1,已使用;2,已失效/作废

    if (data.tagState == 1) {
      // 开始时间
      showtxt =
          '${Translations.of(widget.context).text('my_coupon_exchange_timer_start')}:${data.startTime.split(' ')[0]}';

      setState(() {
        _showtitle = showtxt;
      });
      return;
    }

    if (data.state == 0) {
      int timeDifference = 0;
      // if (Platform.isAndroid) timeDifference = 3600 * 8;
      // 结束时间
      num endtime =
          (DateTime.parse('${data.endTime}').millisecondsSinceEpoch / 1000) -
              timeDifference;
      // 当前时间
      num _now = (DateTime.now().millisecondsSinceEpoch / 1000);
      var condition = endtime - _now; // 时间差
      if (condition < 0) {
        // 已过期
        showtxt = Translations.of(widget.context)
            .text('my_coupon_exchange_timer_expired');
      } else if (condition < 86400) {
        setState(() {
          color = Color(0xffFF644A);
        });
        startCountdown(condition);
      } else if (condition < 259200) {
        setState(() {
          color = Color(0xffFF644A);
        });
        // 有效仅剩
        showtxt =
            '${Translations.of(widget.context).text('my_coupon_exchange_timer_remain')} ${(condition ~/ (3600 * 24)) + ((condition % (3600 * 24)) == 0 ? 0 : 1)} 天';
      } else {
        // 有效至
        showtxt =
            '${Translations.of(widget.context).text('goods_c_valid_till')}:${data.endTime.split(' ')[0]}';
      }
    } else {
      // 有效至
      showtxt =
          '${Translations.of(widget.context).text('goods_c_valid_till')}:${data.endTime.split(' ')[0]}';
    }
    setState(() {
      _showtitle = showtxt;
    });
  }

  void startCountdown(double times) {
    final call = (time) {
      formshowTime(times);
      times = times - 1;
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void formshowTime(oldTime) {
    // 有效仅剩

    String _txt =
        '${Translations.of(widget.context).text('my_coupon_exchange_timer_remain')} ';
    double h = oldTime / 3600 % 24; //小时
    double m = oldTime / 60 % 60; //分钟
    double s = (oldTime % 60); //秒
    if (h.floor() < 10) {
      _txt = _txt + '0${h.floor()}';
    } else {
      _txt = _txt + '${h.floor()}';
    }
    if (m.floor() < 10) {
      _txt = _txt + ':0${m.floor()}';
    } else {
      _txt = _txt + ':${m.floor()}';
    }
    if (s.floor() < 10) {
      _txt = _txt + ':0${s.floor()}';
    } else {
      _txt = _txt + ':${s.floor()}';
    }

    if (oldTime > 0) {
      setState(() {
        _showtitle = _txt;
      });
    } else {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
      }
      setState(() {
        // 已过期

        _showtitle = Translations.of(widget.context)
            .text('my_coupon_exchange_timer_expired');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_showtitle', style: TextStyle(color: color, fontSize: 13));
  }
}
