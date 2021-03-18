import 'package:flutter/material.dart';
import 'package:rtg_app/keys/keys.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(key: Key(Keys.wholeScreenLoading)),
      ),
    );
  }
}
