import 'package:flutter/material.dart';

class MarketSectionItemSuffixIcon extends StatefulWidget {
  final Function onPressed;

  MarketSectionItemSuffixIcon({Key key, this.onPressed}) : super(key: key);

  @override
  MarketSectionItemSuffixIconState createState() =>
      MarketSectionItemSuffixIconState();
}

class MarketSectionItemSuffixIconState
    extends State<MarketSectionItemSuffixIcon> {
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
