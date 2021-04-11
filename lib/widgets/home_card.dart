import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeCard extends StatelessWidget {
  final Key cardKey;
  final Key dimissKey;
  final Key actionKey;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String action;
  final void Function() onDismiss;
  final void Function() onAction;

  HomeCard({
    this.cardKey,
    this.dimissKey,
    this.actionKey,
    this.icon,
    this.iconColor,
    this.title,
    this.subtitle,
    this.onDismiss,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    if (onDismiss != null) {
      buttons.add(
        TextButton(
          key: dimissKey,
          child: Text(AppLocalizations.of(context).dismiss),
          onPressed: onDismiss,
        ),
      );
    }

    buttons.addAll([
      const SizedBox(width: 8),
      TextButton(
        key: actionKey,
        child: Text(action),
        onPressed: onAction,
      ),
      const SizedBox(width: 8),
    ]);

    return Card(
      key: cardKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(icon, color: iconColor),
            title: Text(title),
            subtitle: Text(subtitle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: buttons,
          ),
        ],
      ),
    );
  }
}
