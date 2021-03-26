import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/screens/save_recipe_screen.dart';
import 'package:rtg_app/widgets/custom_toast.dart';
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
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: getRecipeAsData()));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
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
