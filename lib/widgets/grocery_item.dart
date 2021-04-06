import 'package:flutter/material.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list_item.dart';
import 'package:rtg_app/model/recipe.dart';

import 'grocery_item_suffix_icon.dart';
import 'ingredient_recipe_source_dialog.dart';

class GroceryItem extends StatefulWidget {
  GroceryItem(
      {Key key,
      this.groceryListItem,
      this.recipes,
      this.index,
      this.focusNode,
      this.onCheck,
      this.onEditName,
      this.onAddNewField,
      this.onRemoveField,
      this.showRecipeSource})
      : super(key: key);

  final GroceryListItem groceryListItem;
  final List<Recipe> recipes;
  final int index;
  final FocusNode focusNode;
  final Function(bool checked, GroceryListItem groceryListItem, int index)
      onCheck;
  final Function(GroceryListItem groceryListItem, int index) onEditName;
  final void Function(int index) onAddNewField;
  final void Function(int index) onRemoveField;
  final bool showRecipeSource;

  @override
  _GroceryItemState createState() => _GroceryItemState();
}

class _GroceryItemState extends State<GroceryItem> {
  TextEditingController _nameController;
  GlobalKey<GroceryItemSuffixIconState> _deleteItemKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    widget.focusNode.addListener(() {
      if (_deleteItemKey != null && _deleteItemKey.currentState != null) {
        _deleteItemKey.currentState.onFocusChange(widget.focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(() {});
    _nameController.dispose();
    super.dispose();
  }

  Widget buildActionIcon() {
    if (widget.showRecipeSource &&
        widget.groceryListItem.recipes != null &&
        widget.groceryListItem.recipes.length > 0) {
      return IconButton(
          key: Key(Keys.groceryItemActionIcon + widget.index.toString()),
          icon: Icon(Icons.library_books),
          onPressed: () {
            IngredientRecipeSourceDialog.showIngredientRecipeSourceDialog(
              context: context,
              groceryListItem: widget.groceryListItem,
              recipes: widget.recipes,
            );
          });
    }
    return Icon(
      Icons.drag_indicator,
      key: Key(Keys.groceryItemActionIcon + widget.index.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = widget.groceryListItem.name;
    });
    return Row(
      children: [
        SizedBox(
          height: 48,
          width: 36,
          child: Center(
            child: buildActionIcon(),
          ),
        ),
        Checkbox(
          activeColor: Colors.lightBlueAccent,
          key: Key(Keys.groceryItemCheckBox + widget.index.toString()),
          value: widget.groceryListItem.checked ?? false,
          onChanged: (checked) {
            setState(() {
              widget.groceryListItem.checked = checked;
            });
            widget.onCheck(checked, widget.groceryListItem, widget.index);
          },
        ),
        Flexible(
            child: TextFormField(
              key: Key(Keys.groceryItemTextField + widget.index.toString()),
              controller: _nameController,
              style: TextStyle(
                decoration: widget.groceryListItem.checked ?? false
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
              textInputAction: TextInputAction.newline,
              maxLines: null,
              focusNode: widget.focusNode,
              onChanged: (v) {
                if (v.contains("\n")) {
                  _nameController.text = v.replaceAll("\n", "");
                  _nameController.selection = TextSelection(
                    baseOffset: _nameController.text.toString().length,
                    extentOffset: _nameController.text.toString().length,
                  );
                  widget.onAddNewField(widget.index);
                  return;
                }

                widget.groceryListItem.name = _nameController.text;
                widget.onEditName(widget.groceryListItem, widget.index);
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
            flex: 1),
      ],
    );
  }
}
