import 'package:flutter/material.dart';
import 'package:rtg_app/widgets/view_recipe_label_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreparationTimeLabelText extends StatelessWidget {
  final int preparationTime;

  PreparationTimeLabelText({this.preparationTime});

  @override
  Widget build(BuildContext context) {
    String label = AppLocalizations.of(context).preparation_time;
    String text = PreparationTimeLabelText.getPreparationTimeText(
        preparationTime, false, context);
    return ViewRecipeLabelText(
      label: label,
      text: text,
    );
  }

  static String getPreparationTimeText(
      int time, bool abreviate, BuildContext context) {
    if (time < 2) {
      return '$time ${(abreviate ? AppLocalizations.of(context).minute_abbreviation : AppLocalizations.of(context).minute)}';
    } else if (time < 60) {
      return '$time ${(abreviate ? AppLocalizations.of(context).minute_abbreviation : AppLocalizations.of(context).minutes)}';
    } else if (time < 60 * 24) {
      double hours = time.toDouble() / 60;
      if (hours % 1 == 0) {
        if (hours < 2) {
          return '${hours.toInt()} ${(abreviate ? AppLocalizations.of(context).hour_abbreviation : AppLocalizations.of(context).hour)}';
        }
        return '${hours.toInt()} ${(abreviate ? AppLocalizations.of(context).hour_abbreviation : AppLocalizations.of(context).hours)}';
      } else {
        return PreparationTimeLabelText.getPreparationTimeText(
                hours.floor() * 60, true, context) +
            " " +
            PreparationTimeLabelText.getPreparationTimeText(
                time - (hours.floor() * 60), true, context);
      }
    } else if (time < 7 * 60 * 24) {
      double days = time.toDouble() / (60 * 24);
      if (days % 1 == 0) {
        if (days < 2) {
          return '${days.toInt()} ${(abreviate ? AppLocalizations.of(context).day_abbreviation : AppLocalizations.of(context).day)}';
        }
        return '${days.toInt()} ${(abreviate ? AppLocalizations.of(context).day_abbreviation : AppLocalizations.of(context).days)}';
      } else {
        return PreparationTimeLabelText.getPreparationTimeText(
                days.floor() * 60 * 24, true, context) +
            " " +
            PreparationTimeLabelText.getPreparationTimeText(
                time - (days.floor() * 60 * 24), true, context);
      }
    } else if (time < 4 * 7 * 60 * 24) {
      double weeks = time.toDouble() / (7 * 60 * 24);
      if (weeks % 1 == 0) {
        if (weeks < 2) {
          return '${weeks.toInt()} ${(abreviate ? AppLocalizations.of(context).week_abbreviation : AppLocalizations.of(context).week)}';
        }
        return '${weeks.toInt()} ${(abreviate ? AppLocalizations.of(context).week_abbreviation : AppLocalizations.of(context).weeks)}';
      } else {
        return PreparationTimeLabelText.getPreparationTimeText(
                weeks.floor() * 7 * 60 * 24, true, context) +
            " " +
            PreparationTimeLabelText.getPreparationTimeText(
                time - (weeks.floor() * 7 * 60 * 24), true, context);
      }
    }

    int months = (time / (4 * 7 * 60 * 24)).round();
    if (months < 2) {
      return months.toString() + " " + AppLocalizations.of(context).month;
    }
    return months.toString() + " " + AppLocalizations.of(context).months;
  }
}
