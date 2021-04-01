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
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/widgets/custom_toast.dart';
import 'package:rtg_app/widgets/text_form_list_field.dart';
import 'package:rtg_app/widgets/text_form_section_label.dart';

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
  TextEditingController _preparationTimeController;
  List<FocusNode> focusNodes;
  List<String> ingredients;
  int textFieldToFocus;

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
    _preparationTimeController = TextEditingController(
        text: widget.editRecipe != null
            ? widget.editRecipe.totalPrepartionTime.toString()
            : '');
    if (widget.editRecipe == null) {
      ingredients = [''];
      focusNodes = [FocusNode()];
    } else {
      ingredients = [];
      focusNodes = [];
      widget.editRecipe.ingredients.forEach((ingredient) {
        ingredients.add(ingredient.toString());
        focusNodes.add(FocusNode());
      });
    }
    textFieldToFocus = -1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    _sourceController.dispose();
    _portionsController.dispose();
    _preparationTimeController.dispose();
    focusNodes.forEach((focus) {
      focus.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).new_recipe),
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
          Navigator.pop(context, state.response.recipe);
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
          FilteringTextInputFormatter.digitsOnly
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context).fill_this_required_field;
          }
          if (int.parse(value) < 1) {
            return AppLocalizations.of(context).fill_a_value_greater_than_zero;
          }
          return null;
        },
      ),
      TextFormField(
        controller: _preparationTimeController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).preparation_time_in_minutes,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: AppLocalizations.of(context).preparation_time_in_minutes,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
      TextFormSectionLabelFields(AppLocalizations.of(context).ingredients),
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

    // if (recipe != null) {
    //   _nameController.text = recipe.title;
    // }
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
        recipeIngredients.add(RecipeIngredient(name: i));
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
      portions: int.parse(_portionsController.text),
      totalPrepartionTime: int.parse((_preparationTimeController.text == null ||
              _preparationTimeController.text == "")
          ? '0'
          : _preparationTimeController.text),
      source: _sourceController.text,
      ingredients: recipeIngredients,
    );
  }
}
