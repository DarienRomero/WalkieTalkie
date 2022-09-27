import 'package:flutter/material.dart';

double mqHeigth(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.height * (percentage / 100);
}

double mqWidth(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.width * (percentage / 100);
}

String getTime(DateTime? time) {
  String timeStr = "";
  if (time == null) return "";
  if (time.hour < 10) {
    timeStr += '0';
    timeStr += time.hour.toString();
  } else {
    timeStr += time.hour.toString();
  }
  timeStr += ":";
  if (time.minute < 10) {
    timeStr += '0';
    timeStr += time.minute.toString();
  } else {
    timeStr += time.minute.toString();
  }
  return timeStr;
}
