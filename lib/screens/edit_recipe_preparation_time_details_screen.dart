import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe_preparation_time_details.dart';
import 'package:sprintf/sprintf.dart';

import '../model/recipe_preparation_time_duration.dart';

class EditPreparationTimeDetailsScreen extends StatefulWidget {
  static String id = 'edit_recipe_preparation_time_details_screen';
  final RecipePreparationTimeDetails editPreparationTimeDetails;

  EditPreparationTimeDetailsScreen(this.editPreparationTimeDetails);

  @override
  _EditPreparationTimeDetailsScreenState createState() =>
      _EditPreparationTimeDetailsScreenState();
}

class _EditPreparationTimeDetailsScreenState
    extends State<EditPreparationTimeDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _preparationController;
  TextEditingController _cookingController;
  TextEditingController _ovenController;
  TextEditingController _marinateController;
  TextEditingController _fridgeController;
  TextEditingController _freezerController;
  RecipePreparationTimeDuration duration =
      RecipePreparationTimeDuration.minutes;

  @override
  void initState() {
    super.initState();

    _preparationController = TextEditingController(
        text: widget.editPreparationTimeDetails != null &&
                widget.editPreparationTimeDetails.preparation != null
            ? widget.editPreparationTimeDetails.preparation.toString()
            : '');
    _cookingController = TextEditingController(
        text: widget.editPreparationTimeDetails != null &&
                widget.editPreparationTimeDetails.cooking != null
            ? widget.editPreparationTimeDetails.cooking.toString()
            : '');
    _ovenController = TextEditingController(
        text: widget.editPreparationTimeDetails != null &&
                widget.editPreparationTimeDetails.oven != null
            ? widget.editPreparationTimeDetails.oven.toString()
            : '');
    _marinateController = TextEditingController(
        text: widget.editPreparationTimeDetails != null &&
                widget.editPreparationTimeDetails.marinate != null
            ? widget.editPreparationTimeDetails.marinate.toString()
            : '');
    _fridgeController = TextEditingController(
        text: widget.editPreparationTimeDetails != null &&
                widget.editPreparationTimeDetails.fridge != null
            ? widget.editPreparationTimeDetails.fridge.toString()
            : '');
    _freezerController = TextEditingController(
        text: widget.editPreparationTimeDetails != null &&
                widget.editPreparationTimeDetails.freezer != null
            ? widget.editPreparationTimeDetails.freezer.toString()
            : '');
  }

  @override
  void dispose() {
    _preparationController.dispose();
    _cookingController.dispose();
    _ovenController.dispose();
    _marinateController.dispose();
    _fridgeController.dispose();
    _freezerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).edit_preparation_time),
      ),
      floatingActionButton: FloatingActionButton(
        key: Key(Keys.editRecipePreparationTimeDetailsSaveButton),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Navigator.pop(context, getFromInputs());
          }
        },
        child: Icon(Icons.done),
      ),
      body: buildBody(),
    );
  }

  TextFormField buildTextFormField(
      {String key,
      String hintText,
      String label,
      TextEditingController controller}) {
    return TextFormField(
      key: Key(key),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        duration.allowDecimals()
            ? FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))
            : FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        return getTimeFromText(value) != null
            ? null
            : AppLocalizations.of(context).fill_a_valid_double;
      },
    );
  }

  double getTimeFromText(String text) {
    if (text == null || text.isEmpty) {
      return 0;
    }
    try {
      return double.parse(text.replaceAll(",", "."));
    } catch (e) {
      return null;
    }
  }

  Widget buildDurationPreparationDropdown() {
    return DropdownButton<RecipePreparationTimeDuration>(
      key: Key(Keys.editRecipePreparationTimeDetailsDurationDropdown),
      value: duration,
      icon: const Icon(Icons.expand_more),
      iconSize: 24,
      elevation: 16,
      onChanged: (RecipePreparationTimeDuration newDuration) {
        changeDuration(newDuration);
        setState(() {
          duration = newDuration;
        });
      },
      items: RecipePreparationTimeDuration.values
          .map<DropdownMenuItem<RecipePreparationTimeDuration>>(
              (RecipePreparationTimeDuration value) {
        return DropdownMenuItem<RecipePreparationTimeDuration>(
          value: value,
          child: Text(value.i18n(context)),
        );
      }).toList(),
    );
  }

  Widget buildBody() {
    return Form(
      key: _formKey,
      child: Container(
        child: ListView(
          padding: EdgeInsets.all(5),
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                AppLocalizations.of(context)
                    .preparation_time_details_explanation,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Row(children: [
              Text(AppLocalizations.of(context).edit_preparation_time_in,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      )),
              SizedBox(
                width: 8,
              ),
              buildDurationPreparationDropdown(),
            ]),
            buildTextFormField(
              key: Keys.editRecipePreparationTimeDetailsPreparationField,
              controller: _preparationController,
              hintText: AppLocalizations.of(context).preparation_time_hint,
              label: sprintf(
                  AppLocalizations.of(context).preparation_in_minutes,
                  [duration.i18n(context)]),
            ),
            buildTextFormField(
              key: Keys.editRecipePreparationTimeDetailsCookingField,
              controller: _cookingController,
              hintText: AppLocalizations.of(context).cooking_time_hint,
              label: sprintf(AppLocalizations.of(context).cooking_in_minutes,
                  [duration.i18n(context)]),
            ),
            buildTextFormField(
              key: Keys.editRecipePreparationTimeDetailsOvenField,
              controller: _ovenController,
              hintText: AppLocalizations.of(context).oven_time_hint,
              label: sprintf(AppLocalizations.of(context).oven_in_minutes,
                  [duration.i18n(context)]),
            ),
            buildTextFormField(
              key: Keys.editRecipePreparationTimeDetailsMarinateField,
              controller: _marinateController,
              hintText: AppLocalizations.of(context).marinate_time_hint,
              label: sprintf(AppLocalizations.of(context).marinate_in_minutes,
                  [duration.i18n(context)]),
            ),
            buildTextFormField(
              key: Keys.editRecipePreparationTimeDetailsFridgeField,
              controller: _fridgeController,
              hintText: AppLocalizations.of(context).fridge_time_hint,
              label: sprintf(AppLocalizations.of(context).fridge_in_minutes,
                  [duration.i18n(context)]),
            ),
            buildTextFormField(
              key: Keys.editRecipePreparationTimeDetailsFreezerField,
              controller: _freezerController,
              hintText: AppLocalizations.of(context).freezer_time_hint,
              label: sprintf(AppLocalizations.of(context).freezer_in_minutes,
                  [duration.i18n(context)]),
            ),
          ],
        ),
      ),
    );
  }

  void changeDuration(RecipePreparationTimeDuration newDuration) {
    double preparationTime = getTimeFromText(_preparationController.text);
    if (preparationTime != null && preparationTime != 0) {
      _preparationController.text =
          duration.convertTo(preparationTime, newDuration);
    }

    double cookingTime = getTimeFromText(_cookingController.text);
    if (cookingTime != null && cookingTime != 0) {
      _cookingController.text = duration.convertTo(cookingTime, newDuration);
    }

    double ovenTime = getTimeFromText(_ovenController.text);
    if (ovenTime != null && ovenTime != 0) {
      _ovenController.text = duration.convertTo(ovenTime, newDuration);
    }

    double marinateTime = getTimeFromText(_marinateController.text);
    if (marinateTime != null && marinateTime != 0) {
      _marinateController.text = duration.convertTo(marinateTime, newDuration);
    }

    double fridgeTime = getTimeFromText(_fridgeController.text);
    if (fridgeTime != null && fridgeTime != 0) {
      _fridgeController.text = duration.convertTo(fridgeTime, newDuration);
    }

    double freezerTime = getTimeFromText(_freezerController.text);
    if (freezerTime != null && freezerTime != 0) {
      _freezerController.text = duration.convertTo(freezerTime, newDuration);
    }
  }

  RecipePreparationTimeDetails getFromInputs() {
    double preparationTime = getTimeFromText(_preparationController.text);
    double cookingTime = getTimeFromText(_cookingController.text);
    double ovenTime = getTimeFromText(_ovenController.text);
    double marinateTime = getTimeFromText(_marinateController.text);
    double fridgeTime = getTimeFromText(_fridgeController.text);
    double freezerTime = getTimeFromText(_freezerController.text);

    if ((preparationTime == null || preparationTime == 0) &&
        (cookingTime == null || cookingTime == 0) &&
        (ovenTime == null || ovenTime == 0) &&
        (marinateTime == null || marinateTime == 0) &&
        (fridgeTime == null || fridgeTime == 0) &&
        (freezerTime == null || freezerTime == 0)) {
      return null;
    }

    return RecipePreparationTimeDetails(
      preparation: preparationTime == null || preparationTime == 0
          ? null
          : int.parse(duration.convertTo(
              preparationTime, RecipePreparationTimeDuration.minutes)),
      cooking: cookingTime == null || cookingTime == 0
          ? null
          : int.parse(duration.convertTo(
              cookingTime, RecipePreparationTimeDuration.minutes)),
      oven: ovenTime == null || ovenTime == 0
          ? null
          : int.parse(duration.convertTo(
              ovenTime, RecipePreparationTimeDuration.minutes)),
      marinate: marinateTime == null || marinateTime == 0
          ? null
          : int.parse(duration.convertTo(
              marinateTime, RecipePreparationTimeDuration.minutes)),
      fridge: fridgeTime == null || fridgeTime == 0
          ? null
          : int.parse(duration.convertTo(
              fridgeTime, RecipePreparationTimeDuration.minutes)),
      freezer: freezerTime == null || freezerTime == 0
          ? null
          : int.parse(duration.convertTo(
              freezerTime, RecipePreparationTimeDuration.minutes)),
    );
  }
}
