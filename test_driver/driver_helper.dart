import 'dart:developer';

import 'package:flutter_driver/flutter_driver.dart';

import 'error_wrapper.dart';

class DriverHelper {
  static final SerializableFinder backButtonFinder = find.byTooltip("Voltar");

  final FlutterDriver driver;

  DriverHelper(this.driver);

  close() async {
    if (driver != null) {
      await driver.close();
    }
  }

  scrollIntoView(String key, {Duration timeout}) async {
    try {
      await driver.scrollIntoView(find.byValueKey(key),
          timeout: timeout == null ? Duration(seconds: 1) : timeout);
    } catch (e) {
      final newError = new ErrorWrapper('error scrollIntoView $key: $e', e);
      log(newError.toString());
      throw newError;
    }
  }

  scrollUntilVisible(
    String scrollableKey,
    String itemKey, {
    double alignment = 0.0,
    double dxScroll = 0.0,
    double dyScroll = 0.0,
    Duration timeout,
  }) async {
    try {
      await driver.scrollUntilVisible(
          find.byValueKey(scrollableKey), find.byValueKey(itemKey),
          alignment: alignment,
          dxScroll: dxScroll,
          dyScroll: dyScroll,
          timeout: timeout == null ? Duration(seconds: 1) : timeout);
    } catch (e) {
      final newError = new ErrorWrapper(
          'error scrollUntilVisible $scrollableKey $itemKey: $e', e);
      log(newError.toString());
      throw newError;
    }
  }

  scroll(String key, double dx, double dy, Duration duration,
      {Duration timeout}) async {
    try {
      await driver.scroll(find.byValueKey(key), dx, dy, duration,
          timeout: Duration(seconds: 1 + duration.inSeconds));
    } catch (e) {
      final newError = new ErrorWrapper('error scroll $key: $e', e);
      log(newError.toString());
      throw newError;
    }
  }

  tap(String key, {Duration timeout}) async {
    try {
      await driver.tap(find.byValueKey(key),
          timeout: timeout == null ? Duration(seconds: 1) : timeout);
    } catch (e) {
      final newError = new ErrorWrapper('error tapping $key: $e', e);
      log(newError.toString());
      throw newError;
    }
  }

  tapInText(String text, {Duration timeout}) async {
    try {
      await driver.tap(find.text(text),
          timeout: timeout == null ? Duration(seconds: 1) : timeout);
    } catch (e) {
      final newError = new ErrorWrapper('error tapping in text $text: $e', e);
      log(newError.toString());
      throw newError;
    }
  }

  tapBackButton({Duration timeout}) async {
    try {
      await driver.waitFor(backButtonFinder,
          timeout: timeout == null ? Duration(seconds: 1) : timeout);
      await driver.tap(backButtonFinder,
          timeout: timeout == null ? Duration(seconds: 1) : timeout);
    } catch (e) {
      final newError = new ErrorWrapper('error tapping back button: $e', e);
      log(newError.toString());
      throw newError;
    }
  }

  Future<String> getText(String key, {Duration timeout}) async {
    try {
      return await driver.getText(find.byValueKey(key),
          timeout: timeout == null ? Duration(seconds: 1) : timeout);
    } catch (e) {
      final newError = new ErrorWrapper('error tapping $key: $e', e);
      log(newError.toString());
      throw newError;
    }
  }

  enterText(String text, {Duration timeout}) async {
    try {
      await driver.enterText(text,
          timeout: timeout == null ? Duration(seconds: 1) : timeout);
    } catch (e) {
      final newError = new ErrorWrapper('error enterText: $e', e);
      log(newError.toString());
      throw newError;
    }
  }

  Future<bool> isPresent(String key,
      {Duration timeout = const Duration(seconds: 1)}) async {
    try {
      await driver.waitFor(find.byValueKey(key),
          timeout: timeout == null ? Duration(seconds: 1) : timeout);
      return true;
    } catch (e) {
      return false;
    }
  }
}
