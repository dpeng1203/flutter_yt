import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_app_yt/common/tripleDes.dart';
import 'package:flutter_app_yt/dao/my_security_dao.dart';
import 'package:flutter_app_yt/utils/merInfo.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../../translations.dart';

class MyModifyPasswordPage extends StatefulWidget {
  final int type; // 1: 修改登录密码，2：修改交易密码
  MyModifyPasswordPage({this.type});

  @override
  _MyModifyPasswordPageState createState() => _MyModifyPasswordPageState();
}

class _MyModifyPasswordPageState extends State<MyModifyPasswordPage> {
  String _code;
  String _newPassword;
  String _confirmPassword;
  final _formKey = new GlobalKey<FormState>();
  String _mobile;
  bool flag = true;

  //定义变量
  Timer _timer;

  //倒计时数值
  var countdownTime = 0;

  //倒计时方法
  startCountdown() {
    countdownTime = 60;
    final call = (timer) {
      setState(() {
        if (countdownTime < 1) {
          _timer.cancel();
        } else {
          countdownTime -= 1;
        }
      });
    };
    //Timer.periodic 为创造一个重复的倒计时对象
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  @override
  void initState() {
    super.initState();
    _getMemMobile();
  }

  Future<void> _getMemMobile() async {
    var _myMobile = await MerInfo.getMemMobile();
    setState(() {
      _mobile = _myMobile;
    });
  }

  Future<void> getCode() async {
    try {
      flag = false;
      var _modityType = widget.type == 1 ? 'modifypwd' : 'modifyconfirmpwd';
      var model = await MySecurityDao.getCode(_mobile, _modityType);
      flag = true;
      print(model.toString());
      if (model == true) {
            startCountdown();
            //已发送，请在5分钟内使用
            EasyLoading.showSuccess(
                Translations.of(context).text('assets_out_sendedInfo'));
          }
    } catch (e) {
      print(e);
      flag = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  Future<void> _onSubmit() async {
    final form = _formKey.currentState;
    form.save();
    if (_formKey.currentState.validate()) {
      print(_code);
      print(_newPassword);
      print(_confirmPassword);
      var _pw = TripleDesUtil.generateDes(_newPassword);
      var model;
      if (widget.type == 1) {
        model = await MySecurityDao.resetPassword(_code, _pw, _mobile);
      } else if (widget.type == 2) {
        model = await MySecurityDao.resetConfirmPassword(_code, _pw, _mobile);
      }
      if (model == true) {
        //修改成功
        EasyLoading.showSuccess(
            Translations.of(context).text('my_modify_pwd_tip_success'));
        Navigator.pop(context);
      }
    }
  }

  Widget _showCodeInput() {
    return TextFormField(
      maxLines: 1,
//        keyboardType: TextInputType.emailAddress,
      autofocus: false,
//        style: TextStyle(fontSize: 12),
      decoration: new InputDecoration(
//            labelText: Translations.of(context).text('login_vCode'),
          //验证码
          hintText: Translations.of(context).text('my_modify_pwd_input_code'),
          //请输入验证码
          suffixIcon: GestureDetector(
            onTap: () {
              if (countdownTime == 0 && flag == true) {
                getCode();
              }
            },
            child: Container(
              width: 90,
//                padding: EdgeInsets.fromLTRB(8, 1, 8, 0),
              margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: Text(
                  //*秒后重新获取 ： 获取验证码
                  countdownTime > 0
                      ? "${countdownTime}s${Translations.of(context).text('find_p_resend')}"
                      : Translations.of(context).text('find_p_getYzm'),
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
              ),
            ),
          )),
      validator: (value) {
        RegExp reg = new RegExp(r'^\d{6}$');
        if (!reg.hasMatch(value)) {
          //请输入6位验证码
          return Translations.of(context).text('my_modify_pwd_tip_code');
        }
        return null;
      },
      onSaved: (value) => _code = value.trim(),
    );
  }

  Widget _showNewPasswordInput(String pw) {
    return TextFormField(
      maxLines: 1,
      autofocus: false,
      obscureText: true,
      decoration: new InputDecoration(
        // 请输入6位验证码 ： 请确认新密码
        hintText: pw == '_newPassword'
            ? Translations.of(context).text('my_modify_pwd_input_new_pwd')
            : Translations.of(context).text('my_modify_pwd_input_confirm_pwd'),
      ),
      validator: (value) {
        if (pw == '_newPassword') {
          if (value.length < 6) {
            //密码为6位或6位以上
            return Translations.of(context).text('my_modify_pwd_tip_pwd');
          }
        }
        if (pw == '_confirmPassword') {
          if (_newPassword != _confirmPassword) {
            //输入密码不一致
            return Translations.of(context)
                .text('my_modify_pwd_tip_confrim_pwd');
          }
        }
        return null;
      },
      onSaved: (value) {
        if (pw == '_newPassword') {
          _newPassword = value.trim();
        } else {
          _confirmPassword = value.trim();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TopBackIcon(),
        //修改登录密码：修改交易密码
        title: Text(widget.type == 1
            ? Translations.of(context).text('title_my-security-modify-password')
            : Translations.of(context)
                .text('title_my-security-modify-confirm-password')),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.fromLTRB(65, 0, 65, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 60,
                  ),
                  Text(Translations.of(context).text('login_vCode')), //验证码
                  _showCodeInput(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(Translations.of(context)
                      .text('my_modify_pwd_new_pwd')), //新密码
                  _showNewPasswordInput("_newPassword"),
                  SizedBox(
                    height: 20,
                  ),
                  Text(Translations.of(context)
                      .text('my_modify_pwd_confirm_pwd')), //确认新密码
                  _showNewPasswordInput("_confirmPassword"),
                ],
              ),
            ),
          ),
          Container(
//              height: 70,
            padding: EdgeInsets.fromLTRB(85, 80, 85, 0),
            child: OutlineButton(
              //修改密码
              child: Text(
                  Translations.of(context).text('my_modify_pwd_modify_pwd')),
              textColor: Colors.orange,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              borderSide: BorderSide(color: Colors.orange, width: 1),
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
