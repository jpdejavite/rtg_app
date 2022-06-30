import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/helper/pdf_localization_map.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/widgets/choose_grocery_list_to_recipe_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/bloc/view_recipe/events.dart';
import 'package:rtg_app/bloc/view_recipe/states.dart';
import 'package:rtg_app/bloc/view_recipe/view_recipe_bloc.dart';
import 'package:rtg_app/errors/errors.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/screens/save_recipe_screen.dart';
import 'package:rtg_app/widgets/add_recipe_to_grocery_list_dialog.dart';
import 'package:rtg_app/widgets/custom_toast.dart';
import 'package:rtg_app/widgets/preparation_time_label_text.dart';
import 'package:rtg_app/widgets/view_recipe_label.dart';
import 'package:rtg_app/widgets/view_recipe_label_text.dart';
import 'package:rtg_app/widgets/view_recipe_text.dart';
import 'package:rtg_app/widgets/view_recipe_title.dart';

import '../helper/env_helper.dart';
import '../helper/pdf_export.dart';

class ViewRecipeScreen extends StatefulWidget {
  static String id = 'view_recipe_screen';

  static newViewRecipeBloc() {
    return BlocProvider(
      create: (context) => ViewRecipeBloc(
        groceryListsRepository: GroceryListsRepository(),
        recipesRepository: RecipesRepository(),
      ),
      child: ViewRecipeScreen(),
    );
  }

  @override
  _ViewRecipeState createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipeScreen> {
  Recipe recipe;
  List<String> ingredients;

  @override
  void initState() {
    super.initState();
    Wakelock.toggle(enable: true);
  }

  @override
  void dispose() {
    Wakelock.toggle(enable: false);
    super.dispose();
  }

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
        key: Key(Keys.viewRecipeShareRecipeAction),
        icon: Icon(Icons.share),
        tooltip: AppLocalizations.of(context).share_recipe,
        onPressed: () {
          showChooseShareFileDialog(context);
        },
      ),
      IconButton(
        key: Key(Keys.viewRecipeAddToGroceryListAction),
        icon: Icon(Icons.playlist_add),
        tooltip: AppLocalizations.of(context).add_to_grocery_list,
        onPressed: () {
          AddRecipeToGroceryListDialog.showChooseGroceryListToRecipeEvent(
              context: context,
              recipe: recipe,
              onConfirm: (Recipe recipe, double portions) {
                context.read<ViewRecipeBloc>().add(
                    TryToAddRecipeToGroceryListEvent(recipe, portions,
                        GroceryList.getGroceryListDefaultTitle(context)));
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
        WidgetsBinding.instance.addPostFrameCallback((_) => {
              ChooseGroceryListToRecipeDialog
                  .showChooseGroceryListToRecipeDialog(
                context: context,
                groceryLists: state.collection.groceryLists,
                onSelectGroceryList: (GroceryList groceryList) {
                  context.read<ViewRecipeBloc>().add(
                      AddRecipeToGroceryListEvent(
                          state.recipe,
                          state.portions,
                          GroceryList.getGroceryListDefaultTitle(context),
                          groceryList));
                  EasyLoading.show(
                    maskType: EasyLoadingMaskType.black,
                    status: AppLocalizations.of(context).saving_recipe,
                  );
                },
              )
            });
      }

      return buildRecipeFieldsForm(context);
    });
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

    if (recipe.totalPreparationTime != null &&
        recipe.totalPreparationTime > 0) {
      children.addAll([
        PreparationTimeLabelText(
          preparationTime: recipe.totalPreparationTime,
        ),
        Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              recipe.preparationTimeDetails.getPreparationTimeDetails(context),
              key: Key(Keys.viewRecipePreparationTimeDetailsText),
              style: Theme.of(context).textTheme.caption,
            ))
      ]);
    }

    ingredients = [];
    String label;
    recipe.ingredients.asMap().forEach((index, ingredient) {
      if (label != ingredient.label) {
        label = ingredient.label;
        ingredients.add(ingredient.label);
      }
      ingredients.add(
          (ingredient.label != null ? '    ' : '') + ingredient.originalName);
    });

    children.add(ViewRecipeLabel(
      label: AppLocalizations.of(context).ingredients,
      copyText: ingredients.join("\n"),
    ));

    label = null;
    int labelCount = 0;
    recipe.ingredients.asMap().forEach((index, ingredient) {
      if (label != ingredient.label) {
        children.add(ViewRecipeText(
          keyString: Keys.viewRecipeIngredientLabelText + labelCount.toString(),
          text: ingredient.label,
          hasLabel: false,
          fontWeight: FontWeight.bold,
          hasBullet: false,
          hasPaddingTop: true,
        ));
        label = ingredient.label;
        labelCount++;
      }
      children.add(ViewRecipeText(
        keyString: Keys.viewRecipeIngredientText + index.toString(),
        text: ingredient.originalName,
        hasLabel: ingredient.label != null,
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

    if (recipe.totalPreparationTime != null &&
        recipe.totalPreparationTime > 0) {
      data.add(AppLocalizations.of(context).preparation_time +
          ": " +
          PreparationTimeLabelText.getPreparationTimeText(
              recipe.totalPreparationTime, false, context));
    }

    data.add("\n" + AppLocalizations.of(context).ingredients);
    data.add(ingredients.join("\n") + "\n");
    data.add(AppLocalizations.of(context).how_to_do);
    data.add(recipe.instructions);
    return data.join("\n");
  }

  PdfExporter buildPdfExporter() {
    return PdfExporter(
        recipe,
        PdfLocalizationMap.build(
            context,
            PreparationTimeLabelText.getPreparationTimeText(
                recipe.totalPreparationTime, true, context),
            recipe.preparationTimeDetails == null
                ? ""
                : recipe.preparationTimeDetails
                    .getPreparationTimeDetails(context)));
  }

  Future<void> showChooseShareFileDialog(BuildContext ctx) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).share_recipe),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextButton(
                    key: Key(Keys.viewRecipeCopyContentToClipboardAction),
                    onPressed: () async {
                      await Clipboard.setData(
                          new ClipboardData(text: getRecipeAsData()));
                      Navigator.of(context).pop();
                      CustomToast.showToast(
                        text: AppLocalizations.of(context).copied_to_clipboard,
                        context: context,
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context).copy_to_clipboard,
                    )),
                TextButton(
                    key: Key(Keys.viewRecipeShareAsImagesAction),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final filePaths =
                          await buildPdfExporter().makePdfAsImages();
                      if (EnvHelper.isShareRecipeAsImageEnabled()) {
                        Share.shareFiles(filePaths, text: recipe.title);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context).generate_image,
                    )),
                TextButton(
                    key: Key(Keys.viewRecipeShareAsPdfAction),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final filePath = await buildPdfExporter().makePdfFile();
                      if (EnvHelper.isShareRecipeAsPdfEnabled()) {
                        Share.shareFiles([filePath], text: recipe.title);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context).generate_pdf,
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              key: Key(Keys.saveGroceryListArchiveCancel),
              child: Text(AppLocalizations.of(context).close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
