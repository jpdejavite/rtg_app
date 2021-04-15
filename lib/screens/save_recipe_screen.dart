import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/bloc/save_recipe/events.dart';
import 'package:rtg_app/bloc/save_recipe/save_recipe_bloc.dart';
import 'package:rtg_app/bloc/save_recipe/states.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipe_ingredient.dart';
import 'package:rtg_app/model/recipe_preparation_time_details.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/widgets/custom_toast.dart';
import 'package:rtg_app/widgets/preparation_time_label_text.dart';
import 'package:rtg_app/widgets/text_form_list_field.dart';
import 'package:rtg_app/widgets/text_form_section_label.dart';

import 'edit_recipe_preparation_time_details_screen.dart';

class SaveRecipeScreen extends StatefulWidget {
  static String id = 'save_recipe_screen';
  final Recipe editRecipe;

  SaveRecipeScreen(this.editRecipe);

  static newSaveRecipeBloc(args) {
    return BlocProvider(
      create: (context) => SaveRecipeBloc(recipesRepo: RecipesRepository()),
      child: SaveRecipeScreen(args),
    );
  }

  @override
  _SaveRecipeState createState() => _SaveRecipeState();
}

class _SaveRecipeState extends State<SaveRecipeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  TextEditingController _sourceController;
  TextEditingController _instructionsController;
  TextEditingController _portionsController;
  List<FocusNode> focusNodes;
  List<String> ingredients;
  int textFieldToFocus;
  RecipePreparationTimeDetails preparationTimeDetails;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
        text: widget.editRecipe != null ? widget.editRecipe.title : '');
    _instructionsController = TextEditingController(
        text: widget.editRecipe != null ? widget.editRecipe.instructions : '');
    _sourceController = TextEditingController(
        text: widget.editRecipe != null ? widget.editRecipe.source : '');
    _portionsController = TextEditingController(
        text: widget.editRecipe != null
            ? widget.editRecipe.portions == null
                ? ''
                : widget.editRecipe.portions.toString()
            : '');
    if (widget.editRecipe == null) {
      ingredients = [''];
      focusNodes = [FocusNode()];
    } else {
      ingredients = [];
      focusNodes = [];
      widget.editRecipe.ingredients.forEach((ingredient) {
        ingredients.add(ingredient.originalName);
        focusNodes.add(FocusNode());
      });
      preparationTimeDetails = widget.editRecipe.preparationTimeDetails;
    }
    textFieldToFocus = -1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    _sourceController.dispose();
    _portionsController.dispose();
    focusNodes.forEach((focus) {
      focus.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editRecipe == null
            ? AppLocalizations.of(context).new_recipe
            : AppLocalizations.of(context).edit_recipe),
      ),
      floatingActionButton: FloatingActionButton(
        key: Key(Keys.saveRecipeFloatingActionSaveButton),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            context
                .read<SaveRecipeBloc>()
                .add(SaveRecipeEvent(recipe: getRecipeFromInputs()));
            EasyLoading.show(
              maskType: EasyLoadingMaskType.black,
              status: AppLocalizations.of(context).saving_recipe,
            );
          }
        },
        child: Icon(Icons.done),
      ),
      body: buildBody(),
    );
  }

  List<Widget> buildPreparationTimeFields() {
    List<Widget> fields = [
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          AppLocalizations.of(context).preparation_time,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                preparationTimeDetails != null
                    ? PreparationTimeLabelText.getPreparationTimeText(
                        preparationTimeDetails.getTotalPreparationTime(),
                        false,
                        context)
                    : '-',
                key: Key(Keys.saveRecipePreparationTimeText),
              ),
            ),
          ),
          TextButton(
            key: Key(Keys.saveRecipePreparationTimeAction),
            child: Text(AppLocalizations.of(context).edit),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                  context, EditPreparationTimeDetailsScreen.id,
                  arguments: preparationTimeDetails);
              if (result != null && result is RecipePreparationTimeDetails) {
                preparationTimeDetails = result;
                setState(() {});
              }
            },
          )
        ],
      ),
    ];

    if (preparationTimeDetails != null) {
      fields.add(Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            preparationTimeDetails.getPreparationTimeDetails(context),
            style: Theme.of(context).textTheme.caption,
          )));
    }
    return fields;
  }

  Widget buildBody() {
    return BlocBuilder<SaveRecipeBloc, SaveRecipeState>(
        builder: (BuildContext context, SaveRecipeState state) {
      EasyLoading.dismiss();
      if (state is RecipeSaved) {
        if (state.response.error != null) {
          CustomToast.showToast(
            text: AppLocalizations.of(context).generic_error_save_recipe,
            context: context,
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => Navigator.pop(context, state.response.recipe));
        }
      }

      return buildForm(context);
    });
  }

  Widget buildForm(BuildContext context) {
    List<Widget> fields = [
      TextFormSectionLabelFields(AppLocalizations.of(context).general_data),
      TextFormField(
        key: Key(Keys.saveRecipeNameField),
        controller: _nameController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).recipe_name,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: AppLocalizations.of(context).recipe_name,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context).fill_this_required_field;
          }
          if (value.length < 3) {
            return AppLocalizations.of(context).type_in_3_chars;
          }
          return null;
        },
      ),
      TextFormField(
        controller: _sourceController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).recipe_copied_from,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: AppLocalizations.of(context).source,
        ),
      ),
      TextFormField(
        key: Key(Keys.saveRecipePortionField),
        controller: _portionsController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).servers_how_many_people,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: AppLocalizations.of(context).portions,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context).fill_this_required_field;
          }
          try {
            double.parse(value.replaceAll(",", "."));
          } catch (e) {
            print(e);
            return AppLocalizations.of(context).fill_a_valid_double;
          }
          return null;
        },
      ),
      ...buildPreparationTimeFields(),
      TextFormSectionLabelFields(
        AppLocalizations.of(context).ingredients,
        iconTooltip: AppLocalizations.of(context).paste_multiple_ingredients,
        icon: Icons.playlist_add,
        onIconPressed: () async {
          ClipboardData data = await Clipboard.getData('text/plain');
          if (data.text != null && data.text != "") {
            data.text.split('\n').forEach((line) {
              ingredients.add(line);
              focusNodes.add(FocusNode());
            });
            setState(() {});
          }
        },
      ),
    ];

    ingredients.asMap().forEach((index, value) {
      fields.add(TextFormListFields(
        index: index,
        initValue: ingredients[index],
        hintText: AppLocalizations.of(context).type_in_ingredient_with_quantity,
        canBeRemoved: ingredients.length == 1,
        onChanged: (i, v) {
          ingredients[i] = v;
        },
        onAddNewField: (i) {
          ingredients.insert(i + 1, '');
          focusNodes.insert(i + 1, FocusNode());
          textFieldToFocus = i + 1;
          setState(() {});
        },
        onRemoveField: (i) {
          ingredients.removeAt(i);
          focusNodes[i].unfocus();
          focusNodes.removeAt(i);

          textFieldToFocus = -1;
          setState(() {});
        },
        focusNode: focusNodes[index],
      ));
    });

    if (textFieldToFocus != -1) {
      focusNodes[textFieldToFocus].requestFocus();
    }

    fields.addAll([
      TextFormSectionLabelFields(AppLocalizations.of(context).how_to_do),
      TextFormField(
        key: Key(Keys.saveRecipeInstructionsField),
        controller: _instructionsController,
        minLines: 6,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).instructions_how_to_do_recipe,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: AppLocalizations.of(context).instructions,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context).fill_this_required_field;
          }
          if (value.length < 10) {
            return AppLocalizations.of(context).type_in_10_chars;
          }
          return null;
        },
      ),
    ]);

    return Form(
      key: _formKey,
      child: Container(
        child: ListView(
          padding: EdgeInsets.all(5),
          shrinkWrap: true,
          children: fields,
        ),
      ),
    );
  }

  Recipe getRecipeFromInputs() {
    List<RecipeIngredient> recipeIngredients = [];
    ingredients.forEach((i) {
      if (i != null && i != "") {
        recipeIngredients.add(RecipeIngredient.fromInput(i));
      }
    });

    return Recipe(
      id: widget.editRecipe != null ? widget.editRecipe.id : null,
      title: _nameController.text,
      createdAt: widget.editRecipe != null
          ? widget.editRecipe.createdAt
          : CustomDateTime.current.millisecondsSinceEpoch,
      updatedAt: CustomDateTime.current.millisecondsSinceEpoch,
      instructions: _instructionsController.text,
      portions: double.parse(_portionsController.text.replaceAll(",", ".")),
      totalPreparationTime: (preparationTimeDetails == null)
          ? 0
          : preparationTimeDetails.getTotalPreparationTime(),
      preparationTimeDetails: preparationTimeDetails,
      source: _sourceController.text,
      ingredients: recipeIngredients,
    );
  }
}
