import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum RecipePreparationTimeDuration { minutes, hours, days }

extension RecipePreparationTimeDurationExtension
    on RecipePreparationTimeDuration {
  String i18n(BuildContext context) {
    if (context == null) {
      // unit test
      return this.index.toString();
    }

    switch (this) {
      case RecipePreparationTimeDuration.minutes:
        return AppLocalizations.of(context).minutes;
      case RecipePreparationTimeDuration.hours:
        return AppLocalizations.of(context).hours;
      case RecipePreparationTimeDuration.days:
        return AppLocalizations.of(context).days;
    }

    return "";
  }

  bool allowDecimals() {
    switch (this) {
      case RecipePreparationTimeDuration.minutes:
        return false;
      case RecipePreparationTimeDuration.hours:
        return true;
      case RecipePreparationTimeDuration.days:
        return true;
    }

    return false;
  }

  String convertTo(double value, RecipePreparationTimeDuration newDuration) {
    switch (this) {
      case RecipePreparationTimeDuration.minutes:
        if (RecipePreparationTimeDuration.hours == newDuration) {
          return (value / Duration.minutesPerHour).toString();
        }
        if (RecipePreparationTimeDuration.days == newDuration) {
          return (value / Duration.minutesPerDay).toString();
        }
        return value.floor().toString();
      case RecipePreparationTimeDuration.hours:
        if (RecipePreparationTimeDuration.minutes == newDuration) {
          return (value * Duration.minutesPerHour).floor().toString();
        }
        if (RecipePreparationTimeDuration.days == newDuration) {
          return (value / Duration.hoursPerDay).toString();
        }
        break;
      case RecipePreparationTimeDuration.days:
        if (RecipePreparationTimeDuration.minutes == newDuration) {
          return (value * Duration.minutesPerDay).floor().toString();
        }
        if (RecipePreparationTimeDuration.hours == newDuration) {
          return (value * Duration.hoursPerDay).toString();
        }
    }

    return value.toString();
  }
}
