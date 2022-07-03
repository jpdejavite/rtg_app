import 'package:flutter_driver/flutter_driver.dart';
import 'package:rtg_app/keys/keys.dart';

class Constants {
  static final homeBottomBarHomeIcon =
      find.byValueKey(Keys.homeBottomBarHomeIcon);
  static final homeBottomBarRecipesIcon =
      find.byValueKey(Keys.homeBottomBarRecipesIcon);
  static final homeBottomBarListsIcon =
      find.byValueKey(Keys.homeBottomBarListsIcon);
  static final homeCardRecipeTutorialDismiss =
      find.byValueKey(Keys.homeCardRecipeTutorialDismiss);
  static final homeCardConfigureBackup =
      find.byValueKey(Keys.homeCardConfigureBackup);
  static final homeCardConfigureBackupAction =
      find.byValueKey(Keys.homeCardConfigureBackupAction);
  static final homeCardLastGroceryListUsed =
      find.byValueKey(Keys.homeCardLastGroceryListUsed);
  static final homeCardLastGroceryListUsedAction =
      find.byValueKey(Keys.homeCardLastGroceryListUsedAction);
  static final homeCardRecipeButton0 =
      find.byValueKey('${Keys.homeCardRecipeButton}-0');
  static final homeCardFirstMenuPlanning =
      find.byValueKey(Keys.homeCardFirstMenuPlanning);
  static final homeCardDoMenuPlanning =
      find.byValueKey(Keys.homeCardDoMenuPlanning);
  static final homeFloatingActionNewGroceryListButton =
      find.byValueKey(Keys.homeFloatingActionNewGroceryListButton);
  static final actionDeleteAllIcon = find.byValueKey(Keys.actionDeleteAllIcon);
  static final homeActionSettingsIcon =
      find.byValueKey(Keys.homeActionSettingsIcon);
  static final saveRecipeNameField = find.byValueKey(Keys.saveRecipeNameField);
  static final saveRecipeLabelField =
      find.byValueKey(Keys.saveRecipeLabelField);
  static final saveRecipeLabelField0 =
      find.byValueKey(Keys.saveRecipeLabelField + "0");
  static final saveRecipeLabelRemoveIcon1 =
      find.byValueKey(Keys.saveRecipeLabelRemoveIcon + "1");
  static final saveRecipeIngredientField2 =
      find.byValueKey(Keys.saveRecipeIngredientField + "2");
  static final saveRecipeIngredientRemoveIcon3 =
      find.byValueKey(Keys.saveRecipeIngredientRemoveIcon + "3");
  static final saveRecipeFloatingActionSaveButton =
      find.byValueKey(Keys.saveRecipeFloatingActionSaveButton);
  static final recipeListRowTitleText0 =
      find.byValueKey(Keys.recipeListRowTitleText + "0");
  static final recipeListRowTitleText1 =
      find.byValueKey(Keys.recipeListRowTitleText + "1");
  static final recipeListRowTitleText2 =
      find.byValueKey(Keys.recipeListRowTitleText + "2");
  static final viewRecipeTitle = find.byValueKey(Keys.viewRecipeTitle);
  static final viewRecipeLabelLabelText =
      find.byValueKey(Keys.viewRecipeLabelLabelText);
  static final viewRecipePreparationTimeDetailsText =
      find.byValueKey(Keys.viewRecipePreparationTimeDetailsText);
  static final viewRecipeIngredientText0 =
      find.byValueKey(Keys.viewRecipeIngredientText + "0");
  static final viewRecipeIngredientText1 =
      find.byValueKey(Keys.viewRecipeIngredientText + "1");
  static final viewRecipeIngredientText2 =
      find.byValueKey(Keys.viewRecipeIngredientText + "2");
  static final viewRecipeIngredientText3 =
      find.byValueKey(Keys.viewRecipeIngredientText + "3");
  static final viewRecipeIngredientText4 =
      find.byValueKey(Keys.viewRecipeIngredientText + "4");
  static final viewRecipeIngredientText5 =
      find.byValueKey(Keys.viewRecipeIngredientText + "5");
  static final viewRecipeIngredientLabelText0 =
      find.byValueKey(Keys.viewRecipeIngredientLabelText + "0");
  static final viewRecipeIngredientLabelText1 =
      find.byValueKey(Keys.viewRecipeIngredientLabelText + "1");
  static final viewRecipeIngredientLabelText2 =
      find.byValueKey(Keys.viewRecipeIngredientLabelText + "2");
  static final viewRecipeAddToGroceryListAction1 =
      find.byValueKey(Keys.viewRecipeAddToGroceryListAction + "1");
  static final viewRecipeInstructionText =
      find.byValueKey(Keys.viewRecipeInstructionText);
  static final SerializableFinder backButtonFinder = find.byTooltip("Voltar");
  static final viewRecipeFloatingActionEditButton =
      find.byValueKey(Keys.viewRecipeFloatingActionEditButton);
  static final viewRecipeShareRecipeAction =
      find.byValueKey(Keys.viewRecipeShareRecipeAction);
  static final viewRecipeCopyContentToClipboardAction =
      find.byValueKey(Keys.viewRecipeCopyContentToClipboardAction);
  static final viewRecipeShareAsImagesAction =
      find.byValueKey(Keys.viewRecipeShareAsImagesAction);
  static final viewRecipeShareAsPdfAction =
      find.byValueKey(Keys.viewRecipeShareAsPdfAction);
  static final viewRecipeAddToGroceryListAction =
      find.byValueKey(Keys.viewRecipeAddToGroceryListAction);
  static final viewRecipeGroceryListToSelect0 =
      find.byValueKey(Keys.viewRecipeGroceryListToSelect + '0');
  static final viewRecipeCreateNewGroceryListAction =
      find.byValueKey(Keys.viewRecipeCreateNewGroceryListAction);
  static final addRecipeToGroceryListDialogPortionTextField =
      find.byValueKey(Keys.addRecipeToGroceryListDialogPortionTextField);
  static final addRecipeToGroceryListDialogConfirmButton =
      find.byValueKey(Keys.addRecipeToGroceryListDialogConfirmButton);
  static final groceryListRowTitleText0 =
      find.byValueKey(Keys.groceryListRowTitleText + "0");
  static final groceryListRowShowRecipes0 =
      find.byValueKey(Keys.groceryListRowShowRecipes + "0");
  static final groceryListRowTitleText1 =
      find.byValueKey(Keys.groceryListRowTitleText + "1");
  static final groceryListRecipesDialogRecipe0 =
      find.byValueKey(Keys.groceryListRecipesDialogRecipe + "0");
  static final groceryListRecipesDialogRecipe1 =
      find.byValueKey(Keys.groceryListRecipesDialogRecipe + "1");
  static final groceryListRecipesDialogCloseButton =
      find.byValueKey(Keys.groceryListRecipesDialogCloseButton);
  static final groceryItemTextField0 =
      find.byValueKey(Keys.groceryItemTextField + "0");
  static final groceryItemTextField1 =
      find.byValueKey(Keys.groceryItemTextField + "1");
  static final groceryItemTextField2 =
      find.byValueKey(Keys.groceryItemTextField + "2");
  static final groceryItemTextField3 =
      find.byValueKey(Keys.groceryItemTextField + "3");
  static final groceryItemCheckBox1 =
      find.byValueKey(Keys.groceryItemCheckBox + "1");
  static final saveGroceryListShowChecked =
      find.byValueKey(Keys.saveGroceryListShowChecked);
  static final groceryItemActionIcon1 =
      find.byValueKey(Keys.groceryItemActionIcon + "1");
  static final groceryItemActionIcon2 =
      find.byValueKey(Keys.groceryItemActionIcon + "2");
  static final saveGroceryListBottomActionIcon =
      find.byValueKey(Keys.saveGroceryListBottomActionIcon);
  static final ingredientRecipeSourceDialogRecipe0 =
      find.byValueKey(Keys.ingredientRecipeSourceDialogRecipe + "0");
  static final ingredientRecipeSourceDialogRecipeIngredientQuantity0 =
      find.byValueKey(
          Keys.ingredientRecipeSourceDialogRecipeIngredientQuantity + "0");
  static final ingredientRecipeSourceDialogCloseButton =
      find.byValueKey(Keys.ingredientRecipeSourceDialogCloseButton);
  static final saveGroceryListArchiveAction =
      find.byValueKey(Keys.saveGroceryListArchiveAction);
  static final saveGroceryListArchiveConfirm =
      find.byValueKey(Keys.saveGroceryListArchiveConfirm);
  static final settingsLocalButtton =
      find.byValueKey(Keys.settingsLocalButtton);
  static final settingsConfiguredAtText =
      find.byValueKey(Keys.settingsConfiguredAtText);
  static final settingsDoBackupButton =
      find.byValueKey(Keys.settingsDoBackupButton);
  static final menuPlanningDayAddMealButton0 =
      find.byValueKey(Keys.menuPlanningDayAddMealButton + "-0");
  static final menuPlanningDayAddMealButton1 =
      find.byValueKey(Keys.menuPlanningDayAddMealButton + "-1");
  static final menuPlanningDayPickRecipeTextButton00 =
      find.byValueKey(Keys.menuPlanningDayPickRecipeTextButton + "-0-0");
  static final menuPlanningDayPickRecipeTextButton10 =
      find.byValueKey(Keys.menuPlanningDayPickRecipeTextButton + "-1-0");
  static final menuPlanningWriteDetailsTextButton01 =
      find.byValueKey(Keys.menuPlanningWriteDetailsTextButton + "-0-1");
  static final menuPlanningWriteDetailsTextField01 =
      find.byValueKey(Keys.menuPlanningWriteDetailsTextField + "-0-1");
  static final menuPlanningDayAddMealButton00 =
      find.byValueKey(Keys.menuPlanningDayAddMealButton + "-0-0");
  static final recipesListFilter = find.byValueKey(Keys.recipesListFilter);
  static final saveMenuPlanningFloatingActionSaveButton =
      find.byValueKey(Keys.saveMenuPlanningFloatingActionSaveButton);
  static final menuPlanningDaysMealText00 =
      find.byValueKey(Keys.menuPlanningDaysMealText + "-0-0");
  static final menuPlanningDaysMealText01 =
      find.byValueKey(Keys.menuPlanningDaysMealText + "-0-1");
  static final menuPlanningDaysMealText10 =
      find.byValueKey(Keys.menuPlanningDaysMealText + "-1-0");
  static final menuPlanningDaysMealTextButton00 =
      find.byValueKey(Keys.menuPlanningDaysMealTextButton + "-0-0");
  static final menuPlanningDaysMealDescriptionText00 =
      find.byValueKey(Keys.menuPlanningDaysMealDescriptionText + "-0-0");
  static final menuPlanningDaysMealDescriptionText01 =
      find.byValueKey(Keys.menuPlanningDaysMealDescriptionText + "-0-1");
  static final menuPlanningDaysMealTextButton10 =
      find.byValueKey(Keys.menuPlanningDaysMealTextButton + "-1-0");
  static final homeCardSeeMenuPlanning =
      find.byValueKey(Keys.homeCardSeeMenuPlanning);
  static final viewMenuPlanningFloatingActionEditButton =
      find.byValueKey(Keys.viewMenuPlanningFloatingActionEditButton);
  static final saveMenuPlanningStartAtIcon =
      find.byValueKey(Keys.saveMenuPlanningStartAtIcon);
}
