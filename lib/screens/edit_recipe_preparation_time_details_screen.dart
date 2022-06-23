import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe_preparation_time_details.dart';

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
        FilteringTextInputFormatter.digitsOnly
      ],
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
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 5),
              child: Text(
                  AppLocalizations.of(context).preparation_time_details_info,
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      )),
            ),
            buildTextFormField(
              key: Keys.editRecipePreparationTimeDetailsPreparationField,
              controller: _preparationController,
              hintText: AppLocalizations.of(context).preparation_time_hint,
              label: AppLocalizations.of(context).preparation_in_minutes,
            ),
            buildTextFormField(
              key: Keys.editRecipePreparationTimeDetailsCookingField,
              controller: _cookingController,
              hintText: AppLocalizations.of(context).cooking_time_hint,
              label: AppLocalizations.of(context).cooking_in_minutes,
            ),
            buildTextFormField(
              key: Keys.editRecipePreparationTimeDetailsOvenField,
              controller: _ovenController,
              hintText: AppLocalizations.of(context).oven_time_hint,
              label: AppLocalizations.of(context).oven_in_minutes,
            ),
            buildTextFormField(
              key: Keys.editRecipePreparationTimeDetailsMarinateField,
              controller: _marinateController,
              hintText: AppLocalizations.of(context).marinate_time_hint,
              label: AppLocalizations.of(context).marinate_in_minutes,
            ),
            buildTextFormField(
              key: Keys.editRecipePreparationTimeDetailsFridgeField,
              controller: _fridgeController,
              hintText: AppLocalizations.of(context).fridge_time_hint,
              label: AppLocalizations.of(context).fridge_in_minutes,
            ),
            buildTextFormField(
              key: Keys.editRecipePreparationTimeDetailsFreezerField,
              controller: _freezerController,
              hintText: AppLocalizations.of(context).freezer_time_hint,
              label: AppLocalizations.of(context).freezer_in_minutes,
            ),
          ],
        ),
      ),
    );
  }

  RecipePreparationTimeDetails getFromInputs() {
    bool isPreparationTimeNotSet = (_preparationController.text == null ||
        _preparationController.text == "");
    bool isCookingTimeNotSet =
        (_cookingController.text == null || _cookingController.text == "");
    bool isOvenTimeNotSet =
        (_ovenController.text == null || _ovenController.text == "");
    bool isMarinateTimeNotSet =
        (_marinateController.text == null || _marinateController.text == "");
    bool isFridgeTimeNotSet =
        (_fridgeController.text == null || _fridgeController.text == "");
    bool isFreezerTimeNotSet =
        (_freezerController.text == null || _freezerController.text == "");

    if (isPreparationTimeNotSet &&
        isCookingTimeNotSet &&
        isOvenTimeNotSet &&
        isMarinateTimeNotSet &&
        isFridgeTimeNotSet &&
        isFreezerTimeNotSet) {
      return null;
    }

    return RecipePreparationTimeDetails(
      preparation: isPreparationTimeNotSet
          ? null
          : int.parse(_preparationController.text),
      cooking: isCookingTimeNotSet ? null : int.parse(_cookingController.text),
      oven: isOvenTimeNotSet ? null : int.parse(_ovenController.text),
      marinate:
          isMarinateTimeNotSet ? null : int.parse(_marinateController.text),
      fridge: isFridgeTimeNotSet ? null : int.parse(_fridgeController.text),
      freezer: isFreezerTimeNotSet ? null : int.parse(_freezerController.text),
    );
  }
}
