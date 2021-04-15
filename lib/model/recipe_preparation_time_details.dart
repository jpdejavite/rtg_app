import 'package:flutter/material.dart';
import 'package:rtg_app/widgets/preparation_time_label_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipePreparationTimeDetails {
  RecipePreparationTimeDetails({
    this.preparation,
    this.cooking,
    this.oven,
    this.marinate,
    this.fridge,
    this.freezer,
  });

  final int preparation;
  final int cooking;
  final int oven;
  final int marinate;
  final int fridge;
  final int freezer;

  int getTotalPreparationTime() {
    return (preparation ?? 0) +
        (cooking ?? 0) +
        (oven ?? 0) +
        (marinate ?? 0) +
        (fridge ?? 0) +
        (freezer ?? 0);
  }

  String getPreparationTimeDetails(BuildContext context) {
    List<String> details = [];
    if (preparation != null) {
      details.add(PreparationTimeLabelText.getPreparationTimeText(
              preparation, true, context) +
          ' ' +
          AppLocalizations.of(context).preparation);
    }
    if (cooking != null) {
      details.add(PreparationTimeLabelText.getPreparationTimeText(
              cooking, true, context) +
          ' ' +
          AppLocalizations.of(context).cooking);
    }
    if (oven != null) {
      details.add(
          PreparationTimeLabelText.getPreparationTimeText(oven, true, context) +
              ' ' +
              AppLocalizations.of(context).oven);
    }
    if (marinate != null) {
      details.add(PreparationTimeLabelText.getPreparationTimeText(
              marinate, true, context) +
          ' ' +
          AppLocalizations.of(context).marinate);
    }
    if (fridge != null) {
      details.add(PreparationTimeLabelText.getPreparationTimeText(
              fridge, true, context) +
          ' ' +
          AppLocalizations.of(context).fridge);
    }
    if (freezer != null) {
      details.add(PreparationTimeLabelText.getPreparationTimeText(
              freezer, true, context) +
          ' ' +
          AppLocalizations.of(context).freezer);
    }

    return details.join(' + ');
  }

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is RecipePreparationTimeDetails)) {
      return false;
    }
    return preparation == other.preparation &&
        cooking == other.cooking &&
        oven == other.oven &&
        marinate == other.marinate &&
        fridge == other.fridge &&
        freezer == other.freezer;
  }

  @override
  int get hashCode => super.hashCode;

  factory RecipePreparationTimeDetails.fromRecord(Object record) {
    if (record == null || !(record is Map<String, Object>)) {
      return null;
    }
    Map<String, Object> map = record;
    return RecipePreparationTimeDetails(
      preparation: map['preparation'],
      cooking: map['cooking'],
      oven: map['oven'],
      marinate: map['marinate'],
      fridge: map['fridge'],
      freezer: map['freezer'],
    );
  }

  Object toRecord() {
    return {
      'preparation': this.preparation,
      'cooking': this.cooking,
      'oven': this.oven,
      'marinate': this.marinate,
      'fridge': this.fridge,
      'freezer': this.freezer,
    };
  }
}
