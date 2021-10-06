import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_app_yt/common/NumberFormat.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:flutter_app_yt/dao/home_dao.dart';
import 'package:flutter_app_yt/model/goods_models.dart';
import 'package:flutter_app_yt/model/home_coin_model.dart';
import 'package:flutter_app_yt/model/home_model.dart';
import 'package:flutter_app_yt/model/util_model.dart';
import 'package:flutter_app_yt/widget/my_assetes_images.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../translations.dart';

const coinPngs = {
  'btc': 'assets/images/icon_btc.png',
  'fm': 'assets/images/icon_fm.png',
  'usdt': 'assets/images/icon_usdt.png',
  'rent': 'assets/images/index_rent_icon.png',
  'cxc': 'assets/images/icon_cxc.png',
  'eth': 'assets/images/icon_eth.png',
  'etc': 'assets/images/icon_etc.png',
  'ltc': 'assets/images/icon_ltc.png',
  'bch': 'assets/images/icon_bch.png',
  'xrp': 'assets/images/icon_xrp.png',
  'eos': 'assets/images/icon_eos.png',
  'brc': 'assets/images/icon_brc.png',
  'exchange_otc': 'assets/images/icon-assets-change-otc.png'
};

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<AppIndexPic> appIndexPic;
  List<NoticeDTO> noticeDTO;
  Home home;
  PageData pageData;
  bool _isRefresh = false;
  RefreshController _controller = RefreshController();
  String language;
  Shader shader;

