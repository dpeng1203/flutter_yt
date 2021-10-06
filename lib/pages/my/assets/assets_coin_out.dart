import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:flutter_app_yt/common/numberFormat.dart';
import 'package:flutter_app_yt/common/tripleDes.dart';
import 'package:flutter_app_yt/dao/assets_dao.dart';
import 'package:flutter_app_yt/model/assets_model.dart';
import 'package:flutter_app_yt/model/coin_address_model.dart';
import 'package:flutter_app_yt/model/util_model.dart';
import 'package:flutter_app_yt/utils/coinIconPath.dart';
import 'package:flutter_app_yt/widget/count_down.dart';
import 'package:flutter_app_yt/widget/my_material_button.dart';
import 'package:flutter_app_yt/widget/show_bottom_coin.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../../translations.dart';

class AssetsCoinOutPage extends StatefulWidget {
  @override
  _AssetsCoinOutPageState createState() => _AssetsCoinOutPageState();
}

class _AssetsCoinOutPageState extends State<AssetsCoinOutPage> {
  List coinList; //可转出货币类型列表
  Map myCoinInfo;
  double outMin = 0; //最小提币数量
  double outFees = 0; //矿工费
  double outMax = 0;
  String amount = '0'; //可转出余额
  String outNum = '';
  String shortCode = '';
  String selectCoinName; //选择币种名称
  String selectCoinType; //选择币种类型
  String remarks;
  String address = '';
  List<CoinAddressModel> walletList;
  final _formKey = new GlobalKey<FormState>();

  List<AssetsModel> assetsList;

  Widget get _widgetAddress => Container(
        margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        color: Color(0xff232836),
        child: Column(
          children: [
            TextFormField(
              controller: TextEditingController(text: address),
              decoration: InputDecoration(
//                    border: InputBorder.none,
                //请输入/粘贴接收的钱包地址
                hintText:
                    Translations.of(context).text('assets_address_placeholder'),
              ),
              onSaved: (value) => address = value.trim(),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
              alignment: Alignment.topLeft,
              child: Text(
                //务必仔细核对钱包地址，错误将导致提币无效且资产无法找回！
                Translations.of(context).text('assets_address_desc'),
                style: TextStyle(fontSize: 14, color: Color(0xffFFA61A)),
              ),
            ),
            Column(
                children: walletList
                        ?.map((e) => e.coinType == selectCoinType
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            address = e.address;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 8),
                                          child: Text(
                                            e.address,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Color(0xffAAAAAA)),
                                          ),
                                        ),
                                      )),
                                ],
                              )
                            : Container())
                        ?.toList() ??
                    []),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                if (selectCoinName == null) {
                  //请选择币种
                  EasyLoading.showToast('请选择币种');
                  return;
                }
                Navigator.pushNamed(context, '/add-wallet-address',
                        arguments: selectCoinType)
                    .then((value) {
                  if (value == true) {
                    _getAddressList();
                  }
                });
              },
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    //选择/添加其他地址
                    child: Text(Translations.of(context)
                        .text('assets_add_other_address')),
                  ),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      );

  Widget get _widgetRemarks => selectCoinType?.toUpperCase() == 'XRP'
      ? Container(
          margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          color: Color(0xff232836),
          child: TextFormField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Translations.of(context)
                    .text('assets_inTagPlaceHolder'), //地址标签
                hintStyle: TextStyle(fontSize: 15),
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //标签
                  children: [
                    Text(Translations.of(context)
                        .text('assets_inTagPlaceHolder'))
                  ],
                )),
            onSaved: (value) => remarks = value.trim(),
          ),
        )
      : Container();

  Widget get _widgetOutNum => Container(
        margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        color: Color(0xff232836),
        child: TextFormField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
              border: InputBorder.none,
              //可转出余额
              hintText:
                  '${Translations.of(context).text('assets_outAfter')}：$amount\t',
              hintStyle: TextStyle(fontSize: 15),
              prefixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //转出数量
                children: [
                  Text(Translations.of(context).text('assets_outAmout'))
                ],
              )),
          onSaved: (value) => outNum = value.trim(),
        ),
      );

  get _widgetShort => Container(
        margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        color: Color(0xff232836),
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: InputBorder.none,
              //输入验证码
              hintText: Translations.of(context).text('assets_outinputPcode'),
              suffixIcon: CountDown()),
          onSaved: (value) => shortCode = value.trim(),
        ),
      ); // 我的货币列表信息，查看可转出余额

  @override
  void initState() {
    super.initState();
    _getOutCoinType();
    _getAddressList();
    _loadingList();
  }

  //可转出货币类型
  Future _getOutCoinType() async {
    try {
      var model = await AssetsDao.coinOutType();
      // 帅选可提币类型
      var arr = coinTypes.where((ele) {
        return model.keys.toList().contains(ele['value']);
      }).toList();
      setState(() {
        coinList = arr ?? coinTypes;
        myCoinInfo = model;
      });
    } catch (e) {
      print(e);
    }
  }

