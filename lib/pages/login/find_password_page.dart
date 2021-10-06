import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/src/easy_loading.dart';
import 'package:flutter_app_yt/common/tripleDes.dart';
import 'package:flutter_app_yt/dao/login_dao.dart';
import 'package:flutter_app_yt/widget/count_down.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../translations.dart';

class FindPasswordPage extends StatefulWidget {
  @override
  _FindPasswordPageState createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  String _code;
  String _newPassword;
  String _confirmPassword;
  final _formKey = new GlobalKey<FormState>();
  String _mobile = '';

  Future<void> _onSubmit() async {
    final form = _formKey.currentState;
    form.save();
    if (_formKey.currentState.validate()) {
      var _pw = TripleDesUtil.generateDes(_newPassword);
      var model = await LoginDao.findPassword(_mobile, _code, _pw);
      if (model == true) {
        //重置成功
        EasyLoading.showSuccess(
            Translations.of(context).text('find_p_rulerReset'));
        Navigator.pop(context);
      }
    }
  }

  Widget _showMobileInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 50.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
          //用户名
          labelText: Translations.of(context).text('login_userName'),
          //请输入手机号码或邮箱
          hintText: Translations.of(context).text('find_p_blurMobile'),
        ),
        validator: (value) {
          RegExp reg = new RegExp(r'^\d{11}$');
          RegExp reg1 = new RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$');
          if (!reg.hasMatch(value) && !reg1.hasMatch(value)) {
            //请输入手机号码或者邮箱
            return Translations.of(context).text('find_p_rulerMobile');
          }
          return null;
        },
        onChanged: (val) {
          setState(() {
            _mobile = val.trim();
          });
        },
        onSaved: (value) => _mobile = value.trim(),
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
            labelText: Translations.of(context).text('login_vCode'), //验证码
            hintText: Translations.of(context).text('find_p_blurYzm'), //请输入验证码
            suffixIcon: CountDown(operateType: 'findpwd', target: _mobile)),
        validator: (value) {
          RegExp reg = new RegExp(r'^\d{6}$');
          if (!reg.hasMatch(value)) {
            //请输入6位验证码
            return Translations.of(context).text('find_p_rulerCode');
          }
          return null;
        },
        onSaved: (value) => _code = value.trim(),
      ),
    );
  }

  Widget _showNewPasswordInput(String pw) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        obscureText: true,
        decoration: new InputDecoration(
          //新密码：确认新密码
          labelText: pw == '_newPassword'
              ? Translations.of(context).text('login_pwd')
              : Translations.of(context).text('login_cPwd'),
          //请输入新密码： 请确认新密码
          hintText: pw == '_newPassword'
              ? Translations.of(context).text('find_p_blurNewcode')
              : Translations.of(context).text('find_p_blurcodeCon'),
        ),
        validator: (value) {
          if (pw == '_newPassword') {
            if (value.length < 6) {
              //密码为6位或6位以上
              return Translations.of(context).text('find_p_rulerCodeLength');
            }
          }
          if (pw == '_confirmPassword') {
            if (_newPassword != _confirmPassword) {
              //输入密码不一致
              return Translations.of(context).text('find_p_rulerCodefirm');
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TopBackIcon(),
        title: Text(Translations.of(context).text('title_find-password')),
        //找回密码
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.fromLTRB(55, 0, 55, 0),
              child: Column(
                children: <Widget>[
                  _showMobileInput(),
                  _showCodeInput(),
                  _showNewPasswordInput("_newPassword"),
                  _showNewPasswordInput("_confirmPassword"),
                ],
              ),
            ),
          ),
          Container(
//              height: 70,
            padding: EdgeInsets.fromLTRB(85, 80, 85, 0),
            child: OutlineButton(
              child: Text(Translations.of(context).text('find_p_resetBtn')),
              //重置密码
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
