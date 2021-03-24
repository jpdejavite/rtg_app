import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CustomToast {
  static final int timeShort = Toast.LENGTH_SHORT;
  static final int timeLong = Toast.LENGTH_LONG;

  static showToast({String text, BuildContext context, int time}) {
    Toast.show(text, context,
        duration: time == null ? Toast.LENGTH_LONG : time,
        gravity: Toast.BOTTOM);
  }
}
