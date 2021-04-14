import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/bloc/save_grocery_list/events.dart';
import 'package:rtg_app/bloc/save_grocery_list/save_grocery_list_bloc.dart';
import 'package:rtg_app/bloc/save_grocery_list/states.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_list_item.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/widgets/custom_toast.dart';
import 'package:rtg_app/widgets/grocery_item.dart';
import 'package:sprintf/sprintf.dart';

class SaveGroceryListScreen extends StatefulWidget {
  static String id = 'save_grocery_list_screen';
  final GroceryList editGroceryList;

  SaveGroceryListScreen(this.editGroceryList);

  static newSaveGroceryListBloc(GroceryList args) {
    return BlocProvider(
      create: (context) => SaveGroceryListBloc(
        groceryListsRepo: GroceryListsRepository(),
        recipesRepository: RecipesRepository(),
      ),
      child: SaveGroceryListScreen(args),
    );
  }

  @override
  _SaveGroceryListState createState() => _SaveGroceryListState();
}

class _SaveGroceryListState extends State<SaveGroceryListScreen> {
  GroceryList editGroceryList;
  TextEditingController _titleController;
  FocusNode titleFocusNodes;
  bool isLoading;
  bool showChecked;
  bool showRecipeSource;
  bool hasKeyboardOpenOnce;
  List<Recipe> recipes;
  Map<GroceryListItem, FocusNode> focusNodes;
  GroceryListItem itemToFocus;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    showChecked = false;
    showRecipeSource = false;
    _titleController =
        TextEditingController(text: widget.editGroceryList.title);
    context
        .read<SaveGroceryListBloc>()
        .add(LoadGroceryListRecipesEvent(widget.editGroceryList));

    titleFocusNodes = FocusNode();
    focusNodes = Map();
    if (widget.editGroceryList != null) {
      widget.editGroceryList.groceries.forEach((ingredient) {
        addFocusNode(ingredient);
      });
    }

