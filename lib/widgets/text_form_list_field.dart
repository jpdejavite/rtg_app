import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/theme/custom_colors.dart';

class TextFormListFields extends StatelessWidget {
  final Key textKey;
  final Key iconKey;
  final TextEditingController textEditingController;
  final String initValue;
  final String hintText;
  final bool canBeRemoved;
  final bool hasLabel;
  final bool isLabel;
  final void Function(String value) onChanged;
  final void Function() onAddNewField;
  final void Function() onRemoveField;
  final FocusNode focusNode;

  TextFormListFields({
    this.textKey,
    this.iconKey,
    this.textEditingController,
    this.initValue,
    this.hintText,
    this.canBeRemoved = true,
    this.hasLabel,
    this.isLabel,
    this.onChanged,
    this.onAddNewField,
    this.onRemoveField,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Expanded(
          child: TextFormField(
        key: textKey,
        controller: textEditingController,
        textInputAction: onAddNewField == null
            ? TextInputAction.next
            : TextInputAction.newline,
        maxLines: onAddNewField == null ? 1 : null,
        focusNode: focusNode,
        onChanged: (v) {
          if (v.contains("\n")) {
            textEditingController.text = v.replaceAll("\n", "");
            if (onAddNewField != null) {
              onAddNewField();
            }
            return;
          }
          onChanged(v);
        },
        style: TextStyle(fontWeight: isLabel ? FontWeight.bold : null),
        decoration: InputDecoration(hintText: hintText),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context).fill_this_required_field;
          }
          if (value.length < 3) {
            return AppLocalizations.of(context).type_in_3_chars;
          }
          return null;
        },
      )),
    ];

    if (canBeRemoved) {
      children.add(IconButton(
        key: iconKey,
        onPressed: () {
          onRemoveField();
        },
        icon: Icon(
          Icons.clear,
          color: CustomColors.primaryColor,
        ),
      ));
    }
    return Padding(
      padding: EdgeInsets.only(left: hasLabel ? 15 : 0),
      child: Row(
        children: children,
      ),
    );
  }
}