//  bool reinvestOrderState;  //提示框是否有去下單按鈕
////  String reinvestTitle;  //提示框title
////  String reinvestMsg;  //提示框内容

  @override
  bool get wantKeepAlive => true;

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> _refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isRefresh = true;
    prefs.setBool('isPullDown', true);

    await _loadingData();
    prefs.setBool('isPullDown', false);
    _isRefresh = false;

    _controller.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    _loadingData();
  }

  void showTip(String title, String content,bool reinvestOrderState, {List<String> button}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var now = new DateTime.now();
    String nowDate =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    var tipMerId = prefs.getInt('tipMerId');
    var tipToken = prefs.getString('tipToken');
    var tipDate = prefs.getString('tipDate');
    var tipOrderState = prefs.getBool("tipOrderState");
    var loginMerId = prefs.getInt('memberId');
    var loginToken = prefs.getString('token');
    if (loginToken != null) {
      if (tipMerId != loginMerId ||
          tipToken != loginToken ||
          tipOrderState != reinvestOrderState ||
          nowDate != tipDate) {
        Future.delayed(Duration(seconds: 1), () {
          MyDialog.accountTip(context, title, content, button: button);
          prefs.setInt("tipMerId", loginMerId);
          prefs.setString("tipToken", loginToken);
          prefs.setString("tipDate", nowDate);
          prefs.setBool("tipOrderState", reinvestOrderState);
        });
      }
    }
  }

  Future<void> _loadingData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String indexdata = _prefs.getString('index_data');
    language = _prefs?.getString('language') ?? 'zh';
    bool showloading = true;
    if (indexdata != null && !_isRefresh) {
      try {
        HomeModel _model = HomeModel.fromJson(jsonDecode(indexdata));
        setState(() {
          appIndexPic = _model.appIndexPic;
          noticeDTO = _model.noticeDTO;
          home = _model.home;
          pageData = _model.pageData;
        });
        showloading = false;
      } catch (e) {
        print("index jsonDecode error");
      }
    }
    try {
      if (!showloading) _prefs.setBool('isPullDown', true);
      HomeModel model = await HomeDao.fetch();
      if (!showloading) _prefs.setBool('isPullDown', false);
      setState(() {
        appIndexPic = model.appIndexPic;
        noticeDTO = model.noticeDTO;
        home = model.home;
        pageData = model.pageData;
      });

      if (model != null) {
        _prefs.setString('index_data', jsonEncode(model.toJson()));
      }
      if (model.reinvestTitle != null) {
        List<String> myButton = model.reinvestOrderState == true
            ? [
                Translations.of(context).text('show_tip_button_left'),
                Translations.of(context).text('show_tip_button_right')
              ]
            : [Translations.of(context).text('show_tip_button_left')];
        showTip(model.reinvestTitle, model.reinvestMsg, model.reinvestOrderState, button: myButton);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: SmartRefresher(
      controller: _controller,
      enablePullUp: false,
      header: GifLoading(),
      onRefresh: _refresh,
      child: ListView(
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/index_title_icon.png',
                  width: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    Translations.of(context).text('index_title'),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/coupon');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Image.asset(
                      'assets/images/index_coupn_icon.png',
                      width: 25,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 190,
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Swiper(
              key: UniqueKey(),
              itemCount: appIndexPic?.length ?? 0,
              autoplay: true,
              viewportFraction: 0.8,
              scale: 0.9,
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      child:
//                      FadeInImage.assetNetwork(
//                        placeholder: 'assets/images/home-loading.gif',
//                        image: appIndexPic[index].picUrl,
//                        fit: BoxFit.fill,
//                      ),
                          Image.network(appIndexPic[index].picUrl,
                              fit: BoxFit.cover),
                      onTap: () {
                        if (appIndexPic[index].clickUrl != null) {
                          if (appIndexPic[index].clickUrl.startsWith('http')) {
                            _launchURL(appIndexPic[index].clickUrl);
                          } else {
                            Navigator.of(context)
                                .pushNamed(appIndexPic[index].clickUrl);
                          }
                        } else {
                          Navigator.of(context).pushNamed('/index-pic',
                              arguments: appIndexPic[index].id);
                        }
                      },
                    ));
              },
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                  child: Image.asset(
                    'assets/images/index_notice_icon.png',
                    height: 16,
                  ),
                ),
                Expanded(
                  child: Swiper(
                    key: UniqueKey(),
                    itemCount: noticeDTO?.length ?? 0,
                    autoplay: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              noticeDTO[index].title,
                              style: TextStyle(
                                color: Color(0xffaaaaaa),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('/notice-detail',
                              arguments: noticeDTO[index].id);
                        },
                      );
                    },
                  ),
                ),
                GestureDetector(
                  child: Text(Translations.of(context).text('index_more'),
                      style: TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.pushNamed(context, '/notice');
                  },
                )
              ],
            ),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
            child: Swiper(
              key: UniqueKey(),
              itemCount: pageData?.rows?.length ?? 0,
              autoplay: true,
              pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                      color: Color.fromRGBO(200, 200, 200, 0.5),
                      activeColor: Colors.white,
                      size: 5.0,
                      activeSize: 6.0)),
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: pageData.rows[index].stock == 0 ? 0.6 : 1,
                        child: Container(
                          color: Color(0xff232836),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  MyAssetsImage(
                                    assetsUrl: Translations.of(context)
                                        .text('goods_icon_rent'),
                                    width: 20,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 8),
                                    child: Text(pageData.rows[index].goodsName),
                                  )
                                ],
                              ),
                              pageData.rows[index].isSuper == 1
                                  ? Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 8, 5),
                                                child: Text(
                                                    Translations.of(context).text(
                                                        'mining_hashrateOrder_onTheEarnings'),
                                                    // 月化收益率
                                                    style: TextStyle(
                                                        fontSize: 14))),
                                            Text(
                                              pageData
                                                  .rows[index].rentIncomeRate
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Color(0xffFFA61A),
                                                  fontSize: 28),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  8, 0, 0, 5),
                                              child: Text('%',
                                                  style:
                                                      TextStyle(fontSize: 14)),
                                            )
                                          ],
                                        ),
                                        Text(
                                          '${Translations.of(context).text('goods_price')}：${NumberFormat.formatDoubel(pageData.rows[index].price)}FM',
                                          // 每份售价
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xffaaaaaa)),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                              '${Translations.of(context).text('goods_fm_txt')} ${Translations.of(context).text('goods_stock')}:${pageData.rows[index].stock}${Translations.of(context).text('goods_stockNum')}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xffD7922E))),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 8, 5),
                                                child: Text(
                                                  Translations.of(context).text(
                                                      'component_indexGoods_unit'),
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                )),
                                            Text(
                                                '${NumberFormat.formatDoubel(pageData.rows[index].price)}',
                                                style: TextStyle(
                                                    color: Color(0xffFFA61A),
                                                    fontSize: 28)),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  8, 0, 0, 5),
                                              child: Text('USDT',
                                                  style:
                                                      TextStyle(fontSize: 14)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${Translations.of(context).text('mining_hashrateOrder_onTheEarnings')}：${pageData.rows[index].rentIncomeRate} %',
                                              style: TextStyle(fontSize: 14),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: RaisedButton(
                                    // color: Color(0xffD7922E),
                                    clipBehavior: Clip.hardEdge,
                                    onPressed: () async {
                                      if (pageData.rows[index].stock == 0) {
                                        Widget showwidget() {
                                          return Text(
                                            // 查看更过算力包
                                            Translations.of(context)
                                                .text('goods_viewmore'),
                                            style: TextStyle(
                                                color: Color(0xff999999)),
                                          );
                                        }

                                        ModelDialogs<String> _asstsdailog =
                                            await MyDialog.passwordDialog(
                                                context,
                                                ispwd: false,
                                                showWdiget: showwidget(),
                                                title: Translations.of(context)
                                                    .text(
                                                        'goods_sellOut')); //已售空
                                        if (_asstsdailog.type != 'ok') return;
                                        Navigator.pushNamed(
                                            context, '/navigator',
                                            arguments: 1);
                                      } else {
                                        Navigator.pushNamed(
                                            context, '/goods-detail',
                                            arguments: GoodsDetailsParams(
                                                goodsCode: pageData
                                                    .rows[index].goodsCode));
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 40,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          Translations.of(context)
                                              .text('goods_btn'), // 立即挖矿
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: <Color>[
                                            Color(0xffEDB94D),
                                            Color(0xffD2722E)
                                          ],
                                        ),
                                      ),
                                    ),

                                    ///圆角
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(22.0))),
                                    padding: const EdgeInsets.all(0.0),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Opacity(
                            opacity: pageData.rows[index].stock == 0 ? 0.6 : 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(6)),
                              child: Container(
                                width: 90,
                                height: 25,
                                alignment: Alignment.center,
                                color: Color(0xffFFA61A),
                                child: Text(
                                  Translations.of(context)
                                      .text('index_recommendation'),
                                  //'精品推荐'
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          )),
                      Positioned(
                        top: 40,
                        right: 20,
                        child: pageData.rows[index].stock == 0
                            ? MyAssetsImage(
                                assetsUrl: Translations.of(context)
                                    .text('goods_icon_sellOut'),
                                width: 76,
                              )
                            : Container(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            height: 100,
            margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  width: 160,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 10),
                  color: Color(0xff232836),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/icon_btc.png', width: 16),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(Translations.of(context)
                                .text('index_items1')), //BTC全网
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 2),
                        child: Text(
                          '${Translations.of(context).text('index_calculationPower')}:${home?.homeBtcHashrate}',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xffAAAAAA)),
                        ),
                      ),
                      Text(
                        '${Translations.of(context).text('index_diffence')}:${home?.homeBtcDifficulty}',
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xffAAAAAA)),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 160,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 10),
                  color: Color(0xff232836),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/icon_fm.png', width: 16),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(Translations.of(context)
                                .text('index_items2')), //FM矿场,
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 2),
                        child: Text(
                          '${Translations.of(context).text('index_totalHash')}:${home?.homeHashrateTotal}',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xffAAAAAA)),
                        ),
                      ),
                      Text(
                        '${Translations.of(context).text('index_fmBalance')}:${home?.homeHashrateBalance}',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xffAAAAAA)),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 160,
                  padding: EdgeInsets.all(10),
