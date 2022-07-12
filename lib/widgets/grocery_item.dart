import 'package:flutter/material.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list_item.dart';
import 'package:rtg_app/model/market_section.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/widgets/choose_market_section_dialog.dart';

import 'grocery_item_suffix_icon.dart';
import 'ingredient_recipe_source_dialog.dart';

class GroceryItem extends StatefulWidget {
  GroceryItem(
      {Key key,
      this.groceryListItem,
      this.recipes,
      this.marketSections,
      this.index,
      this.nameController,
      this.focusNode,
      this.onCheck,
      this.onEdit,
      this.onAddNewField,
      this.onRemoveField,
      this.showRecipeSource,
      this.showGroceryItemLabel})
      : super(key: key);

  final GroceryListItem groceryListItem;
  final List<Recipe> recipes;
  final List<MarketSection> marketSections;
  final int index;
  final TextEditingController nameController;
  final FocusNode focusNode;
  final Function(bool checked, GroceryListItem groceryListItem, int index)
      onCheck;
  final Function(GroceryListItem groceryListItem, int index) onEdit;
  final void Function(int index) onAddNewField;
  final void Function(int index) onRemoveField;
  final bool showRecipeSource;
  final bool showGroceryItemLabel;

  @override
  _GroceryItemState createState() => _GroceryItemState();
}

class _GroceryItemState extends State<GroceryItem> {
  GlobalKey<GroceryItemSuffixIconState> _deleteItemKey = GlobalKey();
  String initialText;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (_deleteItemKey != null && _deleteItemKey.currentState != null) {
        _deleteItemKey.currentState.onFocusChange(widget.focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(() {});
    super.dispose();
  }

  Widget buildActionIcon() {
    Widget icon;
    if (widget.showRecipeSource &&
        widget.groceryListItem.recipeIngredients != null &&
        widget.groceryListItem.recipeIngredients.length > 0) {
      icon = IconButton(
          key: Key(Keys.groceryItemActionIcon + widget.index.toString()),
          icon: Icon(Icons.library_books),
          onPressed: () {
            IngredientRecipeSourceDialog.showIngredientRecipeSourceDialog(
              context: context,
              groceryListItem: widget.groceryListItem,
              recipes: widget.recipes,
            );
          });
    } else if (widget.groceryListItem.checked ?? false) {
      icon = SizedBox(
        width: 1,
      );
    } else {
      icon = Icon(
        Icons.drag_indicator,
        key: Key(Keys.groceryItemActionIcon + widget.index.toString()),
      );
    }

    return SizedBox(
      height: 48,
      width: 36,
      child: Center(
        child: icon,
      ),
    );
  }

  buildTextFormField() {
    if (widget.showGroceryItemLabel) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            widget.nameController.text,
            key: Key(Keys.groceryItemTextField + widget.index.toString()),
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  decoration: widget.groceryListItem.checked ?? false
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
            maxLines: null,
          ),
        ),
      );
    }
    return Flexible(
      child: TextFormField(
        key: Key(Keys.groceryItemTextField + widget.index.toString()),
        controller: widget.nameController,
        style: TextStyle(
          decoration: widget.groceryListItem.checked ?? false
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
        textInputAction: TextInputAction.newline,
        maxLines: null,
        focusNode: widget.focusNode,
        onChanged: (v) {
          if (initialText == v) {
            return;
          }

          if (v.contains("\n")) {
            widget.nameController.text = v.replaceAll("\n", "");
            initialText = widget.nameController.text;
            widget.onAddNewField(widget.index);
            return;
          }

          initialText = widget.nameController.text;
          GroceryListItem newItem =
              GroceryListItem.fromInput(widget.nameController.text);
          widget.groceryListItem.ingredientName = newItem.ingredientName;
          widget.groceryListItem.quantity = newItem.quantity;
          widget.groceryListItem.measureId = newItem.measureId;
          widget.onEdit(widget.groceryListItem, widget.index);
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          suffixIcon: GroceryItemSuffixIcon(
            key: _deleteItemKey,
            onPressed: () {
              widget.focusNode.removeListener(() {});
              widget.onRemoveField(widget.index);
            },
          ),
        ),
      ),
      flex: 1,
    );
  }

  Widget buildCheckbox() {
    return Checkbox(
      key: Key(Keys.groceryItemCheckBox + widget.index.toString()),
      value: widget.groceryListItem.checked ?? false,
      onChanged: (checked) {
        setState(() {
          widget.groceryListItem.checked = checked;
        });
        widget.onCheck(checked, widget.groceryListItem, widget.index);
      },
    );
  }

  List<Widget> buildShowGroceryAction() {
    List<Widget> children = [
      SizedBox(
        width: 8,
      )
    ];
    if (widget.groceryListItem.marketSectionId != null) {
      MarketSection marketSection = MarketSection.getFromList(
          widget.groceryListItem.marketSectionId, widget.marketSections);
      children.addAll([
        Text(
          marketSection.title,
          key: Key(Keys.groceryItemMarketSectionText + widget.index.toString()),
          style: Theme.of(context).textTheme.caption,
        ),
        IconButton(
            key: Key(Keys.groceryItemEditMarketSectionIcon +
                widget.index.toString()),
            icon: Icon(Icons.edit),
            onPressed: () {
              ChooseMarketSectionDialog.showChooseMarketSectionDialog(
                  context: context,
                  marketSections: widget.marketSections,
                  onSelectMarketSection: onSelectMarketSection);
            })
      ]);
    } else {
      children.add(IconButton(
          key: Key(
              Keys.groceryItemAddMarketSectionIcon + widget.index.toString()),
          icon: Icon(Icons.new_label),
          onPressed: () {
            ChooseMarketSectionDialog.showChooseMarketSectionDialog(
                context: context,
                marketSections: widget.marketSections,
                onSelectMarketSection: onSelectMarketSection);
          }));
    }
    return children;
  }

  void onSelectMarketSection(MarketSection selected) {
    if (selected == null) {
      widget.groceryListItem.marketSectionId = null;
    } else {
      widget.groceryListItem.marketSectionId = selected.id;
    }
    setState(() {
      widget.onEdit(widget.groceryListItem, widget.index);
    });
  }

  Widget buildRow() {
    List<Widget> children = [];
    if (!widget.showGroceryItemLabel) {
      children.addAll([buildActionIcon(), buildCheckbox()]);
    }

    children.add(buildTextFormField());

    if (widget.showGroceryItemLabel) {
      children.addAll(buildShowGroceryAction());
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialText = widget.groceryListItem.getName(context);
      widget.nameController.text = initialText;
    });

    return (widget.showGroceryItemLabel || widget.groceryListItem.checked ??
            false)
        ? GestureDetector(
            onLongPress: () {},
            key: Key(Keys.groceryItemRow),
            child: buildRow(),
          )
        : buildRow();
  }
}
