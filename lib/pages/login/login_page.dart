import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_particle_bg/flutter_particle_bg.dart';
import 'package:flutter_app_yt/Global.dart';
import 'package:flutter_app_yt/common/tripleDes.dart';
import 'package:flutter_app_yt/dao/login_dao.dart';
import 'package:flutter_app_yt/model/login_model.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application.dart';
import '../../translations.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _userID;
  String _password;
  String langKey = 'zh'; //中文：zh,英文：en,韩文：ja,日文：ja
  final _formKey = new GlobalKey<FormState>();

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
//        keyboardType: TextInputType.emailAddress,
        autofocus: false,
//        style: TextStyle(fontSize: 12),
        decoration: new InputDecoration(
//            border: InputBorder.none,
          hintText: Translations.of(context).text('login_blurUsername'),
//            icon: new Icon(
//              Icons.phone,
//              color: Colors.grey,
//            )
        ),
        validator: (value) {
          RegExp reg = new RegExp(r'^\d{11}$');
          RegExp reg1 =
              new RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$');
          if (!reg.hasMatch(value) && !reg1.hasMatch(value)) {
            return Translations.of(context).text('login_blurUsername');
          }
          return null;
        },
        onSaved: (value) => _userID = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        obscureText: true,
        decoration: new InputDecoration(
//            border: InputBorder.none,
          hintText: Translations.of(context).text('login_blurPwd'),
//          icon: new Icon(
//            Icons.lock,
//            color: Colors.grey,
//          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return Translations.of(context).text('login_blurPwd');
          }
          return null;
        },
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  void _onLogin() {
    final form = _formKey.currentState;
    form.save();
    if (_formKey.currentState.validate()) {
      print(_userID);
      print(_password);
      _loadingData(_userID.trim(), _password.trim());
    }
  }

  Future<void> _loadingData(String user, String password) async {
    try {
      var ciphertext = TripleDesUtil.generateDes(password);
      LoginModel model = await LoginDao.fetch(user, ciphertext);
      print(model);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', model.token);
      prefs.setString('logoPath', model.logoPath);
      prefs.setInt('memberId', model.memberId);
      prefs.setString('userName', model.userName);
      prefs.setString('mobile', model.mobile);
      prefs.setBool('amountIsShow', true);
      Navigator.pushReplacementNamed(context, '/navigator');
    } catch (e) {
      print(e);
    }
  }

  Future<void> _changeLang(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    applic.onLocaleChanged(new Locale(lang, ''));
    prefs.setString('language', lang);
    setState(() {
      langKey = lang;
    });
  }

  Future<void> _getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      langKey = prefs.getString('language') ?? 'zh';
    });
  }

  @override
  initState() {
    super.initState();
    _getLang();
  }

  Future _openModalBottomSheet() async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('开发环境'),
                  onTap: () {
                    Navigator.pop(context, 'dev');
                  },
                ),
                ListTile(
                  title: Text('测试环境'),
                  onTap: () {
                    Navigator.pop(context, 'test');
                  },
                ),
              ],
            ),
          );
        });
    Global.changeEnvironment(option);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/navigator', (route) => false,
              arguments: 0);
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              leading: TopBackIcon(
                tap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/navigator', (route) => false,
                      arguments: 0);
                },
              ),
              title: Text(Translations.of(context).text('login_btnLogin')),
              centerTitle: true,
            ),
            body: MooooooBackground(
              pointcolor: Colors.white.withOpacity(0.4),
              linecolor: Colors.white.withOpacity(0.4),
              distancefar: 80.0,
              pointspeed: 0.5,
              bgimg: AssetImage('assets/images/sky_bg.png'),
              backgroundcolor: Theme.of(context).scaffoldBackgroundColor,
              child: ListView(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _changeLang('en');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('EN',
                                style: TextStyle(
                                  color: langKey == 'en'
                                      ? Colors.orange
                                      : Colors.white,
                                )),
                          ),
                        ),
                        Text('/'),
                        GestureDetector(
                          onTap: () {
                            _changeLang('zh');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('中',
                                style: TextStyle(
                                  color: langKey == 'zh'
                                      ? Colors.orange
                                      : Colors.white,
                                )),
                          ),
                        ),
                        Text('/'),
                        GestureDetector(
                          onTap: () {
                            _changeLang('ko');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('한',
                                style: TextStyle(
                                  color: langKey == 'ko'
                                      ? Colors.orange
                                      : Colors.white,
                                )),
                          ),
                        ),
                        Text('/'),
                        GestureDetector(
                          onTap: () {
                            _changeLang('ja');
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5.0, 5, 15, 5),
                            child: Text('日',
                                style: TextStyle(
                                  color: langKey == 'ja'
                                      ? Colors.orange
                                      : Colors.white,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 30),
                    child: Image.asset(
                      'assets/images/logo2.png',
                      width: 80,
                      height: 100,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(55, 0, 55, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                              alignment: Alignment.topLeft,
                              child: Text(Translations.of(context)
                                  .text('login_userName'))),
                          _showEmailInput(),
                          Container(
                              alignment: Alignment.topLeft,
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 0.0),
                              child: Text(
                                  Translations.of(context).text('login_pwd'))),
                          _showPasswordInput(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 90,
                    padding: EdgeInsets.fromLTRB(65, 40, 65, 0),
                    child: OutlineButton(
                      child:
                          Text(Translations.of(context).text('login_btnLogin')),
                      textColor: Colors.orange,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45)),
                      borderSide: BorderSide(color: Colors.orange, width: 1),
                      onPressed: () {
                        _onLogin();
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(65, 20, 65, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              Translations.of(context).text('login_register'),
                              style: TextStyle(color: Color(0xffAAAAAA)),
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/find-password');
                          },
                          child: Text(
                            Translations.of(context).text('login_findPwd'),
                            style: TextStyle(color: Color(0xffAAAAAA)),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      if (Global.appEnvironment.environment != 'pro') {
                        _openModalBottomSheet();
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 100,
                    ),
                  )
                ],
              ),
            )));
  }
}
