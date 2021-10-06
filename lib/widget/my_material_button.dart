import 'package:flutter/material.dart';

class MyMaterialButton extends StatelessWidget {

  final onTop;
  final String text;

  MyMaterialButton({Key key,this.onTop,this.text = '提交'}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(35, 20, 35, 0),
      child: MaterialButton(
        height: 50,
        child: Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
        textColor: Colors.white,
        color: Colors.orange,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)),
        onPressed: () {
          onTop();
        },
      ),
    );
  }
}
