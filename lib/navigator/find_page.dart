import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/Global.dart';
import 'package:flutter_app_yt/dao/news_dao.dart';
import 'package:flutter_app_yt/model/news_model.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindPage extends StatefulWidget {
  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage>
    with AutomaticKeepAliveClientMixin {
  List<Rows> _rows;
  String h5Home = Global.appEnvironment.h5Home;
  RefreshController _controller = RefreshController();

  @override
  bool get wantKeepAlive => true;

  Future<void> loadNews() async {
    try {
      NewsModel model = await NewsDao.fetch();
      setState(() {
        _rows = model.rows;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _topItem(
      String tit, String viaTit, String iconUrl, Function callBack) {
    return Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(0xff232836),
        ),
        child: FlatButton(
          padding: EdgeInsets.all(10),
          key: UniqueKey(),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(tit,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          height: 2)),
                  Text(viaTit,
                      style: TextStyle(
                          fontSize: 13, color: Color(0xffaaaaaa), height: 1.5)),
                ],
              ),
              Image.asset(iconUrl, width: 42),
            ],
          ),
          onPressed: () {
            callBack();
          },
        ));
  }

  Widget get _items {
    if (_rows == null)
      return Container(
        height: 800,
      );
    List<Widget> items = [];
    _rows.forEach((model) {
      items.add(_item(model));
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  Widget _item(Rows model) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 15, 12, 10),
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5, //宽度
              color: Color(0xff32394C), //边框颜色
            ),
          ),
        ),
        child: FlatButton(
          key: UniqueKey(),
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 500,
                margin: EdgeInsets.only(bottom: 15),
                child: Text(
                  model.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                width: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/goods_bg.png",
                    image: model.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '来源：' + model.terrace,
                      style: TextStyle(fontSize: 13, color: Color(0xffaaaaaa)),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Icon(Icons.remove_red_eye,
                              size: 18, color: Color(0xffaaaaaa)),
                        ),
                        Text(
                          model.pageviews.toString(),
                          style:
                              TextStyle(fontSize: 13, color: Color(0xffaaaaaa)),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/find',
                arguments: {'router': '$h5Home/#/news-detail?id=${model.id}'});
          },
        ));
  }

  Future<Null> _refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPullDown', true);
    await loadNews();
    prefs.setBool('isPullDown', false);
    _controller.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    this.loadNews();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('矿宝圈'),
          automaticallyImplyLeading: false,
        ),
        body: SmartRefresher(
            controller: _controller,
            enablePullUp: false,
            header: GifLoading(),
            onRefresh: _refresh,
            child: ListView(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
                    height: 180,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      children: <Widget>[
                        _topItem(
                            '官方公告', '官方动态早知道', 'assets/images/find-notice.png',
                            () {
                          Navigator.of(context).pushNamed('/notice');
                        }),
                        _topItem(
                            '新闻资讯', '随时掌握新情报', 'assets/images/find-news.png',
                            () {
                          print(h5Home);
                          Navigator.of(context).pushNamed('/find',
                              arguments: {'router': '$h5Home'});
                        }),
                        _topItem('活动专区', '新老客户大回馈',
                            'assets/images/find-activity.png', () {
                          Navigator.of(context).pushNamed('/find',
                              arguments: {'router': '$h5Home/#/activity'});
                        }),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 25, 12, 10),
                  child: Text('最新播报',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 2)),
                ),
                _items,
              ],
            )));
  }
}
