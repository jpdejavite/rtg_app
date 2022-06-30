import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PdfLocalizationMap {
  final String appName;
  final String appShortSescription;
  final String serves;
  final String people;
  final String person;
  final String source;
  final String preparationTime;
  final String preparationTimeAbrev;
  final String preparationTimeDescription;
  final String ingredients;
  final String howToDo;

  PdfLocalizationMap({
    this.appName,
    this.appShortSescription,
    this.serves,
    this.people,
    this.person,
    this.source,
    this.preparationTime,
    this.preparationTimeAbrev,
    this.preparationTimeDescription,
    this.ingredients,
    this.howToDo,
  });

  static PdfLocalizationMap build(BuildContext context,
      String preparationTimeAbrev, String preparationTimeDescription) {
    return PdfLocalizationMap(
      appName: AppLocalizations.of(context).app_name,
      appShortSescription: AppLocalizations.of(context).app_short_description,
      serves: AppLocalizations.of(context).serves,
      people: AppLocalizations.of(context).people,
      person: AppLocalizations.of(context).person,
      source: AppLocalizations.of(context).source,
      preparationTime: AppLocalizations.of(context).preparation_time,
      preparationTimeAbrev: preparationTimeAbrev,
      preparationTimeDescription: preparationTimeDescription,
      ingredients: AppLocalizations.of(context).ingredients,
      howToDo: AppLocalizations.of(context).how_to_do,
    );
  }
}
