import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../application.dart';
import '../../../translations.dart';

class SwitchLanguage extends StatefulWidget {
  @override
  _SwitchLanguageState createState() => _SwitchLanguageState();
}

class _SwitchLanguageState extends State<SwitchLanguage> {
  List items = [
    {
      'name': 'English',
      'key': 'en',
      'selected': false,
      'border-bottom': true,
    },
    {
      'name': '中文',
      'key': 'zh',
      'selected': true,
      'border-bottom': true,
    },
    {
      'name': '한글',
      'key': 'ko',
      'selected': false,
      'border-bottom': true,
    },
    {
      'name': '日本語',
      'key': 'ja',
      'selected': false,
      'border-bottom': false,
    }
  ];
  List<Widget> languages() {
    List<Widget> array = [];
    items.forEach((ele) {
      array.add(InkWell(
        onTap: () async {
          // 选择语言
          SharedPreferences prefs = await SharedPreferences.getInstance();
          applic.onLocaleChanged(new Locale(ele['key'], ''));
          prefs.setString('language', ele['key']);
          // Navigator.pop(context, ele['key']);
          Navigator.pushNamed(context, '/navigator', arguments: 3);
        },
        child: Container(
          height: 60,
          padding: EdgeInsets.fromLTRB(0, 15, 15, 15),
          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
          decoration: BoxDecoration(
              border: ele['border-bottom']
                  ? Border(
                      bottom: BorderSide(width: 0.5, color: Color(0xff444C61)))
                  : null),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              ele['name'],
              style: TextStyle(
                  fontSize: 16,
                  color: Color(ele['selected'] ? 0xffFFA61A : 0xffFFFFFF)),
            ),
            Offstage(
                offstage: !ele['selected'],
                child: Icon(
                  Icons.check,
                  color: Color(0xffFFA61A),
                )),
          ]),
        ),
      ));
    });
    return array;
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage = Translations.of(context).currentLanguage;
    items.forEach((element) {
      element['selected'] = false;
      if (element['key'] == currentLanguage) {
        element['selected'] = true;
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TopBackIcon(),
        title: Text(Translations.of(context).text('title_change-language')),
        elevation: 0.0,
      ),
      body: Container(
        height: 240,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Color(0xff232836)),
        child: Column(children: languages()),
      ),
    );
  }
}
