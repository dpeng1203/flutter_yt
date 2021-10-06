import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_app_yt/dao/my_question_dao.dart';
import 'package:flutter_app_yt/utils/merInfo.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../../translations.dart';

class MyWorkOrderSubmitPage extends StatefulWidget {
  @override
  _MyWorkOrderSubmitPageState createState() => _MyWorkOrderSubmitPageState();
}

class _MyWorkOrderSubmitPageState extends State<MyWorkOrderSubmitPage> {
  TextEditingController _inputController = TextEditingController();

  void _onSubmit() async {
    try {
      var _detail = _inputController.text;
      if (_detail.isNotEmpty) {
        var memberId = await MerInfo.getMemId();
        var model = await MyQuestionDao.getMyWorkOrderSubmit(memberId, _detail);
        if (model) {
          Navigator.of(context).pop(true);
        }
      } else {
        //请输入问题描述
        EasyLoading.showToast(
            Translations.of(context).text('my_worder_submit_tip_desc'));
      }
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
        //提交反馈
        title:
            Text(Translations.of(context).text('title_my-work-order-submit')),
      ),
      body: ListView(
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
            //请输入问题描述
            child: Text(Translations.of(context).text('my_worder_submit_desc')),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            color: Color(0xff232836),
            child: TextField(
              controller: _inputController,
              maxLines: 8,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  //请尽可能描述清楚问题，以便客服快速解决
                  hintText:
                      Translations.of(context).text('my_worder_submit_desc_ph'),
                  hintStyle: TextStyle(fontSize: 12)),
//              onChanged: (value) {
//                setState(() {
//                  _inputController.text = value.trim();
//                });
//              },
            ),
          ),
          Container(
//              height: 70,
            padding: EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: MaterialButton(
              child: Text(
                Translations.of(context)
                    .text('my_worder_submit_desc_submit'), //提交反馈
                style: TextStyle(fontSize: 16),
              ),
              minWidth: ScreenUtil().setWidth(440),
              height: 44,
              textColor: Colors.white,
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
//              borderSide: BorderSide(color: Colors.orange, width: 1),
              onPressed: () {
                _onSubmit();
              },
            ),
          ),
        ],
      ),
    );
  }
}
