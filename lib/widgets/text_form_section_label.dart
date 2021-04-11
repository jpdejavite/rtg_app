import 'package:flutter/material.dart';

class TextFormSectionLabelFields extends StatelessWidget {
  final String text;
  final IconData icon;
  final String iconTooltip;
  final Function onIconPressed;

  TextFormSectionLabelFields(this.text,
      {this.icon, this.iconTooltip, this.onIconPressed});

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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [textWidget],
    );
    if (icon != null) {
      textWithIcon.children.add(IconButton(
          icon: Icon(icon), tooltip: iconTooltip, onPressed: onIconPressed));
    }
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: icon == null ? textWidget : textWithIcon,
    );
  }
}
