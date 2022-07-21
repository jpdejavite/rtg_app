import 'package:flutter/material.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/market_section.dart';
import 'package:rtg_app/widgets/market_section_item_suffix_icon%20.dart';

class MarketSectionItem extends StatefulWidget {
  MarketSectionItem({
    Key key,
    this.marketSection,
    this.index,
    this.nameController,
    this.focusNode,
    this.onEdit,
    this.onAddNewField,
    this.onRemoveField,
  }) : super(key: key);

  final MarketSection marketSection;
  final int index;
  final TextEditingController nameController;
  final FocusNode focusNode;
  final Function(MarketSection marketSection, int index) onEdit;
  final void Function(int index) onAddNewField;
  final void Function(int index) onRemoveField;

  @override
  _MarketSectionItemState createState() => _MarketSectionItemState();
}

class _MarketSectionItemState extends State<MarketSectionItem> {
  GlobalKey<MarketSectionItemSuffixIconState> _deleteItemKey = GlobalKey();
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
    return SizedBox(
      height: 48,
      width: 36,
      child: Center(
        child: Icon(
          Icons.drag_indicator,
          key: Key('${Keys.marketSectionItemActionIcon}-${widget.index}'),
        ),
      ),
    );
  }

  buildTextFormField() {
    return Flexible(
      child: TextFormField(
        key: Key('${Keys.marketSectionItemTextField}-${widget.index}'),
        controller: widget.nameController,
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

          widget.marketSection.title = widget.nameController.text;
          widget.onEdit(widget.marketSection, widget.index);
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          suffixIcon: MarketSectionItemSuffixIcon(
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

  Widget buildRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [buildActionIcon(), buildTextFormField()],
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialText = widget.marketSection.title;
      widget.nameController.text = initialText;
    });

    return buildRow();
  }
}
