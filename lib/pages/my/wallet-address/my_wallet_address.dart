import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:flutter_app_yt/dao/my_wallet.dart';
import 'package:flutter_app_yt/model/my_wallet_list.dart';
import 'package:flutter_app_yt/model/util_model.dart';
import 'package:flutter_app_yt/utils/coinIconPath.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../translations.dart';

class MyWalletAddressPage extends StatefulWidget {
  @override
  _MyWalletAddressPageState createState() => _MyWalletAddressPageState();
}

class _MyWalletAddressPageState extends State<MyWalletAddressPage> {
  List<MyWalletListModel> walletList = [];
  int state = 1;

  Future _loadingList() async {
    try {
      List model = await MyWalletListDao.fetch();
      setState(() {
        walletList =
            model.map((ele) => MyWalletListModel.fromJson(ele)).toList();
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
          title: Text(
              Translations.of(context).text('title_my-wallet-address-list')),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/add-wallet-address')
                    .then((value) {
                  if (value == true) {
                    _loadingList();
                  }
                });
              },
            )
          ],
        ),
        body: SmartRefresher(
            controller: _controller,
            enablePullUp: false,
            header: GifLoading(),
            onRefresh: _refresh,
            child: walletList.length == 0
                ? Center(
                    child: Text(
                        Translations.of(context).text('convers_list_noNum')))
                : ListView(
                    children: walletList.map((e) => _item(e)).toList(),
                  )));
  }

  Widget _item(MyWalletListModel e) {
    return Container(
      color: Color(0xff232836),
      margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      height: 70,
      child: Row(
        children: [
          coinPngs[e.coinType] != null
              ? Image.asset(
                  coinPngs[e.coinType],
                  width: 20,
                )
              : Container(
                  width: 20,
                ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.memo),
                SizedBox(
                  height: 5,
                ),
                Text(
                  e.address,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xffFFA61A)),
                )
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
              onTap: () async {
                Widget showwidget() {
                  return Text(
                    Translations.of(context)
                        .text('my_address_list_modal_title'),
                    style: TextStyle(
                        // 确认要删除此钱包地址吗？
                        color: Colors.black),
                  );
                }

                ModelDialogs<String> _asstsdailog =
                    await MyDialog.passwordDialog(context,
                        ispwd: false, showWdiget: showwidget());
                if (_asstsdailog.type != 'ok') return;
                bool model =
                    await MyWalletListDao.delWallet(e.coinType, e.address);
                print(model);
                if (model) {
                  _loadingList();
                }
              },
              child: Icon(Icons.delete))
        ],
      ),
    );
  }
}
