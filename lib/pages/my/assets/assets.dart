import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/dao/assets_dao.dart';
import 'package:flutter_app_yt/model/assets_model.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../translations.dart';

class AssetsPage extends StatefulWidget {
  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  List<AssetsModel> assetsList;
  final coinPngs = {
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

  Future _loadingList() async {
    try {
      List model = await AssetsDao.fetch();
      setState(() {
        assetsList = model.map((ele) => AssetsModel.fromJson(ele)).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  RefreshController _controller = RefreshController();

  Future<Null> _refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPullDown', true);
    await _loadingList();
    prefs.setBool('isPullDown', false);
    _controller.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    _loadingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: TopBackIcon(),
          title: Text(Translations.of(context).text('title_assets')),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/assets-set').then((value) {
                  if (value == true) {
                    _loadingList();
                  }
                });
              },
            )
          ],
        ),
        body: _bodyView);
  }

  Widget get _bodyView {
    List<Widget> items = [];
    assetsList?.forEach((element) {
      if (element.displayState != 0) {
        items.add(_item(element));
      }
    });
    return SmartRefresher(
        controller: _controller,
        enablePullUp: false,
        header: GifLoading(),
        onRefresh: _refresh,
        child: items.length == 0
            ? Center(
                child:
                    Text(Translations.of(context).text('assets_none_message')),
              )
            : ListView(
                children: items,
              ));
  }

  Widget _item(AssetsModel model) {
    return Container(
      color: Color(0xff232836),
      margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(coinPngs[model.coinType], width: 20),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  model.coinType.toString().toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          ),
          model.coinType != 'usdt'
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      model.amount,
                      style: TextStyle(fontSize: 15, color: Color(0xffFFA61A)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('≈ ${model.usdtAmountValue} USDT')
                  ],
                )
              : Text(
                  model.amount,
                  style: TextStyle(fontSize: 15, color: Color(0xffFFA61A)),
                )
        ],
      ),
    );
  }
}
