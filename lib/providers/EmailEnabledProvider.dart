
import 'package:flutter/material.dart';

class EmailEnabledProvider with ChangeNotifier{
  bool _isEmailAwarenessEnabled = false;

  bool get isEmailAwarenessEnabled => _isEmailAwarenessEnabled;

  void setisEmailAwarenessEnabled (bool isEnabled){
    _isEmailAwarenessEnabled = isEnabled;
    notifyListeners();
  }
}