import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future setSignInStatus({bool status})async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('signedIn', status);
  }
  Future setIsBackStatus({bool status})async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBack', status);
  }
  Future <dynamic> getSignInStatus () async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('signedIn');
  }
  Future <dynamic> getIsBackStatus () async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isBack');
  }
}