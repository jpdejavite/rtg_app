import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/bloc/view_recipe/events.dart';
import 'package:rtg_app/bloc/view_recipe/states.dart';
import 'package:rtg_app/bloc/view_recipe/view_recipe_bloc.dart';
import 'package:rtg_app/errors/errors.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/screens/save_recipe_screen.dart';
import 'package:rtg_app/widgets/add_recipe_to_grocery_list_dialog.dart';
import 'package:rtg_app/widgets/custom_toast.dart';
import 'package:rtg_app/widgets/preparation_time_label_text.dart';
import 'package:rtg_app/widgets/view_recipe_label.dart';
import 'package:rtg_app/widgets/view_recipe_label_text.dart';
import 'package:rtg_app/widgets/view_recipe_text.dart';
import 'package:rtg_app/widgets/view_recipe_title.dart';

class ViewRecipeScreen extends StatefulWidget {
  static String id = 'view_recipe_screen';

  static newViewRecipeBloc() {
    return BlocProvider(
      create: (context) =>
          ViewRecipeBloc(groceryListsRepository: GroceryListsRepository()),
      child: ViewRecipeScreen(),
    );
  }

  @override
  _ViewRecipeState createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipeScreen> {
  Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
  
    if (args == null || !(args is Recipe)) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).recipe_details),
        ),
        body: Center(
          child: Text(
              AppLocalizations.of(context).not_possible_to_show_recipe_details),
        ),
      );
    }

    if (recipe == null) {
      recipe = args as Recipe;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).recipe_details),
        actions: buildActions(),
      ),
      floatingActionButton: buildFloatingActionButton(),
      body: buildBody(),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      key: Key(Keys.viewRecipeFloatingActionEditButton),
      onPressed: () async {
        final result = await Navigator.pushNamed(
          context,
          SaveRecipeScreen.id,
          arguments: recipe,
        );
        if (result != null && result is Recipe) {
          CustomToast.showToast(
            text: AppLocalizations.of(context).saved_recipe,
            context: context,
            time: CustomToast.timeShort,
          );
          setState(() {
            recipe = result;
          });
        }
      },
      child: Icon(Icons.edit),
    );
  }

  List<Widget> buildActions() {
    return [
      IconButton(
        icon: Icon(Icons.copy),
        tooltip: AppLocalizations.of(context).copy_to_clipboard,
        onPressed: () {
          Clipboard.setData(new ClipboardData(text: getRecipeAsData()));
        },
      ),
      IconButton(
        icon: Icon(Icons.playlist_add),
        tooltip: AppLocalizations.of(context).add_to_grocery_list,
        onPressed: () {
          AddRecipeToGroceryListDialog.showChooseGroceryListToRecipeEvent(
              context: context,
              recipe: recipe,
              onConfirm: (Recipe recipe, int portions) {
                context
                    .read<ViewRecipeBloc>()
                    .add(TryToAddRecipeToGroceryListEvent(recipe, portions));
                EasyLoading.show(
                  maskType: EasyLoadingMaskType.black,
                  status: AppLocalizations.of(context).saving_recipe,
                );
              });
        },
      ),
    ];
  }

  Widget buildBody() {
    return BlocBuilder<ViewRecipeBloc, ViewRecipeState>(
        builder: (BuildContext context, ViewRecipeState state) {
      EasyLoading.dismiss();
      if (state is AddedRecipeToGroceryListEvent) {
        String text = AppLocalizations.of(context).recipe_added_to_grocery_list;
        if (state.response.error != null) {
          text = state.response.error is RecipeAlreadyAddedToGroceryList
              ? AppLocalizations.of(context)
                  .recipe_already_added_to_grocery_list
              : AppLocalizations.of(context).error_when_adding_to_grocery_list;
        }
        CustomToast.showToast(
          text: text,
          context: context,
          time: CustomToast.timeLong,
        );
      } else if (state is ChooseGroceryListToRecipeEvent) {
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => showChooseGroceryListToRecipeEvent(context, state));
      }

      return buildRecipeFieldsForm(context);
    });
  }

  Future<void> showChooseGroceryListToRecipeEvent(
      BuildContext ctx, ChooseGroceryListToRecipeEvent state) {
    List<Widget> groceriesWidgets = [];
    state.collection.groceryLists.forEach((groceryList) {
      groceriesWidgets.add(TextButton(
          child: Text(groceryList.title),
          onPressed: () {
            Navigator.of(context).pop();
            ctx.read<ViewRecipeBloc>().add(AddRecipeToGroceryListEvent(
                recipe, state.portions, groceryList));
            EasyLoading.show(
              maskType: EasyLoadingMaskType.black,
              status: AppLocalizations.of(context).saving_recipe,
            );
          }));
    });

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).choose_a_grocery_list),
          content: SingleChildScrollView(
            child: ListBody(
              children: groceriesWidgets,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  Text(AppLocalizations.of(context).create_a_new_grocery_list),
              onPressed: () {
                Navigator.of(context).pop();
                ctx.read<ViewRecipeBloc>().add(
                    AddRecipeToGroceryListEvent(recipe, state.portions, null));
                EasyLoading.show(
                  maskType: EasyLoadingMaskType.black,
                  status: AppLocalizations.of(context).saving_recipe,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildRecipeFieldsForm(BuildContext context) {
    List<Widget> children = [ViewRecipeTitle(recipe.title)];

    if (recipe.source != null && recipe.source != "") {
      children.add(ViewRecipeLabelText(
        label: AppLocalizations.of(context).source,
        text: recipe.source,
      ));
    }

    children.add(ViewRecipeLabelText(
      keyString: Keys.viewRecipePortionsLabelText,
      label: AppLocalizations.of(context).serves,
      text: recipe.portions.toString() +
          " " +
          (recipe.portions > 1
              ? AppLocalizations.of(context).people
              : AppLocalizations.of(context).person),
    ));

    if (recipe.totalPrepartionTime != null && recipe.totalPrepartionTime > 0) {
      children.add(PreparationTimeLabelText(
        preparationTime: recipe.totalPrepartionTime,
      ));
    }

    children.add(ViewRecipeLabel(
      label: AppLocalizations.of(context).ingredients,
      copyText: recipe.ingredients.join("\n"),
    ));

    recipe.ingredients.asMap().forEach((index, ingredient) {
      children.add(ViewRecipeText(
        keyString: Keys.viewRecipeIngredientText + index.toString(),
        text: ingredient.name,
        hasBullet: true,
        hasPaddingTop: true,
      ));
    });

    children.add(ViewRecipeLabel(
      label: AppLocalizations.of(context).how_to_do,
      copyText: recipe.instructions,
    ));
    children.add(ViewRecipeText(
      keyString: Keys.viewRecipeInstructionText,
      text: recipe.instructions,
      hasBullet: false,
      hasPaddingTop: false,
    ));
    children.add(Padding(
      padding: EdgeInsets.only(bottom: 80),
    ));

    return ListView(
      padding: EdgeInsets.all(5),
      shrinkWrap: true,
      children: children,
    );
  }

  String getRecipeAsData() {
    List<String> data = [recipe.title + "\n"];
    if (recipe.source != null && recipe.source != "") {
      data.add(AppLocalizations.of(context).source + ": " + recipe.source);
    }

    data.add(
      AppLocalizations.of(context).serves +
          ": " +
          recipe.portions.toString() +
          " " +
          (recipe.portions > 1
              ? AppLocalizations.of(context).people
              : AppLocalizations.of(context).person),
    );

    if (recipe.totalPrepartionTime != null && recipe.totalPrepartionTime > 0) {
      data.add(AppLocalizations.of(context).preparation_time +
          ": " +
          PreparationTimeLabelText.getPreparationTimeText(
              recipe.totalPrepartionTime, false, context));
    }

    data.add("\n" + AppLocalizations.of(context).ingredients);
    data.add(recipe.ingredients.join("\n") + "\n");
    data.add(AppLocalizations.of(context).how_to_do);
    data.add(recipe.instructions);
    return data.join("\n");
  }
}
