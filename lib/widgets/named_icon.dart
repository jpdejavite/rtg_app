import 'package:flutter/material.dart';

class NamedIcon extends StatelessWidget {
  final IconData iconData;
  final String tooltip;
  final VoidCallback onPressed;
  final bool showNotification;
  final int notificationCount;
  final String notificationKey;

  const NamedIcon(
      {Key key,
      this.onPressed,
      @required this.tooltip,
      @required this.iconData,
      @required this.showNotification,
      this.notificationKey,
      this.notificationCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isClickable = onPressed != null;

    List<Widget> children = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !isClickable
              ? Icon(iconData)
              : IconButton(
                  icon: Icon(iconData),
                  tooltip: tooltip,
                  onPressed: onPressed,
                ),
        ],
      ),
    ];

    if (showNotification) {
      String text = notificationCount == 0 || notificationCount == null
          ? ''
          : '$notificationCount';
      children.add(Positioned(
        key: Key(notificationKey),
        top: isClickable ? 4 : -4,
        right: isClickable ? 8 : 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          alignment: Alignment.center,
          child: Text(text),
        ),
      ));
    }

    return InkWell(
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: children,
        ),
      ),
    );
  }
}
