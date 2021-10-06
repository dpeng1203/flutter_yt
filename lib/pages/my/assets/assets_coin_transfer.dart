import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:flutter_app_yt/common/numberFormat.dart';
import 'package:flutter_app_yt/common/tripleDes.dart';
import 'package:flutter_app_yt/dao/assets_dao.dart';
import 'package:flutter_app_yt/model/assets_model.dart';
import 'package:flutter_app_yt/model/assets_out_coin_type_model.dart';
import 'package:flutter_app_yt/model/util_model.dart';
import 'package:flutter_app_yt/utils/coinIconPath.dart';
import 'package:flutter_app_yt/widget/count_down.dart';
import 'package:flutter_app_yt/widget/my_material_button.dart';
import 'package:flutter_app_yt/widget/show_bottom_coin.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../../translations.dart';

class AssetsCoinTransferPage extends StatefulWidget {
  @override
  _AssetsCoinTransferPageState createState() => _AssetsCoinTransferPageState();
}

class _AssetsCoinTransferPageState extends State<AssetsCoinTransferPage> {
  List coinTransferList = [];
  String selectCoinType;
  String selectCoinName;
  double outMin = 0; //最小提币数量
  double outFees = 0; //矿工费
  String amount = '0'; //可转出余额
  String outId = '';
  String outNum = '';
  String shortCode = '';
  final _formKey = new GlobalKey<FormState>();
  List<AssetsOutCoinTypeModel> myCoinInfoList; //查看费率
  List<AssetsModel> assetsList;

  @override
  void initState() {
    super.initState();
    _loadingList();
    _getTransferCoinType();
  }

  //可转出货币类型
  Future _getTransferCoinType() async {
    try {
      List model = await AssetsDao.transferCoinList();
      List<AssetsOutCoinTypeModel> coinList =
          model.map((e) => AssetsOutCoinTypeModel.fromJson(e)).toList();
      // 帅选可转出类型
      var arr = [];
      coinTypes.forEach((ele) {
        coinList.forEach((element) {
          if (element.coinType == ele['value']) {
            arr.add(ele);
          }
        });
      });
      setState(() {
        coinTransferList = arr;
        myCoinInfoList = coinList;
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

  void _onSubmit() async {
    final form = _formKey.currentState;
    form.save();
    if (selectCoinType == null) {
      // 请选择币种
      EasyLoading.showToast(
          Translations.of(context).text('assets_outwalletTitle'));
      return;
    }

    if (outId.length < 4 || outId.length > 12) {
      //UID位4~12位数字
      EasyLoading.showToast(
          Translations.of(context).text('assets_receipt_placeholder'));
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
          ispwd: true,
          title: Translations.of(context).text('transaction_title')); //请输入密码
      if (_asstsdailog.type != 'ok') return;
      var _pw = TripleDesUtil.generateDes(_asstsdailog.message);
      var model = await AssetsDao.transferSubmit(
          outId, outNum, _pw, selectCoinType, shortCode);
      if (model['code'] != null && model['code'] == '2000') {
        Navigator.pushReplacementNamed(context, '/assets-success',
            arguments: 'transfer');
      }
    } else {
      //请先设置交易密码
      EasyLoading.showToast(
          Translations.of(context).text('assets_out_ruleredit'));
      Navigator.pushNamed(context, '/my-security-modify-password',
          arguments: 2);
    }
  }

  //收款ID
  Widget get _widgetOutId => Container(
        margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        color: Color(0xff232836),
        child: TextFormField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
              border: InputBorder.none,
              //请输入收款用户的UID
              hintText:
                  '${Translations.of(context).text('assets_receipt_placeholder')}\t',
              hintStyle: TextStyle(fontSize: 15),
              prefixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //收款ID
                children: [
                  Text('${Translations.of(context).text('assets_receipt')}ID')
                ],
              )),
          onSaved: (value) => outId = value.trim(),
        ),
      );

  Widget get _widgetOutTip => Container(
        margin: EdgeInsets.fromLTRB(12, 5, 12, 5),
        //仅支持转账至本平台注册用户，请仔细核对UID号，错误可能误转至他人账户
        child: Text(
          Translations.of(context).text('assets_receipt_desc'),
          style: TextStyle(color: Color(0xffFFA61A)),
        ),
      );

  //转出数量
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
                  Text(Translations.of(context).text('assets_receipt_count'))
                ],
              )),
          onSaved: (value) => outNum = value.trim(),
        ),
      );

  Widget get _widgetOutFee => Container(
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.fromLTRB(0, 5, 12, 0),
      child: Text(
        //最小提币数量,矿工费
        '${Translations.of(context).text('assets_tranferMinNum')}：${NumberFormat.formatDoubel(outMin)} ${(selectCoinType?.toUpperCase() ?? '')}，${Translations.of(context).text('assets_outfree')}：${NumberFormat.formatDoubel(outFees)} ${(selectCoinType?.toUpperCase() ?? '')}',
        style: TextStyle(
          color: Color(0xff888888),
        ),
      ));

  get _widgetShort => Container(
        margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        color: Color(0xff232836),
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: Translations.of(context).text('assets_outinputPcode'),
              //输入验证码
              suffixIcon: CountDown(
                operateType: 'transfer_out',
              )),
          onSaved: (value) => shortCode = value.trim(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TopBackIcon(),
        title: Text(Translations.of(context).text('title_transfer-accounts')),
        //转账
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ShowBottomCoin(
              coinTypes: coinTransferList,
              callBack: (val) {
                var _myAmount;
                assetsList.forEach((element) {
                  if (element.coinType == val['value']) {
                    _myAmount = element.amount;
                  }
                });
                var _outMin;
                var _outFees;
                myCoinInfoList.forEach((element) {
                  if (element.coinType == val['value']) {
                    _outMin = element.outMin;
                    _outFees = element.outFees;
                  }
                });
                setState(() {
                  selectCoinName = val['name'];
                  selectCoinType = val['value'];
                  outMin = _outMin;
                  outFees = _outFees;
                  amount = _myAmount;
                });
              }),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  _widgetOutId,
                  _widgetOutTip,
                  _widgetOutNum,
                  _widgetOutFee,
                  _widgetShort
                ],
              )),
          SizedBox(
            height: 50,
          ),
          MyMaterialButton(
            text: Translations.of(context).text('assets_outBtnSubmit'), //提交申请
            onTop: () {
              _onSubmit();
            },
          )
        ],
      ),
    );
  }
}
