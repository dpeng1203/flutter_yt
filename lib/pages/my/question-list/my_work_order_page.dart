import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/dao/my_question_dao.dart';
import 'package:flutter_app_yt/model/my_work_order_model.dart';
import 'package:flutter_app_yt/utils/merInfo.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../translations.dart';

class MyWorkOrderPage extends StatefulWidget {
  @override
  _MyWorkOrderPageState createState() => _MyWorkOrderPageState();
}

class _MyWorkOrderPageState extends State<MyWorkOrderPage> {
  List<MyWorkOrderModel> workOrderList = new List<MyWorkOrderModel>();
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
      var memberId = await MerInfo.getMemId();
      List model = await MyQuestionDao.getMyWorkOrder(memberId);
      setState(() {
        if (model != null) {
          workOrderList = model.map((ele) {
            return MyWorkOrderModel.fromJson(ele);
          }).toList();
        } else {
          workOrderList = new List<MyWorkOrderModel>();
        }
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
        //我的工单
        title: Text(Translations.of(context).text('title_my-work-order-list')),
        actions: [
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/my-work-order-submit')
                  .then((data) {
                //data就等于true _loadingList()方法为重新获取数据
                if (data == true) {
                  _loadingList();
                }
              });
            },
          )
        ],
      ),
      body: SmartRefresher(
          controller: _controller,
          enablePullUp: false,
          header: GifLoading(),
          onRefresh: _refresh,
          child: workOrderList.length == 0
              ? Center(
                  child:
                      Text(Translations.of(context).text('convers_list_noNum')),
                )
              : ListView(
                  children: workOrderList
                      .map((e) => Container(
                            margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
                            padding: EdgeInsets.all(10),
                            color: Color(0xff232836),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        //工单号
                                        '${Translations.of(context).text('my_worder_list_order_num')}：${e.workOrderCode}',
                                        style:
                                            TextStyle(color: Color(0xffAAAAAA)),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(12, 2, 12, 4),
                                      decoration: BoxDecoration(
                                          color: Color(0xffffa61a),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      child: Text(
                                        e.state == 0
                                            ? Translations.of(context).text(
                                                'my_worder_list_status_process') //处理中
                                            //已处理：已作废
                                            : e.state == 1
                                                ? Translations.of(context).text(
                                                    'my_worder_list_status_done') //已处理
                                                : Translations.of(context).text(
                                                    'my_worder_list_status_void'), //已作废
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff262626)),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              width: 1,
                                              color: Color(0xff444C61)))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Translations.of(context).text(
                                            'my_worder_list_my_qustion'), //我的问题
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff999999)),
                                      ),
                                      Text(e.submitTime,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff999999)))
                                    ],
                                  ),
                                ),
                                Text(
                                  e.detail,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                )
                              ],
                            ),
                          ))
                      .toList(),
                )),
    );
  }
}
