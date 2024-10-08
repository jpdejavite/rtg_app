import 'package:flutter/material.dart';
import 'package:rtg_app/theme/custom_colors.dart';

class ViewRecipeLabelText extends StatelessWidget {
  final String label;
  final String text;
  final String keyString;

  ViewRecipeLabelText({this.label, this.text, this.keyString});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: RichText(
        key: Key(keyString),
        text: TextSpan(
          text: label + ": ",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.bold, color: CustomColors.primaryColor),
          children: [
            TextSpan(
              text: text,
              style: Theme.of(context).textTheme.bodyText2,
            )
          ],
        ),
      ),
    );
  }
}