    itemToFocus = null;
    hasKeyboardOpenOnce = false;
    editGroceryList = widget.editGroceryList;
  }

  void addFocusNode(GroceryListItem item) {
    FocusNode focusNode = FocusNode();
    focusNodes[item] = focusNode;
  }

  void checkKeyboardVisibility() {
    bool isKeyboardVisible = !(MediaQuery.of(context).viewInsets.bottom == 0.0);
    if (!isKeyboardVisible && hasKeyboardOpenOnce) {
      hasKeyboardOpenOnce = false;
      focusNodes.forEach((i, focus) {
        if (focus.hasFocus) {
          focus.unfocus();
        }
      });

      if (titleFocusNodes.hasFocus) {
        titleFocusNodes.unfocus();
      }

      context
          .read<SaveGroceryListBloc>()
          .add(SaveGroceryListEvent(editGroceryList));
      isLoading = true;
    }
    if (isKeyboardVisible) {
      hasKeyboardOpenOnce = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    focusNodes.forEach((i, focus) {
      focus.dispose();
    });
    titleFocusNodes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).edit_grocery_list),
        actions: [
          IconButton(
            key: Key(Keys.saveGroceryListArchiveAction),
            icon: Icon(Icons.archive),
            tooltip: AppLocalizations.of(context).archive_grocery_list,
            onPressed: () {
              showArchiveGroceryListDialog(context);
            },
          )
        ],
      ),
      body: buildBody(),
    );
  }

  Future<void> showArchiveGroceryListDialog(BuildContext ctx) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).archive_grocery_list),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(AppLocalizations.of(context)
                    .archive_grocery_list_explanation)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              key: Key(Keys.saveGroceryListArchiveCancel),
              child: Text(AppLocalizations.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              key: Key(Keys.saveGroceryListArchiveConfirm),
              child: Text(AppLocalizations.of(context).confirm),
              onPressed: () {
                Navigator.of(context).pop();
                ctx
                    .read<SaveGroceryListBloc>()
                    .add(ArchiveGroceryListEvent(editGroceryList));
                isLoading = true;
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildBody() {
    return BlocBuilder<SaveGroceryListBloc, SaveGroceryListState>(
        builder: (BuildContext context, SaveGroceryListState state) {
      if (state is GroceryListSaved) {
        isLoading = false;
        editGroceryList = state.response.groceryList;
        if (state.response.error != null) {
          CustomToast.showToast(
            text: AppLocalizations.of(context).generic_error_save_grocery_list,
            context: context,
          );
        } else if (editGroceryList.status == GroceryListStatus.archived) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => Navigator.of(context).pop());
        }
      } else if (state is GroceryListRecipesLoaded) {
        recipes = state.recipes;
      }

      checkKeyboardVisibility();
      return buildForm(context);
    });
  }

  GroceryItem newGroceryItem(GroceryListItem item, int index) {
    return GroceryItem(
      key: Key('${Keys.saveGroceryListGroceryItem}-$index'),
      groceryListItem: item,
      recipes: recipes,
      index: index,
      focusNode: focusNodes[item],
      showRecipeSource: showRecipeSource,
      onCheck: (bool checked, GroceryListItem groceryListItem, int i) {
        setState(() {
          editGroceryList.groceries[i] = groceryListItem;
          context
              .read<SaveGroceryListBloc>()
              .add(SaveGroceryListEvent(editGroceryList));
          isLoading = true;
        });
      },
      onEditName: (GroceryListItem groceryListItem, int i) {
        editGroceryList.groceries[i] = groceryListItem;
        context
            .read<SaveGroceryListBloc>()
            .add(SaveGroceryListSilentlyEvent(editGroceryList));
      },
      onAddNewField: (int i) {
        setState(() {
          GroceryListItem newItem = GroceryListItem.newEmptyGroceryListItem();
          editGroceryList.groceries.insert(i + 1, newItem);
          context
              .read<SaveGroceryListBloc>()
              .add(SaveGroceryListEvent(editGroceryList));
          addFocusNode(newItem);
          itemToFocus = newItem;
          isLoading = true;
        });
      },
      onRemoveField: (i) {
        setState(() {
          GroceryListItem removedItem = editGroceryList.groceries.removeAt(i);
          focusNodes[removedItem].unfocus();
          focusNodes.remove(removedItem);

          itemToFocus = null;
          isLoading = true;
          context
              .read<SaveGroceryListBloc>()
              .add(SaveGroceryListEvent(editGroceryList));
        });
      },
    );
  }

  Widget buildCheckedDivider(List<Widget> checkedChildren) {
    String checkItemsText = checkedChildren.length > 1
        ? AppLocalizations.of(context).checked_items
        : AppLocalizations.of(context).checked_item;
    return TextButton(
      key: Key(Keys.saveGroceryListShowChecked),
      onPressed: () {
        setState(() {
          showChecked = !showChecked;
        });
      },
      child: Row(
        children: [
          Icon(showChecked
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down),
          Text(
            '${checkedChildren.length} $checkItemsText',
          )
        ],
      ),
    );
  }

  Widget buildTitleField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        key: Key(Keys.saveGroceryListTitleField),
        controller: _titleController,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        onChanged: (String newValue) {
          editGroceryList.title = _titleController.text;
          context
              .read<SaveGroceryListBloc>()
              .add(SaveGroceryListSilentlyEvent(editGroceryList));
        },
      ),
    );
  }

  Widget buildBottombar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: SizedBox(
            child: isLoading ? CircularProgressIndicator() : null,
            height: 24,
            width: 24,
          ),
        ),
        Text(sprintf(AppLocalizations.of(context).updated_at_date, [
          DateFormatter.formatDateInMili(editGroceryList.updatedAt,
              AppLocalizations.of(context).updated_at_format)
        ])),
        IconButton(
            key: Key(Keys.saveGroceryListBottomActionIcon),
            icon: Icon(
                showRecipeSource ? Icons.drag_indicator : Icons.library_books),
            onPressed: () {
              setState(() {
                showRecipeSource = !showRecipeSource;
              });
            }),
      ],
    );
  }

  void onReorderListItems(oldIndex, newIndex) {
    if (oldIndex == newIndex) {
      return;
    }
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      GroceryListItem groceryListItem =
          editGroceryList.groceries.removeAt(oldIndex);
      editGroceryList.groceries.insert(newIndex, groceryListItem);
      isLoading = true;
      context
          .read<SaveGroceryListBloc>()
          .add(SaveGroceryListEvent(editGroceryList));
    });
  }

  Widget buildForm(BuildContext context) {
    List<Widget> uncheckedChildren = [];
    List<Widget> checkedChildren = [];

    if (itemToFocus != null) {
      focusNodes[itemToFocus].requestFocus();
    }

    editGroceryList.groceries.asMap().forEach((index, item) {
      GroceryItem groceryItem = newGroceryItem(item, index);
      if ((item.checked ?? false)) {
        checkedChildren.add(groceryItem);
      } else {
        uncheckedChildren.add(groceryItem);
      }
    });

    if (uncheckedChildren.length == 0) {
      GroceryListItem newItem = GroceryListItem.newEmptyGroceryListItem();
      editGroceryList.groceries.insert(0, newItem);
      context
          .read<SaveGroceryListBloc>()
          .add(SaveGroceryListEvent(editGroceryList));
      addFocusNode(newItem);
      isLoading = true;
    }
    if (checkedChildren.length > 0) {
      uncheckedChildren.add(buildCheckedDivider(checkedChildren));
    }

    if (!showChecked) {
      checkedChildren = [];
    }

    return Column(
      children: [
        buildTitleField(),
        Flexible(
          child: ReorderableListView(
            onReorder: onReorderListItems,
            children: [...uncheckedChildren, ...checkedChildren],
          ),
          flex: 1,
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey),
        buildBottombar(),
      ],
    );
  }
}
