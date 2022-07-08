import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/theme/custom_colors.dart';

class HomeCard extends StatelessWidget {
  final Key cardKey;
  final Key dimissKey;
  final Key actionKey;
  final Key secundaryActionKey;
  final IconData icon;
  final Color iconColor;
  final String title;
  final IconData titleIcon;
  final String subtitle;
  final String action;
  final String secundaryAction;
  final void Function() onDismiss;
  final void Function() onAction;
  final void Function() onSecundaryAction;

  HomeCard({
    this.cardKey,
    this.dimissKey,
    this.actionKey,
    this.secundaryActionKey,
    this.icon,
    this.iconColor,
    this.title,
    this.titleIcon,
    this.subtitle,
    this.onDismiss,
    this.action,
    this.secundaryAction,
    this.onAction,
    this.onSecundaryAction,
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

    if (onSecundaryAction != null) {
      buttons.add(
        TextButton(
          key: secundaryActionKey,
          child: Text(
            secundaryAction,
            style: TextStyle(color: CustomColors.ligthGrey),
          ),
          onPressed: onSecundaryAction,
        ),
      );
    }

    if (action != null) {
      buttons.addAll([
        Expanded(child: SizedBox(width: 8)),
        TextButton(
          key: actionKey,
          child: Text(action),
          onPressed: onAction,
        ),
        const SizedBox(width: 8),
      ]);
    }

    List<Widget> children = <Widget>[
      ListTile(
        leading: icon == null ? null : Icon(icon, color: iconColor),
        title: this.titleIcon == null
            ? Text(title, style: Theme.of(context).textTheme.headline5)
            : Row(children: [
                Expanded(
                    child: Text(title,
                        style: Theme.of(context).textTheme.headline5)),
                IconButton(
                  onPressed: () => {},
                  icon: Icon(this.titleIcon),
                  tooltip: "fazer anotações",
                  color: CustomColors.primaryColor,
                )
              ]),
        subtitle: subtitle != null ? Text(subtitle) : null,
      ),
    ];

    Widget extra = buildExtraWidget(context);
    if (extra != null) {
      children.add(extra);
    }

    if (buttons.length > 0) {
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: buttons,
        ),
      );
    }

    return Card(
      key: cardKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget buildExtraWidget(BuildContext context) {
    return null;
  }
}
