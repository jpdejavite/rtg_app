import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';

import '../model/market_section.dart';

class ChooseMarketSectionDialog extends StatefulWidget {
  final MarketSection current;
  final List<MarketSection> marketSections;
  final void Function(MarketSection selected) onSelectMarketSection;

  ChooseMarketSectionDialog({
    this.current,
    this.marketSections,
    this.onSelectMarketSection,
  });
  @override
  _ChooseMarketSectionDialogState createState() =>
      _ChooseMarketSectionDialogState();

  static Future<void> showChooseMarketSectionDialog({
    BuildContext context,
    MarketSection current,
    List<MarketSection> marketSections,
    Function(MarketSection selected) onSelectMarketSection,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ChooseMarketSectionDialog(
          current: current,
          marketSections: marketSections,
          onSelectMarketSection: onSelectMarketSection,
        );
      },
    );
  }
}

class _ChooseMarketSectionDialogState extends State<ChooseMarketSectionDialog> {
  void selectOption(MarketSection selected) {
    Navigator.of(context).pop();
    widget.onSelectMarketSection(selected);
  }

  Widget buildOption(MarketSection marketSection, int index) {
    return ListTile(
      onTap: () => {selectOption(marketSection)},
      title: Text(marketSection.title),
      leading: Radio<MarketSection>(
        key: Key('${Keys.chooseMarketSectionDialogOption}-$index'),
        value: marketSection,
        groupValue: widget.current,
        onChanged: selectOption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).pick_a_market_section),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.marketSections
              .asMap()
              .entries
              .map<Widget>(
                (entry) => buildOption(entry.value, entry.key),
              )
              .toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          key: Key(Keys.chooseMarketSectionDialogClear),
          child: Text(AppLocalizations.of(context).clean),
          onPressed: () {
            selectOption(null);
          },
        ),
      ],
    );
  }
}
