import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtg_app/theme/custom_colors.dart';

class ViewRecipeLabel extends StatelessWidget {
  final String label;
  final String copyText;

  ViewRecipeLabel({this.label, this.copyText});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Text(
        label + ": ",
        style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontWeight: FontWeight.bold, color: CustomColors.primaryColor),
      )
    ];

    bool hasCopyText = copyText != null && copyText != "";
    if (hasCopyText) {
      children.add(IconButton(
        icon: Icon(Icons.copy),
        onPressed: () {
          Clipboard.setData(new ClipboardData(text: copyText));
        },
      ));
    }

    return Padding(
      padding: EdgeInsets.only(
          top: hasCopyText ? 0 : 10, bottom: hasCopyText ? 0 : 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}
