import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe.dart';

class AddRecipeToGroceryListDialog extends StatefulWidget {
  final Recipe recipe;
  final void Function(Recipe recipe, int portions) onConfirm;

  AddRecipeToGroceryListDialog({
    this.recipe,
    this.onConfirm,
  });
  @override
  _AddRecipeToGroceryListDialogState createState() =>
      _AddRecipeToGroceryListDialogState();

  static Future<void> showChooseGroceryListToRecipeEvent({
    BuildContext context,
    Recipe recipe,
    Function(Recipe recipe, int portions) onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddRecipeToGroceryListDialog(
          onConfirm: onConfirm,
          recipe: recipe,
        );
      },
    );
  }
}

class _AddRecipeToGroceryListDialogState
    extends State<AddRecipeToGroceryListDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _portionsController;

  @override
  void initState() {
    super.initState();
    _portionsController = TextEditingController();
  }

  @override
  void dispose() {
    _portionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _portionsController.text = widget.recipe.portions.toString();
    _portionsController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.recipe.portions.toString().length,
    );
    return AlertDialog(
      title: Text(AppLocalizations.of(context).recipe_portions),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)
                      .type_in_recipe_portions_to_make),
                  TextFormField(
                    key: Key(Keys.addRecipeToGroceryListDialogPortionTextField),
                    controller: _portionsController,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context).servers_how_many_people,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: AppLocalizations.of(context).portions,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .fill_this_required_field;
                      }
                      if (int.parse(value) < 1) {
                        return AppLocalizations.of(context)
                            .fill_a_value_greater_than_zero;
                      }
                      return null;
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          key: Key(Keys.addRecipeToGroceryListDialogConfirmButton),
          child: Text(AppLocalizations.of(context).confirm),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.of(context).pop();
              widget.onConfirm(
                  widget.recipe, int.parse(_portionsController.text));
            }
          },
        ),
      ],
    );
  }
}
