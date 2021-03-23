import 'package:flutter/material.dart';

class TextFormListFields extends StatefulWidget {
  final int index;
  final String initValue;
  final bool canBeRemoved;
  final void Function(int index, String value) onChanged;
  final void Function(int index) onAddNewField;
  final void Function(int index) onRemoveField;
  final FocusNode focusNode;

  TextFormListFields({
    this.index,
    this.initValue,
    this.canBeRemoved,
    this.onChanged,
    this.onAddNewField,
    this.onRemoveField,
    this.focusNode,
  });
  @override
  _TextFormListFieldsState createState() => _TextFormListFieldsState();
}

class _TextFormListFieldsState extends State<TextFormListFields> {
  TextEditingController _nameController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = widget.initValue;
    });
    return TextFormField(
      controller: _nameController,
      textInputAction: TextInputAction.newline,
      maxLines: null,
      focusNode: widget.focusNode,
      onChanged: (v) {
        if (v.contains("\n")) {
          _nameController.text = v.replaceAll("\n", "");
          widget.onAddNewField(widget.index);
          return;
        }
        widget.onChanged(widget.index, v);
      },
      decoration: InputDecoration(
        hintText: 'Digite o nome do ingrediente',
        suffixIcon: widget.canBeRemoved
            ? null
            : IconButton(
                onPressed: () {
                  widget.onRemoveField(widget.index);
                },
                icon: Icon(Icons.clear),
              ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}
