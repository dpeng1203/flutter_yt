import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/src/easy_loading.dart';
import 'package:flutter_app_yt/common/tripleDes.dart';
import 'package:flutter_app_yt/dao/login_dao.dart';
import 'package:flutter_app_yt/widget/count_down.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../translations.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _userName = '';
  String _password;
  String _code;
  String _confirmPassword;
  bool check = false;
  String _inviteCode;
  final _formKey = new GlobalKey<FormState>();

  Widget _showMobileInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
          // 用户名
          labelText: Translations.of(context).text('login_userName'),
          //请输入用户名
          hintText:
              Translations.of(context).text('register_accountPlaceholder'),
        ),
        validator: (value) {
          RegExp reg = new RegExp(r'^\d{11}$');
          RegExp reg1 = new RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$');
          if (!reg.hasMatch(value) && !reg1.hasMatch(value)) {
            //请输入有效手机号
            return Translations.of(context)
                .text('register_toast_verifyAccount');
          }
          return null;
        },
        onChanged: (val) {
          setState(() {
            _userName = val.trim();
          });
        },
        onSaved: (value) => _userName = value.trim(),
      ),
    );
  }

  Widget _showCodeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            //验证码
            labelText: Translations.of(context).text('login_vCode'),
            //请输入验证码
            hintText:
                Translations.of(context).text('register_shortCodePlaceholder'),
            suffixIcon: CountDown(operateType: 'register', target: _userName)),
        validator: (value) {
          RegExp reg = new RegExp(r'^\d{6}$');
          if (!reg.hasMatch(value)) {
            //'请输入6位验证码'
            return Translations.of(context)
                .text('register_toast_verifyShortCode');
          }
          return null;
        },
        onSaved: (value) => _code = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput(String pw) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        obscureText: true,
        decoration: new InputDecoration(
          // 密码：确认密码
          labelText: pw == '_password'
              ? Translations.of(context).text('login_pwd')
              : Translations.of(context).text('login_cPwd'),
          // 请输入密码：请确认密码
          hintText: pw == '_password'
              ? Translations.of(context).text('register_pwdPlaceholder')
              : Translations.of(context).text('register_verifyPwdPlaceholder'),
        ),
        validator: (value) {
          if (pw == '_password') {
            if (value.length < 6) {
              //密码为6位或6位以上
              return Translations.of(context).text('register_toast_verifyPwd');
            }
          }
          if (pw == '_confirmPassword') {
            if (_password != _confirmPassword) {
              //输入密码不一致
              return Translations.of(context)
                  .text('register_toast_verifyPwdCheck');
            }
          }
          return null;
        },
        onSaved: (value) {
          if (pw == '_password') {
            _password = value.trim();
          } else {
            _confirmPassword = value.trim();
          }
        },
      ),
    );
  }

  Widget _showInvitteInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
          //邀请码
          labelText: Translations.of(context).text('login_iCode'),
          // 请输入邀请码
          hintText: Translations.of(context)
              .text('register_invitationCodePlaceholder'),
        ),
        onSaved: (value) => _inviteCode = value.trim(),
      ),
    );
  }

  Future<void> _onRegister() async {
    final form = _formKey.currentState;
    form.save();
    if (_formKey.currentState.validate()) {
      if (!check) {
        //请阅读并同意《会员服务协议》
        EasyLoading.showToast(
            Translations.of(context).text('register_toast_verifyAgreement'));
        return;
      }
      var _pw = TripleDesUtil.generateDes(_password);
      var model = await LoginDao.register(_userName, _code, _pw, _inviteCode);
      if (model == true) {
        //注册成功
        EasyLoading.showSuccess(
            Translations.of(context).text('register_toast_success'));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //注册
          title: Text(Translations.of(context).text('register_txt')),
          centerTitle: true,
          leading: TopBackIcon(),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
              child: Image.asset(
                'assets/images/logo2.png',
                width: 68,
                height: 82,
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.fromLTRB(55, 0, 55, 0),
                child: Column(
                  children: <Widget>[
                    _showMobileInput(),
                    _showCodeInput(),
                    _showPasswordInput("_password"),
                    _showPasswordInput("_confirmPassword"),
                    _showInvitteInput()
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(60, 30, 55, 0),
              child: OutlineButton(
                //注册
                child: Text(Translations.of(context).text('register_txt')),
                textColor: Colors.orange,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                borderSide: BorderSide(color: Colors.orange, width: 1),
                onPressed: () {
                  _onRegister();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 50, right: 40),
              child: Row(
                children: [
                  Checkbox(
                    value: check,
                    activeColor: Colors.orange,
                    onChanged: (bool val) {
                      setState(() {
                        check = !check;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register-deal');
                        },
                        child: Text(
                          //我同意会员服务协议
                          Translations.of(context).text('register_agreeTxt'),
                          softWrap: true,
                          style: TextStyle(color: Color(0xffAAAAAA)),
                        )),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
