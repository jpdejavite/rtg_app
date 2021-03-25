import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/widgets/preparation_time_label_text.dart';
import 'package:rtg_app/widgets/view_recipe_label.dart';
import 'package:rtg_app/widgets/view_recipe_label_text.dart';
import 'package:rtg_app/widgets/view_recipe_text.dart';
import 'package:rtg_app/widgets/view_recipe_title.dart';

class ViewRecipeScreen extends StatefulWidget {
  static String id = 'view_recipe_screen';

  @override
  _ViewRecipeState createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipeScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).recipe_details),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              if (args != null && args is Recipe) {
                Clipboard.setData(
                    new ClipboardData(text: getRecipeAsData(args)));
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('on pressed');
        },
        child: Icon(Icons.edit),
      ),
      body: buildBody(args),
    );
  }

  Widget buildBody(var args) {
    if (args == null || !(args is Recipe)) {
      return Center(
        child: Text(
            AppLocalizations.of(context).not_possible_to_show_recipe_details),
      );
    }

    Recipe recipe = args as Recipe;

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

  String getRecipeAsData(var args) {
    Recipe recipe = args as Recipe;
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
