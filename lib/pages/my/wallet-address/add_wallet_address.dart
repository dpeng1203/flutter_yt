import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_app_yt/dao/my_wallet.dart';
import 'package:flutter_app_yt/utils/coinIconPath.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../../translations.dart';

class MyAddWalletAddressPage extends StatefulWidget {
  final String pageTitle;

  MyAddWalletAddressPage({this.pageTitle});

  @override
  _MyAddWalletAddressPageState createState() => _MyAddWalletAddressPageState();
}

class _MyAddWalletAddressPageState extends State<MyAddWalletAddressPage> {
  String address;
  String remarks;
  String memo;
  String selectName;
  String selectCoinType;
  final _formKey = new GlobalKey<FormState>();

  void _onSubmit() async {
    final form = _formKey.currentState;
    form.save();

    if (widget.pageTitle == null && selectCoinType == null) {
      EasyLoading.showToast('请选择币种');
      return;
    }

    if (address == null || address == '' || address.length > 120) {
      EasyLoading.showToast(Translations.of(context)
          .text('my_address_edit_address_ph')); //请输入正确的钱包地址'
      return;
    }

    if (memo == '' || memo == null || memo.length > 10) {
      EasyLoading.showToast(Translations.of(context)
          .text('my_address_edit_tip_desc')); // 请输入10个字符以内的备注说明
      return;
    }
    try {
      var coinType =
          widget.pageTitle == null ? selectCoinType : widget.pageTitle;
      var model =
          await MyWalletListDao.addWallet(address, coinType, memo, remarks);
      print(model);
      if (model) {
        Navigator.pop(context, true);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TopBackIcon(),
        title: Text(widget.pageTitle != null
            ? '${Translations.of(context).text('my_address_add')}${widget.pageTitle.toUpperCase()}${Translations.of(context).text('my_address_edit_address')}'
            : Translations.of(context).text('title_my-wallet-address-edit')),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
            color: Color(0xff313644),
            child: Text(
              Translations.of(context).text(
                  'my_address_edit_top_tip'), //'请仔细核对，如绑定了错误的钱包地址将导致提币无效且资产无法找回！',
              style: TextStyle(fontSize: 14, color: Color(0xffFFA61A)),
            ),
          ),
          widget.pageTitle == null
              ? GestureDetector(
                  onTap: () {
                    _showModalBottomSheet();
                  },
                  child: Container(
                    height: 44,
                    margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
                    padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                    decoration: BoxDecoration(
                        color: Color(0xff232836),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(Translations.of(context)
                                .text('assets_outwalletTitle'))), //选择币种
                        Text(
                          selectName ?? '',
                          style: TextStyle(color: Color(0xffFFA61A)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                )
              : Container(),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 44,
                  margin: EdgeInsets.fromLTRB(12, 15, 12, 0),
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  decoration: BoxDecoration(
                      color: Color(0xff313644),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: TextFormField(
                    controller: TextEditingController(text: this.address),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Translations.of(context)
                          .text('my_address_edit_address_ph'), //'请输入正确的钱包地址',
                    ),
                    onSaved: (value) => address = value.trim(),
                  ),
                ),
                selectName?.trim() == 'XRP' ||
                        widget.pageTitle?.toUpperCase() == 'XRP'
                    ? Container(
                        height: 44,
                        margin: EdgeInsets.fromLTRB(12, 15, 12, 0),
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        decoration: BoxDecoration(
                            color: Color(0xff313644),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: TextFormField(
                          controller: TextEditingController(text: this.remarks),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: Translations.of(context)
                                .text('assets_outTag'), //'请输入地址标签',
                          ),
                          onSaved: (value) => remarks = value.trim(),
                        ),
                      )
                    : Container(),
                Container(
                  height: 44,
                  margin: EdgeInsets.fromLTRB(12, 15, 12, 15),
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  decoration: BoxDecoration(
                      color: Color(0xff313644),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: TextFormField(
                    controller: TextEditingController(text: this.memo),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: Translations.of(context).text(
                            'my_address_edit_desc_ph') //'请输入10个字符以内的备注说明',
                        ),
                    onSaved: (value) => memo = value.trim(),
                  ),
                ),
              ],
            ),
          ),
          Container(
//              height: 70,
            padding: EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: MaterialButton(
              child: Text(
                Translations.of(context).text('my_address_edit_save'), //'保存',
                style: TextStyle(fontSize: 16),
              ),
              minWidth: ScreenUtil().setWidth(440),
              height: 44,
              textColor: Colors.white,
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
//              borderSide: BorderSide(color: Colors.orange, width: 1),
              onPressed: () {
                _onSubmit();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future _showModalBottomSheet() {
    return showModalBottomSheet(
        backgroundColor: Color(0xff171D2A),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 250,
            child: ListView(
                children: coinTypes
                    .map((e) => GestureDetector(
                          onTap: () {
                            Navigator.pop(context, e);
                          },
                          child: Container(
                            color: Color(0xff232836),
                            height: 58,
                            margin: EdgeInsets.only(bottom: 1),
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              children: [
                                Image.asset(
                                  coinPngs[e['value']],
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(e['name']),
                                ),
                                e['name'] == selectName
                                    ? Icon(
                                        Icons.check,
                                        color: Color(0xffFFA61A),
                                      )
                                    : Text('')
                              ],
                            ),
                          ),
                        ))
                    .toList()),
          );
        }).then((e) {
      setState(() {
        selectName = e['name'];
        selectCoinType = e['value'];
      });
    });
  }
}
