import 'package:shared_preferences/shared_preferences.dart';

class MerInfo {
  static getMemId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt('memberId');
    } catch (e) {
      print(e);
    }
  }

  static getMemName() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('userName');
    } catch (e) {
      print(e);
    }
  }

  static getMemMobile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('mobile');
    } catch (e) {
      print(e);
    }
  }
}