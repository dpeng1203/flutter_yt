import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/dao/assets_dao.dart';
import 'package:flutter_app_yt/model/assets_model.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../../translations.dart';

class AssetsSetPage extends StatefulWidget {
  @override
  _AssetsSetPageState createState() => _AssetsSetPageState();
}

class _AssetsSetPageState extends State<AssetsSetPage> {
  List<AssetsModel> assetsList;
  List list = List.generate(Random().nextInt(20) + 10, (i) => 'More Item$i');
  int state = 1;

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

  @override
  void initState() {
    super.initState();
    _loadingList();
  }

  Future _loadingList() async {
    try {
      List model = await AssetsDao.fetch();
      if (model.length > 0) {
        setState(() {
          assetsList = model.map((ele) => AssetsModel.fromJson(ele)).toList();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _submitOrder() async {
    List arr = assetsList
        .asMap()
        .keys
        .map((index) => {
              "coinType": assetsList[index].coinType,
              "displayState": assetsList[index].displayState,
              "displayOrder": index
            })
        .toList();
    try {
      bool res = await AssetsDao.updateDisplayOrder(arr);
      if (res == true) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TopBackIcon(),
        title: Text(Translations.of(context).text('title_assets-set')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              _submitOrder();
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 60),
            child: ReorderableListView(
              children: assetsList?.map((m) => _item(m))?.toList() ?? [],
              onReorder: _onReorder,
            ),
          ),
          _top
        ],
      ),
    );
  }

  Widget get _top {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  state = 1;
                });
              },
              child: Container(
                width: 72,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: state == 1 ? Color(0xffFFA61A) : Colors.transparent,
                    border: Border.all(color: Color(0xffFFA61A), width: 1),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5))),
                child: Text(Translations.of(context).text('assets_set_show')),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  state = 2;
                });
              },
              child: Container(
                width: 72,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: state == 2 ? Color(0xffFFA61A) : Colors.transparent,
                    border: Border.all(color: Color(0xffFFA61A), width: 1),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        topRight: Radius.circular(5))),
                child: Text(Translations.of(context).text('assets_set_sort')),
              ),
            ),
          ],
        ));
  }

  // Widget get _bodyView {
  //   List<Widget> items = [];
  //   assetsList?.forEach((element) {
  //     items.add(_item(element));
  //   });
  //   return Column(
  //     children: items,
  //   );
  // }

  _onReorder(int oldIndex, int newIndex) {
    print('oldIndex: $oldIndex , newIndex: $newIndex');
    setState(() {
      if (newIndex == assetsList.length) {
        newIndex = assetsList.length - 1;
      }
      var item = assetsList.removeAt(oldIndex);
      assetsList.insert(newIndex, item);
    });
  }

  Widget _item(AssetsModel model) {
    return Container(
      key: ObjectKey(model.id),
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
          state == 1
              ? CupertinoSwitch(
                  value: model.displayState == 1 ? true : false,
                  activeColor: Color(0xffFFA61A),
                  onChanged: (bool v) {
                    setState(() {
                      model.displayState = v ? model.displayState = 1 : 0;
                    });
                  },
                )
              : Icon(Icons.format_list_bulleted),
        ],
      ),
    );
  }
}
