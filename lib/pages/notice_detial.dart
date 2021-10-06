import 'package:flutter/material.dart';
import 'package:flutter_app_yt/dao/notice_detai_dao.dart';
import 'package:flutter_app_yt/model/notice_detail_model.dart';
import 'package:flutter_app_yt/translations.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

class NoticeDetailPage extends StatefulWidget {
  // 参数初始化
  final int id;
  NoticeDetailPage({this.id});

  @override
  _NoticeDetailPageState createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  NoticeDetailModel _content;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      NoticeDetailModel detail = await NoticeDetailDao.fetch(widget.id);
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
          child: Text(_content.detail,
              textAlign: TextAlign.left,
              style: TextStyle(color: Color(0xffC8C8C8), height: 2)),
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
        title: Text(
            Translations.of(context).text('title_my-notice-detail')), //官方公告详情
        elevation: 0.0,
      ),
      body: ListView(
          padding: EdgeInsets.all(15), children: [Container(child: getCon())]),
    );
  }
}
