import 'package:flutter/material.dart';

class TopBackIcon extends StatelessWidget {
  final tap;
  TopBackIcon({this.tap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Icon(const IconData(0xe616, fontFamily: 'iconfont'))),
      onTap: () {
        if (this.tap == null) {
          Navigator.pop(context);
        } else {
          this.tap();
        }
      },
    );
  }
}
