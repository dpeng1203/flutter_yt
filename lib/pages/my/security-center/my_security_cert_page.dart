import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_app_yt/dao/my_security_dao.dart';
import 'package:flutter_app_yt/model/my_security_cert_model.dart';
import 'package:flutter_app_yt/widget/image_picker_widget.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../../translations.dart';

class MySecurityCertPage extends StatefulWidget {
  @override
  _MySecurityCertPageState createState() => _MySecurityCertPageState();
}

class _MySecurityCertPageState extends State<MySecurityCertPage> {
  // 定义 controller
//   String name;
  String certA;
  String certB;
  String certlive;
  int state = -1; // 0: 审核中，1：审核已通过，2：审核失败，-1：未提交审核
  String refuseReason = '';

  TextEditingController _inputController = TextEditingController();

  _onSubmit() async {
    var name = _inputController.text;
    if (name == null || name?.trim() == '') {
      //请填写姓名
      EasyLoading.showToast(Translations.of(context).text('my_cert_must_name'));
      return false;
    }
    if (certA == null || certB == null || certlive == null) {
      //请上传身份证照片
      EasyLoading.showToast(
          Translations.of(context).text('my_cert_must_upload'));
      return false;
    }
    var dataJson = {"certA": certA, "certB": certB, "certLive": certlive};
    String certData = jsonEncode(dataJson);
    print(certData);
    var model;
    if(state == 2) {
      model = await MySecurityDao.upDateCert(name, certData);
    }else{
      model = await MySecurityDao.addCert(name, certData);
    }
//    var model = await MySecurityDao.addCert(name, certData);
    print(model);
    print(state);
    if (model == true) {
      //已提交，请等候审核结果
      EasyLoading.showSuccess(
          Translations.of(context).text('my_cert_must_submited'));
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      MySecurityCertModel model = await MySecurityDao.getCertInfo();
      if (model == null) {
        return;
      }
      var certData = jsonDecode(model.certData);
      setState(() {
        _inputController.text = model.realName;
        state = model.state;
        refuseReason = model.refuseReason ?? '';
        if (certData != null && certData != '') {
          certA = certData['certA'];
          certB = certData['certB'];
          certlive = certData['certLive'];
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TopBackIcon(),
        title: Text(Translations.of(context).text('title_my-security-cert')),
        //身份认证
        centerTitle: true,
      ),
      body: state == 0 || state == 1
          ? Container(
              width: ScreenUtil().setWidth(750),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    padding: EdgeInsets.fromLTRB(23, 0, 23, 0),
                    decoration: BoxDecoration(
                        color: Color(0xff232836),
                        borderRadius: BorderRadius.all(Radius.circular(48))),
                    child: Image.asset(
                      'assets/images/cert_audting.png',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    //审核中：审核已通过
                    state == 0
                        ? Translations.of(context).text('my_cert_audting')
                        : Translations.of(context).text('my_cert_pass'),
                    style: TextStyle(fontSize: 15, color: Color(0xffAAAAAA)),
                  )
                ],
              ),
            )
          : ListView(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                  color: Color(0xff313644),
                  child: Text(
                    //警告：身份认证极为重要，认证通过后不再变更。为保障您的资产安全，请务必谨慎操作！
                    state == -1
                        ? Translations.of(context).text('my_cert_warning')
                        : '${Translations.of(context).text('my_cert_failed')}$refuseReason',
                    style: TextStyle(fontSize: 14, color: Color(0xffFFA61A)),
                  ),
                ),
                Container(
                  height: 44,
                  margin: EdgeInsets.fromLTRB(12, 15, 12, 15),
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  decoration: BoxDecoration(
                      color: Color(0xff313644),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      //请输入真实姓名
                      hintText: Translations.of(context)
                          .text('my_cert_name_placeholder'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(12, 10, 12, 20),
                  //请上传身份证正反面照片
                  child: Text(Translations.of(context).text('my_cert_tip')),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Color(0xff313644),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        width: ScreenUtil().setWidth(320),
                        height: 110,
                        child: ImagePickerWidget(
                          //身份证正面照片
                          title: Translations.of(context)
                              .text('my_cert_add_front'),
                          imagePath: certA ?? null,
                          callback: (val) {
                            setState(() {
                              certA = val;
                            });
                          },
                        )),
                    Container(
                        decoration: BoxDecoration(
                            color: Color(0xff313644),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        width: ScreenUtil().setWidth(320),
                        height: 110,
                        child: ImagePickerWidget(
                          //身份证反面照片
                          title:
                              Translations.of(context).text('my_cert_add_back'),
                          imagePath: certB ?? null,
                          callback: (val) {
                            setState(() {
                              certB = val;
                            });
                          },
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
                  //手持身份证照片
                  child: Text(Translations.of(context).text('my_cert_handler')),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            color: Color(0xff313644),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        width: ScreenUtil().setWidth(320),
                        height: 110,
                        child: ImagePickerWidget(
                          //手持身份证照片
                          title: Translations.of(context)
                              .text('my_cert_add_handler'),
                          imagePath: certlive ?? null,
                          callback: (val) {
                            setState(() {
                              certlive = val;
                            });
                          },
                        )),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: MaterialButton(
                    height: 44,
                    child: Text(
                      //提交审核
                      Translations.of(context).text('my_cert_add_submit'),
                      style: TextStyle(fontSize: 16),
                    ),
                    textColor: Colors.white,
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                    onPressed: () {
                      _onSubmit();
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
