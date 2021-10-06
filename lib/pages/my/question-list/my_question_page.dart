import 'package:flutter/material.dart';
import 'package:flutter_app_yt/dao/my_question_dao.dart';
import 'package:flutter_app_yt/model/my_question_model.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../translations.dart';

class MyQuestionPage extends StatefulWidget {
  @override
  _MyQuestionPageState createState() => _MyQuestionPageState();
}

class _MyQuestionPageState extends State<MyQuestionPage> {
  List<MyQuestionModel> questionList = [];
  RefreshController _controller = RefreshController();
  Future<Null> _refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPullDown', true);
    await _loadingList();
    prefs.setBool('isPullDown', false);
    _controller.refreshCompleted();
  }

  @override
  void initState() {
    _loadingList();
    super.initState();
  }

  Future<void> _loadingList() async {
    try {
      List model = await MyQuestionDao.fetch();
      setState(() {
        questionList = model.map((ele) {
          return MyQuestionModel.fromJson(ele);
        }).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TopBackIcon(),
        centerTitle: true,
        //my_qusiton_list问题清单
        title: Text(Translations.of(context).text('my_qusiton_list')),
        actions: [
          IconButton(
            icon: Icon(
              Icons.assignment,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/my-work-order');
            },
          )
        ],
      ),
      body: SmartRefresher(
          controller: _controller,
          enablePullUp: false,
          header: GifLoading(),
          onRefresh: _refresh,
          child: ListView(
              padding: EdgeInsets.only(top: 10),
              children: questionList
                  .asMap()
                  .keys
                  .map((index) => Container(
                        color: Color(0xff232836),
                        margin: EdgeInsets.only(bottom: 2),
                        child: ExpansionTile(
                          title: Text(
                            '${index + 1}. ${questionList[index].title}',
                            style: TextStyle(color: Colors.orange),
                          ),
                          backgroundColor: Color(0xff232836),
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.fromLTRB(35, 0, 20, 10),
                              child: Text(questionList[index].detail),
                            )
                          ],
                          initiallyExpanded: false,
                        ),
                      ))
                  .toList())),
    );
  }
}
