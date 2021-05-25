import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateInMili(int dateInMili, String format) {
    if (dateInMili > 0) {
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateInMili);
      return DateFormat(format).format(dateTime);
    }

    return '';
  }

  static String formatDate(DateTime dateTime, String format) {
    if (dateTime != null) {
      return DateFormat(format).format(dateTime);
    }

    return '';
  }

  static String dateMonth(DateTime dateTime, BuildContext context) {
    if (dateTime != null) {
      Locale locale = Localizations.localeOf(context);
      DateFormat formatter = DateFormat.LLLL(locale.toString());
      return formatter.format(dateTime);
    }

    return '';
  }

  static String dateWeek(DateTime dateTime, BuildContext context) {
    if (dateTime != null) {
      Locale locale = Localizations.localeOf(context);
      DateFormat formatter = DateFormat.EEEE(locale.toString());
      return formatter.format(dateTime);
    }

    return '';
  }

  static String getMenuPlanningDayString(
      DateTime dateTime, BuildContext context) {
    String s = DateFormatter.formatDate(
        dateTime, AppLocalizations.of(context).menu_planning_date_format);
    return '$s ${DateFormatter.dateWeek(dateTime, context)}';
  }

  static List<String> weekDays() {
    return DateFormat.EEEE(Platform.localeName).dateSymbols.WEEKDAYS;
  }

  static int weekOfMonth(DateTime date) {
    DateTime firstDayOfMonth =
        DateTime.parse(DateFormat("yyyy-MM-01 HH:mm:ss").format(date));
    int dayOfMonth = int.parse(DateFormat("d").format(date));
    return ((dayOfMonth + firstDayOfMonth.weekday - 1) / 7).floor() + 1;
  }
}
