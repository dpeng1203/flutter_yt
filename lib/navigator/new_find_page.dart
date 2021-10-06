import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_app_yt/Global.dart';
import 'package:flutter_app_yt/dao/news_dao.dart';
import 'package:flutter_app_yt/model/news_model.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewFindPage extends StatefulWidget {
  @override
  _NewFindPageState createState() => _NewFindPageState();
}

class _NewFindPageState extends State<NewFindPage>
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
        _rows = model.rows ?? [];
      });
    } catch (e) {
      print(e);
    }
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

  Widget _items(BuildContext context, int index) {
    return FindNewItem(h5Home: h5Home, e: _rows[index]);
  }

  Widget get _news => Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, bottom: 18, right: 5),
            width: ScreenUtil().setWidth(650),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/find-title.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '新闻快讯',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/find-new-list');
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(bottom: 2),
                    child: Text(
                      '更多',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 13,
                )
              ],
            ),
          ),
          Container(
            height: 350,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: _rows != null && _rows?.length != 0
                ? Scrollbar(
                    child: ListView.builder(
                        itemCount: _rows?.length ?? 0, itemBuilder: _items))
                : Center(
                    child: Text(
                      '暂无数据',
                      style: TextStyle(color: Color(0xffAAAAAA)),
                    ),
                  ),
          ),
        ],
      );

  // Widget get _newBusiness => Column(
  //       children: [
  //         Container(
  //           margin: EdgeInsets.only(top: 50),
  //           padding: EdgeInsets.only(left: 15, bottom: 18),
  //           width: ScreenUtil().setWidth(650),
  //           decoration: BoxDecoration(
  //             image: DecorationImage(
  //               image: AssetImage("assets/images/find-title.png"),
  //               fit: BoxFit.fitWidth,
  //             ),
  //           ),
  //           child: Text(
  //             '新型商务',
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  //           ),
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             Column(
  //               children: [
  //                 Image.asset(
  //                   'assets/images/fing-logo1.png',
  //                   width: 116,
  //                 ),
  //                 Text('美团外卖')
  //               ],
  //             ),
  //             Column(
  //               children: [
  //                 Image.asset('assets/images/find-logo2.png', width: 116),
  //                 Text('滴滴出行')
  //               ],
  //             )
  //           ],
  //         )
  //       ],
  //     );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '矿宝圈',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: false,
        backgroundColor: Color(0xff0f141d),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/find_bg.png'),
                fit: BoxFit.cover)),
        child: SmartRefresher(
          controller: _controller,
          enablePullUp: false,
          header: GifLoading(),
          onRefresh: _refresh,
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(750),
                    height: ScreenUtil().setWidth(640),
                    padding: EdgeInsets.fromLTRB(12, 5, 0, 0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/find_transfer.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Text(''),
                  ),
                  Positioned(
                    left: ScreenUtil().setWidth(85),
                    top: ScreenUtil().setWidth(132),
                    width: ScreenUtil().setWidth(295),
                    height: ScreenUtil().setWidth(175),
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/left-top.png'),
                          fit: BoxFit.fill,
                        )),
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/notice');
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '官方公告',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    '官方动向早知道',
                                    style: TextStyle(
                                        fontSize: 10, color: Color(0xffA9A9A9)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  Positioned(
                    right: ScreenUtil().setWidth(55),
                    top: ScreenUtil().setWidth(86),
                    width: ScreenUtil().setWidth(223),
                    height: ScreenUtil().setWidth(118),
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/right-top.png'),
                          fit: BoxFit.fill,
                        )),
                        child: GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              SizedBox(
                                width: ScreenUtil().setWidth(40),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: ScreenUtil().setWidth(50),
                                  ),
                                  Text(
                                    '矿享商城',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    '尽请期待',
                                    style: TextStyle(
                                        fontSize: 10, color: Color(0xffA9A9A9)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                  Positioned(
                    left: ScreenUtil().setWidth(74),
                    top: ScreenUtil().setWidth(411),
                    width: ScreenUtil().setWidth(316),
                    height: ScreenUtil().setWidth(137),
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/left-bottom.png'),
                          fit: BoxFit.fill,
                        )),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/find',
                                arguments: {'router': '$h5Home'});
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: ScreenUtil().setWidth(20),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: ScreenUtil().setWidth(68),
                                  ),
                                  Text(
                                    '新闻资讯',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    '随时掌握新情报',
                                    style: TextStyle(
                                        fontSize: 10, color: Color(0xffA9A9A9)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                  Positioned(
                    right: ScreenUtil().setWidth(53),
                    top: ScreenUtil().setWidth(358),
                    width: ScreenUtil().setWidth(226),
                    height: ScreenUtil().setWidth(163),
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/right-bottom.png'),
                          fit: BoxFit.fill,
                        )),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/find',
                                arguments: {'router': '$h5Home/#/activity'});
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: ScreenUtil().setWidth(66),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: ScreenUtil().setWidth(95),
                                  ),
                                  Text(
                                    '活动专区',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    '新老客户大回馈',
                                    style: TextStyle(
                                        fontSize: 10, color: Color(0xffA9A9A9)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
              _news,
              SizedBox(
                height: 50,
              )
//          _newBusiness,
            ],
          ),
        ),
      ),
    );
  }
}

class FindNewItem extends StatelessWidget {
  final String h5Home;
  final Rows e;

  FindNewItem({this.h5Home, this.e});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/find',
            arguments: {'router': '$h5Home/#/news-detail?id=${e.id}'});
      },
      child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/find-title-right.png',
                width: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/find-logo.png',
                    width: 55,
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text('|'),
                  ),
                  Text(
                    '未来新闻',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${e.publishTime?.split(' ')[0].split('-')[1]}月${e.publishTime?.split(' ')[0].split('-')[2]}日',
                    style: TextStyle(letterSpacing: 5, fontSize: 10),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      Color(0xff171D2A),
                      Color(0xffFFA61A),
                      Color(0xff171D2A),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
