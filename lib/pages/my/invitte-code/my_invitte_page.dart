import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_app_yt/dao/my_invitte_dao.dart';
import 'package:flutter_app_yt/model/my_invitte_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../translations.dart';

class MyInvittePage extends StatefulWidget {
  @override
  _MyInvittePageState createState() => _MyInvittePageState();
}

class _MyInvittePageState extends State<MyInvittePage> {

  Future _loadingList() async {
    try {
      //1.请求的单独配置
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var lanuage = prefs.getString('language') ?? 'zh';
      MyInvitteModel model = await MyInvitteDao.fetch();
      model.lanuage = lanuage;
      return model;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TopBackIcon(),
        centerTitle: true,
        //我的邀请码
        title: Text(Translations.of(context).text('title_my-invitte-code')),
      ),
      body: FutureBuilder(
        future: _loadingList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Text('');
            case ConnectionState.done:
              return _bodyView(snapshot.data);
            default:
              return const Text('');
          }
        },
      ),
    );
  }

  Widget _bodyView(MyInvitteModel model) {
    return Container(
      width: ScreenUtil().setWidth(750),
      child: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          //专属邀请码
          Text(
            Translations.of(context).text('my_invCode_title'),
            style: TextStyle(color: Color(0xffFFA61A), fontSize: 22),
          ),
          Text(
            model.lanuage == 'en' ? '' : 'My invitation code',
            style: TextStyle(color: Color(0xffFFA61A)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  model.inviteCode.replaceAll('', ' '),
                  style: TextStyle(fontSize: 28, color: Color(0xffFFA61A)),
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: model.inviteCode));
                    var text = Clipboard.getData(Clipboard.kTextPlain);
                    if (text != null) {
                      showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: EdgeInsets.all(0),
                            backgroundColor: Colors.white,
                            title: new Text(
                              Translations.of(context)
                                  .text('my_invCode_copy_success'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: new SingleChildScrollView(
                              child: new ListBody(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Text(
                                        Translations.of(context)
                                            .text('my_invCode_copy_content'),
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 12, 0, 15),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  width: 1,
                                                  color: Colors.black38))),
                                      child: Center(
                                        child: Text(
                                            Translations.of(context)
                                                .text('my_invCode_OK'),
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ).then((val) {
                        print(val);
                      });
                      //已复制
//                      EasyLoading.showSuccess(Translations.of(context).text('assets_inCopy'));
                    }
                  },
                  child: Image.asset(
                    'assets/images/ico-copy.png',
                    width: 18,
                  ),
                )
              ],
            ),
          ),
          //还未登陆？ 二维码用来载入矿场
          Text(
            Translations.of(context).text('my_invCode_tip1'),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          //还未分享？ 邀请码即时启动挖矿
          Text(
            model.lanuage == 'en'
                ? ''
                : Translations.of(context).text('my_invCode_tip2'),
            style: TextStyle(color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(105, 60, 105, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Color(0xffFFA61A), width: 1),
                          left:
                              BorderSide(color: Color(0xffFFA61A), width: 1))),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Color(0xffFFA61A), width: 1),
                          right:
                              BorderSide(color: Color(0xffFFA61A), width: 1))),
                )
              ],
            ),
          ),
          Container(
            child: Image.memory(
              base64.decode(model.inviteImage.split(',')[1]),
              width: ScreenUtil().setWidth(270), //设置宽度
              fit: BoxFit.fill, //填充
              gaplessPlayback: true, //防止重绘
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(105, 0, 105, 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0xffFFA61A), width: 1),
                          left:
                              BorderSide(color: Color(0xffFFA61A), width: 1))),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0xffFFA61A), width: 1),
                          right:
                              BorderSide(color: Color(0xffFFA61A), width: 1))),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