// 我的货币列表信息，查看可转出余额
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

  //可转出货币类型
  Future _getAddressList() async {
    try {
      List model = await AssetsDao.walletList();
      setState(() {
        walletList = model.map((e) => CoinAddressModel.fromJson(e)).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  Future _onSubmit() async {
    final form = _formKey.currentState;
    form.save();
    if (selectCoinType == null) {
      // 请选择币种
      EasyLoading.showToast(
          Translations.of(context).text('assets_outwalletTitle'));
      return;
    }

    if (address.length < 5) {
      //钱包地址长度大于5
      EasyLoading.showToast(
          Translations.of(context).text('assets_address_placeholder'));
      return;
    }

    if (outNum.isEmpty) {
      //请输入转出数量
      EasyLoading.showToast(
          Translations.of(context).text('assets_out_numInfo'));
      return;
    }

    if (double.parse(this.outNum) < this.outMin) {
      //转出数量大于最小提币数量
      EasyLoading.showToast(
          '${Translations.of(context).text('assets_out_numLimit')}($outMin)');
      return;
    }

    if (this.shortCode.length != 6) {
      //验证码为6位数
      EasyLoading.showToast(
          Translations.of(context).text('assets_out_rulerMobile'));
      return;
    }

    bool res = await AssetsDao.checkConfirmPasswordIsNull();
    if (!res) {
      ModelDialogs<String> _asstsdailog = await MyDialog.passwordDialog(context,
          //请输入密码
          ispwd: true,
          title: Translations.of(context).text('transaction_title'));
      if (_asstsdailog.type != 'ok') return;
      var _pw = TripleDesUtil.generateDes(_asstsdailog.message);
      var model = await AssetsDao.outSubmit(
          selectCoinType, outNum, address, shortCode, _pw, remarks);
      if (model['code'] != null && model['code'] == '2000') {
        Navigator.pushReplacementNamed(context, '/assets-success',
            arguments: 'assetsOut');
      }
    } else {
      //请先设置交易密码
      EasyLoading.showToast(
          Translations.of(context).text('assets_out_ruleredit'));
      Navigator.pushNamed(context, '/my-security-modify-password',
          arguments: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TopBackIcon(),
        title: Text(Translations.of(context).text('title_assets-coin-out')),
        //提币
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ShowBottomCoin(
              coinTypes: coinList,
              callBack: (val) {
                var myAmount;
                assetsList.forEach((element) {
                  if (element.coinType == val['value']) {
                    myAmount = element.amount;
                  }
                });
                setState(() {
                  selectCoinName = val['name'];
                  selectCoinType = val['value'];
                  remarks = val['remarks'];
                  outMin = myCoinInfo[selectCoinType]['outMin'];
                  outFees = myCoinInfo[selectCoinType]['outFees'];
                  outMax = myCoinInfo[selectCoinType]['outMax'];
                  amount = myAmount;
                });
              }),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _widgetAddress,
                _widgetRemarks,
                _widgetOutNum,
                Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.fromLTRB(0, 5, 12, 0),
                    //最小提币数量,矿工费
                    child: Text(
                      '${Translations.of(context).text('assets_outMinNum')}：${NumberFormat.formatDoubel(outMin)} ${(selectCoinType?.toUpperCase() ?? '')}，${Translations.of(context).text('assets_outMaxNum')}：${NumberFormat.formatDoubel(outMax)} ${(selectCoinType?.toUpperCase() ?? '')}，${Translations.of(context).text('assets_outfree')}：${NumberFormat.formatDoubel(outFees)} ${(selectCoinType?.toUpperCase() ?? '')}',
                      style: TextStyle(
                        color: Color(0xff888888),
                        fontSize: 12
                      ),
                    )),
                _widgetShort
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          MyMaterialButton(
            //提交申请
            text: Translations.of(context).text('assets_outBtnSubmit'),
            onTop: () {
              _onSubmit();
            },
          )
        ],
      ),
    );
  }
}
