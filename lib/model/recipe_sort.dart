import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeSort {
  final String field;
  final bool ascending;

  const RecipeSort(this.field, this.ascending);

  String description(BuildContext context) {
    switch (this) {
      case RecipeSort.newest:
        return AppLocalizations.of(context).newest;
      case RecipeSort.oldest:
        return AppLocalizations.of(context).oldest;
      case RecipeSort.recentlyUsed:
        return AppLocalizations.of(context).recentlyUsed;
      case RecipeSort.usedALongTime:
        return AppLocalizations.of(context).usedALongTime;
      case RecipeSort.faster:
        return AppLocalizations.of(context).faster;
      case RecipeSort.slower:
        return AppLocalizations.of(context).slower;
      case RecipeSort.titleAz:
        return AppLocalizations.of(context).titleAz;
      case RecipeSort.titleZa:
        return AppLocalizations.of(context).titleZa;
    }
    return '';
  }

  static const RecipeSort newest = RecipeSort('createdAt', false);
  static const RecipeSort oldest = RecipeSort('createdAt', true);
  static const RecipeSort recentlyUsed = RecipeSort('lastUsed', false);
  static const RecipeSort usedALongTime = RecipeSort('lastUsed', true);
  static const RecipeSort faster = RecipeSort('totalPreparationTime', true);
  static const RecipeSort slower = RecipeSort('totalPreparationTime', false);
  static const RecipeSort titleAz = RecipeSort('title', true);
  static const RecipeSort titleZa = RecipeSort('title', false);
}
