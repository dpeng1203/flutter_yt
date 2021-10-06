import 'package:flutter/material.dart';
import 'package:flutter_app_yt/utils/coinIconPath.dart';

import '../translations.dart';

class ShowBottomCoin extends StatefulWidget {
  final List coinTypes;
  final callBack;
  final String coinName;

  ShowBottomCoin({@required this.coinTypes,this.callBack,this.coinName});

  @override
  _ShowBottomCoinState createState() => _ShowBottomCoinState();
}

class _ShowBottomCoinState extends State<ShowBottomCoin> {
  String selectName;
  String selectCoinType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showModalBottomSheet();
      },
      child: Container(
        height: 46,
        margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
        padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
        decoration: BoxDecoration(
            color: Color(0xff232836),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Row(
          children: [
            //选择币种
            Expanded(flex: 1, child: Text(Translations.of(context).text('assets_outwalletTitle'))),
            Text(
              selectName ?? widget.coinName ?? '',
              style: TextStyle(color: Color(0xffFFA61A)),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(Icons.arrow_drop_down)
          ],
        ),
      ),
    );
  }

  Future _showModalBottomSheet() {
    return showModalBottomSheet(
        backgroundColor: Color(0xff171D2A),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 250,
            child: ListView(
                children: widget.coinTypes
                    .map((e) => GestureDetector(
                          onTap: () {
                            Navigator.pop(context, e);
                          },
                          child: Container(
                            color: Color(0xff232836),
                            height: 58,
                            margin: EdgeInsets.only(bottom: 1),
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              children: [
                                Image.asset(
                                  coinPngs[e['value']],
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(e['name']),
                                ),
                                e['name'] == selectName
                                    ? Icon(
                                        Icons.check,
                                        color: Color(0xffFFA61A),
                                      )
                                    : Text('')
                              ],
                            ),
                          ),
                        ))
                    .toList()),
          );
        }).then((e) {
      if (e != null) {
        setState(() {
          selectName = e['name'];
          selectCoinType = e['value'];
          widget.callBack(e);
        });
      }
    });
  }
}
