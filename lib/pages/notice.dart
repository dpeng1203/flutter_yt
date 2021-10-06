import 'package:flutter/material.dart';
import 'package:flutter_app_yt/dao/notice_dao.dart';
import 'package:flutter_app_yt/model/notice_model.dart';
import 'package:flutter_app_yt/translations.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<NoticeModel> dataList;
  Iterable<NoticeModel> realStaList;
  Future<void> loadList() async {
    try {
      List model = await NoticeDao.fetch();
      setState(() {
        dataList = model.map((ele) {
          return NoticeModel.fromJson(ele);
        }).toList();

        realStaList = dataList.where((ele) {
          return ele.state == 0;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Widget get _items {
    if (realStaList == null)
      return Container(
        height: 800,
      );
    List<Widget> items = [];

    realStaList.forEach((model) {
      items.add(_item(model));
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  Widget _item(NoticeModel model) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff232836),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        key: UniqueKey(),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Container(
                      width: 180,
                      child: Text(model.title,
                          maxLines: 1,
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis),
                    )),
                Text(model.publishTime,
                    style: TextStyle(color: Color(0xffaaaaaa))),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 15),
              child: Text(
                model.detail.replaceAll(RegExp(r'[\n\s]'), ''),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 1.5, color: Color(0xffaaaaaa)),
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.5, //宽度
                    color: Color(0xff535A70), //边框颜色
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      Translations.of(context).text('my_notice_detail')), //查看详情
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Color(0xffaaaaaa),
                  )
                ],
              ),
            )
          ],
        ),
        onPressed: () {
          Navigator.of(context)
              .pushNamed('/notice-detail', arguments: model.id);
        },
      ),
    );
  }

  RefreshController _controller = RefreshController();
  Future<Null> _refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPullDown', true);
    await loadList();
    prefs.setBool('isPullDown', false);
    _controller.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    this.loadList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: TopBackIcon(),
          title: Text(Translations.of(context).text('my_notice_title')), // 官方公告
        ),
        body: Container(
            margin: EdgeInsets.only(top: 10),
            child: SmartRefresher(
              controller: _controller,
              enablePullUp: false,
              header: GifLoading(),
              onRefresh: _refresh,
              child: ListView(
                children: <Widget>[_items],
              ),
            )));
  }
}
