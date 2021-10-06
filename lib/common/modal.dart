import 'package:flutter/material.dart';
import 'package:flutter_app_yt/model/util_model.dart';
//import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
//import 'package:flutter_app_yt/model/util_model.dart';

import '../translations.dart';

class MyDialog {
  /// 显示Dialog
  static Future<ModelDialogs<String>> passwordDialog(context,
      {bool ispwd = true,
      Widget showWdiget,
      String confirmtxt,
      String title,
      bool showCloseIcon = false,
      String cancletxt}) async {
    final controllerTextField = TextEditingController();
    if (confirmtxt == null)
      confirmtxt = Translations.of(context).text('mining_modalPwd_confirmText');
    if (title == null)
      title = Translations.of(context).text('convers_usdt_tip');
    if (cancletxt == null)
      cancletxt = Translations.of(context).text('goods_agreement_cancle');
    String _dialog = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.white,
          content: new SingleChildScrollView(
            child: Stack(
              children: [
                ListBody(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Container(
//                                height: 50,
                                alignment: Alignment.center,
                                // margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                                child: Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ispwd
                                  ? Container(
                                      height: 50,
                                      margin:
                                          EdgeInsets.fromLTRB(20, 10, 20, 20),
                                      decoration: new BoxDecoration(
                                        border: new Border.all(
                                            color: Color(0xffF1F1F1),
                                            width: 1.0),
                                      ),
                                      child: TextField(
                                          cursorColor: Colors.grey,
                                          obscureText: true,
                                          controller: controllerTextField,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          // 请输入交易密码
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              hintText: Translations.of(context)
                                                  .text(
                                                      'mining_modalPwd_pwdplaceholder'))),
                                    )
                                  : Container(
//                                alignment: Alignment.center,
//                                height: 80,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 15, 10, 30),
                                      child: showWdiget,
                                    ),
                            ],
                          ),
                        )),
                      ],
                    ),
                    Container(
                      // width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        // color: Colors.blueGrey,
                        border: Border(
                            top: BorderSide(
                                color: Color(0xffF1F1F1), width: 1.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context, 'cancle');
                                // check('quxiao log');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    // color: Color(0xffFFA61A),
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(5))),
                                alignment: Alignment.center,
                                child: Text(
                                  '$cancletxt',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                if (ispwd) {
                                  if (controllerTextField != null &&
                                      controllerTextField.text.length > 5) {
                                    Navigator.pop(context, 'ok');
                                  } else {
                                    // 确认密码输入错误，请重新输入
//                                    EasyLoading.showToast(
//                                        Translations.of(context).text(
//                                            'my_modify_pwd_tip_confrim_pwd'),
//                                        duration: Duration(milliseconds: 1000));
                                  }
                                } else {
                                  Navigator.pop(context, 'ok');
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffFFA61A),
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(5))),
                                alignment: Alignment.center,
                                child: Text('$confirmtxt'),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                if (showCloseIcon)
                  Positioned(
                    right: 4,
                    top: 4,
                    width: 30,
                    height: 30,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );

    return ModelDialogs<String>(
        type: _dialog, message: controllerTextField.text);

    // return  new ModelDialog<String>(type: _dialog, message: controllerTextField.text);
  }

  static Future<Null> accountTip(
      BuildContext context, String title, String content,
      {String imgUrl = 'assets/images/home_waring.png',
      List<String> button = const ['知道了']}) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  width: 1, color: Color(0xffFFA61A).withOpacity(0.6))),
          contentPadding: EdgeInsets.fromLTRB(15, 20, 15, 24),
          backgroundColor: Colors.black,
          content: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Image.asset(
                  imgUrl,
                  width: 60,
                ),
                SizedBox(
                  height: 16,
                ),
                new Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xffFFA61A),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                new Text(
                  content,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(
                  height: 28,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.28,
                      child: FlatButton(
                        color: Colors.black,
                        textColor: Colors.orange,
                        child: Text(button[0]),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                                width: 1,
                                color: Colors.orange.withOpacity(0.6))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    if (button.length == 2)
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.28,
                        child: FlatButton(
                          color: Colors.orange,
                          child: Text(button[1]),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/navigator',
                                arguments: 1);
                          },
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        );
      },
    ).then((val) {
      print(val);
    });
  }

  static Future showSingleButtonDialog(
    BuildContext context, {
    @required String title,
    @required String content,
    String buttonText = '确定',
  }) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.white,
          title: new Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 30),
                  child: new Text(content,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    height: 50,
                    alignment: Alignment.center,
                    child:
                        Text(buttonText, style: TextStyle(color: Colors.white)),
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
  }
}
