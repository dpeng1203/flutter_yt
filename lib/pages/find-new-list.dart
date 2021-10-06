import 'package:flutter/material.dart';
import 'package:flutter_app_yt/Global.dart';
import 'package:flutter_app_yt/dao/news_dao.dart';
import 'package:flutter_app_yt/model/news_model.dart';
import 'package:flutter_app_yt/navigator/new_find_page.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindNewList extends StatefulWidget {
  @override
  _FindNewListState createState() => _FindNewListState();
}

class _FindNewListState extends State<FindNewList> {
  NewsModel _news = new NewsModel();
  num page = 1;
  num pagesize = 12;
  ScrollController _scrollController = ScrollController();
  String h5Home = Global.appEnvironment.h5Home;

  Widget _items(BuildContext context, int index) {
    return FindNewItem(h5Home: h5Home, e: _news.rows[index]);
  }

  @override
  void initState() {
    super.initState();
    loadNews();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page < _news.pageCount) {
          page = page + 1;
          loadNews();
        }
        // print("daodil");
      }
    });
  }

  Future<void> loadNews() async {
    NewsModel model = await NewsDao.fetch(page: page, pageSize: pagesize);
    if (page == 1) {
      _news = model;
      _news.rows = model.rows ?? [];
    } else {
      _news.rows.addAll(model.rows);
    }
    setState(() {
      _news = _news;
    });
  }

  RefreshController _controller = RefreshController();

  Future<Null> _refresh() async {
    page = 1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPullDown', true);
    await loadNews();
    prefs.setBool('isPullDown', false);
    _controller.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: TopBackIcon(),
          // 算力包详情
          title: Text('新闻快讯'),
          elevation: 0.0,
        ),
        body: SmartRefresher(
          controller: _controller,
          enablePullUp: false,
          header: GifLoading(),
          onRefresh: _refresh,
          child: _news.rows != null && _news.rows?.length != 0
              ? ListView.builder(
                  controller: _scrollController,
                  itemBuilder: _items,
                  itemCount: _news.rows?.length ?? 0,
                )
              : Center(
                  child: Text('暂无数据',style: TextStyle(color: Color(0xffAAAAAA))),
                ),
        ));
  }
}
