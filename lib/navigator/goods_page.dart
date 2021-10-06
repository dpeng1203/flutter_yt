import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_particle_bg/flutter_particle_bg.dart';
import 'package:flutter_app_yt/common/NumberFormat.dart';
import 'package:flutter_app_yt/dao/goods_dao.dart';
import 'package:flutter_app_yt/model/goods_model.dart';
import 'package:flutter_app_yt/model/goods_models.dart';
import 'package:flutter_app_yt/widget/my_assetes_images.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../translations.dart';

class GoodsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translations.of(context).text('title_goods')), // 挖矿宝
        automaticallyImplyLeading: false,
      ),
      body: GoodsTab(
        coinName: 'btc',
        packType: '1,2,4',
        coinType: 'pow',
      ),
    );
  }
}

class GoodsTab extends StatefulWidget {
  final String coinName;
  final String packType;
  final String coinType;

  GoodsTab({this.coinName, this.packType, this.coinType});

  @override
  _GoodsTabState createState() => _GoodsTabState();
}

class _GoodsTabState extends State<GoodsTab>
    with AutomaticKeepAliveClientMixin {
  List<Rows> goodList;
  final List powTabs = [
    {"coinType": "BTC", "index": 0},
    {"coinType": "ETH", "index": 1},
    {"coinType": "ETC", "index": 2},
    {"coinType": "LTC", "index": 3},
    {"coinType": "BCH", "index": 4}
  ];

  String coinName = 'btc';
  String packType = '1,2,4';
  RefreshController _controller = RefreshController();

  Future<Null> _refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPullDown', true);
    await _loadingData();
    prefs.setBool('isPullDown', false);
    _controller.refreshCompleted();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    coinName = widget.coinName;
    packType = widget.packType;
    _loadingData();
  }

  Future<void> _loadingData() async {
    try {
      GoodsModel model =
          await GoodsDao.fetch(coinName, packType, isNeedLoading: false);
      setState(() {
        goodList = model.rows;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget get _items {
    if (goodList == null)
      return Container(
        height: 800,
      );
    List<Widget> items = [];
    goodList.forEach((model) {
      items.add(_item(model));
    });
    return Column(
      children: items,
    );
  }

  Widget _item(Rows model) {
    return Stack(
      children: [
        Opacity(
          opacity: model.stock == 0 ? 0.7 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 35,
                height: 2,
                decoration: ShapeDecoration(
                    color: model.stock == 0 ? Color(0xffA9A9A9) : Color(0xffFEA719).withOpacity(0.6),
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2)))),
                margin: EdgeInsets.only(right: 10, top: 15),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: ShapeDecoration(
                    shape: BeveledRectangleBorder(
                        side: BorderSide(
                            width: 0.5,
                            color: model.stock == 0 ? Color(0xffA9A9A9) : Color(0xffFEA719).withOpacity(0.6)),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)))
//
                    ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        MyAssetsImage(
                          assetsUrl:
                              Translations.of(context).text('goods_icon_rent'),
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                  model.goodsName,
                                  style: TextStyle(color: model.stock == 0 ? Color(0xffA9A9A9) : Color(0xffFFC11C)),
                                ),
                              ),
                              model.packType == 2
                                  ? Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 2),
//                      color: Color(0xffFFC11C),
                                      decoration: BoxDecoration(
                                          color: model.stock == 0 ? Color(0xffA9A9A9) : Color(0xffFFC11C),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      child: Text(
                                          Translations.of(context)
                                              .text('goods_experience'), // 体验
                                          style: TextStyle(fontSize: 12)),
                                    )
                                  : Text('')
                            ],
                          ),
                        ),
                        Text(
                            '${model.stock} ${Translations.of(context).text('goods_stockNum')}')
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    widget.packType == '3'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Translations.of(context)
                                        .text('goods_rate'), //月化收益率
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xffAAAAAA)),
                                  ),
                                  Container(
                                    height: 40,
                                    child: Center(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            model.rentIncomeRate.toString(),
                                            style: TextStyle(
                                                fontSize: 22,
                                                color:model.stock == 0 ? Color(0xffA9A9A9) : Color(0xffFFC11C)),
                                          ),
                                          Text(' %',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: model.stock == 0 ? Color(0xffA9A9A9) : Colors.white,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (model.unit.isNotEmpty)
                                Column(
                                  children: [
                                    Text(
                                      Translations.of(context).text(
                                          'component_goodsListBuy_sigleHashRate'),
                                      //单份合约算力
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xffAAAAAA)),
                                    ),
                                    Container(
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          model.unit,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    Translations.of(context).text(
                                        'component_goodsListBuy_unitPrice'), //单份金额
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xffAAAAAA)),
                                  ),
                                  Container(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        '${NumberFormat.formatDoubel(model.price)} FM',
                                        style: TextStyle(
                                            fontSize: 12, color: model.stock == 0 ? Color(0xffA9A9A9) : Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Translations.of(context).text(
                                        'component_goodsListBuy_unitPrice'), //单份金额
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xffAAAAAA)),
                                  ),
                                  Container(
                                    height: 40,
                                    child: Center(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${NumberFormat.formatDoubel(model.price)}',
                                            style: TextStyle(
                                                fontSize: 22,
                                                color:model.stock == 0 ? Color(0xffA9A9A9) : Color(0xffFFC11C)),
                                          ),
                                          Text(
                                            ' USDT',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color:model.stock == 0 ? Color(0xffA9A9A9) : Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (model.unit.isNotEmpty)
                                Column(
                                  children: [
                                    Text(
                                      Translations.of(context).text(
                                          'component_goodsListBuy_sigleHashRate'),
                                      //单份合约算力
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xffAAAAAA)),
                                    ),
                                    Container(
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          model.unit,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:model.stock == 0 ? Color(0xffA9A9A9) : Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    Translations.of(context)
                                        .text('goods_rate'), //月化收益率
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xffAAAAAA)),
                                  ),
                                  Container(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                          '${model.rentIncomeRate.toString()} %',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:model.stock == 0 ? Color(0xffA9A9A9) : Colors.white,
                                          )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 1, color: Color(0xff32394C)))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              model.coinType.indexOf('FM') > 0
                                  ? Container(
                                      padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                                      margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: model.stock == 0 ? Color(0xffA9A9A9) : Color(0xffFFC11C)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3))),
                                      child: Text(
                                        Translations.of(context).text(
                                            'goods_fm_Recommended'), //精品推荐
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: model.stock == 0 ? Color(0xffA9A9A9) : Color(0xffFFC11C)),
                                      ),
                                    )
                                  : Container(),
                              Container(
                                padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                                margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: model.stock == 0 ? Color(0xffA9A9A9) : Color(0xffFFC11C)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                                child: Text(
                                  model.coinType,
                                  style: TextStyle(
                                      fontSize: 13, color: model.stock == 0 ? Color(0xffA9A9A9) : Color(0xffFFC11C)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                                margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: model.stock == 0 ? Color(0xffA9A9A9) : Color(0xffFFC11C)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                                child: Text(
                                  Translations.of(context).text(
                                      'component_goodsListBuy_stimulateFm'),
                                  //享有FM激励
                                  style: TextStyle(
                                      fontSize: 11, color: model.stock == 0 ? Color(0xffA9A9A9) : Color(0xffFFC11C)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              Translations.of(context)
                                  .text('component_goodsListBuy_excavation'),
                              //'开挖时间：即时开挖'
                              style: TextStyle(
                                  color: Color(0xffAAAAAA), fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 55,
          right: 10,
          left: 10,
          child: model.stock == 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Color(0xff444C61).withOpacity(0),
                              Color(0xff444C61).withOpacity(1),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Text(
                        Translations.of(context).text('sold_out'),
                        style: TextStyle(color: Color(0xff7E8B9E)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Color(0xff444C61).withOpacity(1),
                              Color(0xff444C61).withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Text(''),
        ),
        Positioned.fill(child: InkWell(
          onTap: () {
            if (model.stock == 0) return;
            Navigator.pushNamed(context, '/goods-detail',
                arguments: GoodsDetailsParams(goodsCode: model.goodsCode));
          },
        ))
      ],
    );
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: MooooooBackground(
        pointcolor: Colors.white.withOpacity(0.4),
        linecolor: Colors.white.withOpacity(0.4),
        distancefar: 80.0,
        pointspeed: 0.5,
        bgimg: AssetImage('assets/images/sky_bg.png'),
        backgroundcolor: Theme.of(context).scaffoldBackgroundColor,
        child: SmartRefresher(
          controller: _controller,
          enablePullUp: false,
          header: GifLoading(),
          onRefresh: _refresh,
          child: ListView(
            children: [
              _items,
            ],
          ),
        ),
      ),
    );
  }
}
