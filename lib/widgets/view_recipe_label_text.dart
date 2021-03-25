import 'package:flutter/material.dart';
import 'package:rtg_app/keys/keys.dart';

class ViewRecipeLabelText extends StatelessWidget {
  final String label;
  final String text;

  ViewRecipeLabelText({this.label, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: RichText(
        key: Key(Keys.viewRecipeLabelText),
        text: TextSpan(
          text: label + ": ",
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.bold),
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
