import 'package:flutter/material.dart';

class GroceryItemSuffixIcon extends StatefulWidget {
  final Function onPressed;

  GroceryItemSuffixIcon({Key key, this.onPressed}) : super(key: key);

  @override
  GroceryItemSuffixIconState createState() => GroceryItemSuffixIconState();
}

class GroceryItemSuffixIconState extends State<GroceryItemSuffixIcon> {
  bool showIcon;

  @override
  void initState() {
    super.initState();
    showIcon = false;
  }

  onFocusChange(bool hasFocus) async {
    setState(() {
      showIcon = hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.onPressed();
      },
      color: showIcon ? null : Colors.transparent,
      icon: Icon(Icons.clear),
    );
  }
}
