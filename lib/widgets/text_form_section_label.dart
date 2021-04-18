import 'package:flutter/material.dart';

class TextFormSectionLabelIcon {
  final Key key;
  final IconData icon;
  final String tooltip;
  final Function onPressed;

  TextFormSectionLabelIcon({this.key, this.icon, this.tooltip, this.onPressed});
}

class TextFormSectionLabelFields extends StatelessWidget {
  final String text;
  final double paddingTop;
  final List<TextFormSectionLabelIcon> icons;

  TextFormSectionLabelFields(this.text, {this.icons, this.paddingTop});

  @override
  Widget build(BuildContext context) {
    Text textWidget = Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Theme.of(context).textTheme.caption.color,
      ),
    );

    Row textWithIcon = Row(
      children: [Expanded(child: textWidget)],
    );
    if (icons != null) {
      icons.forEach((icon) {
        textWithIcon.children.add(IconButton(
            key: icon.key,
            icon: Icon(icon.icon),
            tooltip: icon.tooltip,
            onPressed: icon.onPressed));
      });
    }
    return Padding(
      padding: EdgeInsets.only(top: paddingTop ?? 20),
      child: textWithIcon,
    );
  }
}
