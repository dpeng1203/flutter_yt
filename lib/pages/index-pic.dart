import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
// import 'package:flutter_html/style.dart';
import 'package:flutter_app_yt/dao/index_pic_dao.dart';
import 'package:flutter_app_yt/model/index_pic_model.dart';
import 'package:flutter_app_yt/translations.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

class IndexPicPage extends StatefulWidget {
  final int id;
  IndexPicPage({this.id});

  @override
  _IndexPicPageState createState() => _IndexPicPageState();
}

class _IndexPicPageState extends State<IndexPicPage> {
  IndexPicModel _content;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      IndexPicModel detail = await IndexPicDao.fetch(widget.id);
      setState(() {
        _content = detail;
      });
    } catch (e) {
      print(e);
    }
  }

  getCon() {
    if (_content == null) {
      return Container(
        height: 800,
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(_content.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Text(_content.publishTime,
              style: TextStyle(color: Color(0xff999999))),
        ),
        Container(
          margin: EdgeInsets.only(top: 35),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Html(
              data: """${_content.detail}""",
              style: {
                'html': Style(
                  fontSize: FontSize(13),
                )
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TopBackIcon(),
        title:
            Text(Translations.of(context).text('title_app-index-pic')), //官方活动
        elevation: 0.0,
      ),
      body: ListView(
          padding: EdgeInsets.all(15), children: [Container(child: getCon())]),
    );
  }
}
