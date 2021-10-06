import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:flutter_app_yt/dao/assets_dao.dart';
import 'package:flutter_app_yt/model/assets_coin_in_model.dart';
import 'package:flutter_app_yt/utils/coinIconPath.dart';
import 'package:flutter_app_yt/widget/show_bottom_coin.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../../translations.dart';

class AssetsCoinInPage extends StatefulWidget {
  @override
  _AssetsCoinInPageState createState() => _AssetsCoinInPageState();
}

class _AssetsCoinInPageState extends State<AssetsCoinInPage> {
  String selectCoinType = 'usdt';
  String address;
  String currentTag;
  List coinInList = [];

  @override
  void initState() {
    super.initState();
    coinInList = coinTypes
        .where((element) =>
    element['value'] != 'cxc' && element['value'] != 'brc')
        .toList();
    _loadingData();
  }

  Future _loadingData() async {
    try {
      AssetsCoinInModel model = await AssetsDao.assetsIn(selectCoinType);
      setState(() {
        address = model.address;
        currentTag = model.memberId.toString();
      });
    } catch (e) {
      setState(() {
        address = '';
      });
    }
//    if (selectCoinType == 'fm') {
//      Future.delayed(Duration(milliseconds: 300), () {
//        MyDialog.showSingleButtonDialog(context,
//            title: Translations.of(context).text('cion_in_tip_title'),//'注意 FM ERC-20暂停充值！'
//            content: Translations.of(context).text('cion_in_tip_content'),//期间因充值导致的资金损失由个人承担
//            buttonText: Translations.of(context).text('cion_in_tip_button'));//我已知晓
//      });
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TopBackIcon(),
        //充币
        title: Text(Translations.of(context).text('title_assets-coin-in')),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
            color: Color(0xff313644),
            //如因个人操作不慎转账到非平台钱包地址，所造成的损失由个人承担！
            child: Text(
              Translations.of(context).text('assets_inWarnMsg'),
              style: TextStyle(fontSize: 14, color: Color(0xffFFA61A)),
            ),
          ),
          ShowBottomCoin(
              coinTypes: coinInList,
              coinName: "USDT (ERC20)",
              callBack: (val) {
                setState(() {
                  selectCoinType = val['value'];
                });
                _loadingData();
              }),
          Container(
            decoration: BoxDecoration(
                color: Color(0xff232836),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
            padding: EdgeInsets.fromLTRB(15, 15, 15, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //请务必将**转到如下钱包地址
                Text(
                  '${Translations.of(context).text('assets_inMsgtip')} ${selectCoinType?.toUpperCase()} ${Translations.of(context).text('assets_inMsgtipAfter')}',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          address ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Color(0xffFFA61A)),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: address));
                        var text = Clipboard.getData(Clipboard.kTextPlain);
                        if (text != null) {
                          //复制成功
                          EasyLoading.showSuccess(
                              Translations.of(context).text('assets_inCopy'));
                        }
                      },
                      child: Image.asset(
                        'assets/images/ico-copy.png',
                        width: 18,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          if (selectCoinType == "eos" || selectCoinType == "xrp")
            Container(
              decoration: BoxDecoration(
                  color: Color(0xff232836),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
              padding: EdgeInsets.fromLTRB(15, 15, 15, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //请核对地址标签，若标签遗漏或错误将导致资丢失！
                  Text(
                    Translations.of(context).text('assets_inTag'),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            currentTag ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Color(0xffFFA61A)),
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: currentTag));
                          var text = Clipboard.getData(Clipboard.kTextPlain);
                          if (text != null) {
                            //复制成功
                            EasyLoading.showSuccess(
                                Translations.of(context).text('assets_inCopy'));
                          }
                        },
                        child: Image.asset(
                          'assets/images/ico-copy.png',
                          width: 18,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Image.asset('assets/images/index_notice_icon.png', width: 16),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Text(
                      Translations.of(context).text('assets_inMsg'),
                      style: TextStyle(color: Color(0xff888888), fontSize: 14),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