//                      margin: EdgeInsets.only(right: 10),
                  color: Color(0xff232836),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/index_fm_icon2.png',
                              width: 16),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(Translations.of(context)
                                .text('index_items3')), //BTC全网,
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 2),
                        child: Text(
                          '${Translations.of(context).text('index_fmtotal')}:${home?.homeFmTotal}',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xffAAAAAA)),
                        ),
                      ),
                      Text(
                        '${Translations.of(context).text('index_fmrelease')}:${home?.homeFmRewarded}',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xffAAAAAA)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Translations.of(context).text('index_items4'), //矿场分布
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Image.network(
                    'https://futuremine-product.s3.ap-northeast-1.amazonaws.com/map/map${language ?? 'zh'}.png')
              ],
            ),
          ),
          CoinPriceNow()
        ],
      ),
    ));
  }
}

class CoinPriceNow extends StatefulWidget {
  @override
  _CoinPriceNowState createState() => _CoinPriceNowState();
}

class _CoinPriceNowState extends State<CoinPriceNow> {
  List<HomeCoinModel> cionList;

  Future<void> _loadingCionList() async {
    try {
      List model = await HomeDao.coinFetch();
      setState(() {
        cionList = model.map((ele) {
          if (ele['coinType'] != null && ele['coinType'].isNotEmpty) {
            ele['pic'] = coinPngs[ele['coinType'].toLowerCase()];
          }
          return HomeCoinModel.fromJson(ele);
        }).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadingCionList();
  }

  Widget get _items {
    if (cionList == null)
      return Column(
        children: [],
      );
    List<Widget> items = [];
    cionList.forEach((element) {
      items.add(_item(element));
    });
    return Column(
      children: items,
    );
  }

  Widget _item(HomeCoinModel model) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(model.pic, width: 20),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  model.coinType.toString().toUpperCase(),
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            ],
          ),
          Text(
            model.coinPrice.toString(),
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Translations.of(context).text('index_market'), //币价行情
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 5,
          ),
          Text('(${Translations.of(context).text('index_market_desc')})',
              // 本平台币价定时更新，查看实时币价请前往各大交易所
              style: TextStyle(fontSize: 14, color: Color(0xff999999))),
          Container(
//                  height: 400,
            margin: EdgeInsets.only(top: 15),
            padding: EdgeInsets.fromLTRB(24, 14, 24, 24),
            color: Color(0xff232836),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Translations.of(context)
                          .text('assets_cb_coinType'), // '币种'
                      style: TextStyle(color: Color(0xff999999)),
                    ),
                    Text(
                      '${Translations.of(context).text('index_market_new_price')} (USDT)', //最新价
                      style: TextStyle(color: Color(0xff999999)),
                    ),
                  ],
                ),
                _items
              ],
            ),
          )
        ],
      ),
    );
  }
}
