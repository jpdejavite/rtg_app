import 'package:flutter_test/flutter_test.dart';
import 'package:rtg_app/helper/string_helper.dart';

void main() {
  test('removeLeadingPrepostion from string without proposition', () {
    expect(StringHelper.removeLeadingPrepostion("aaabbbb"), "aaabbbb");
  });

  test('removeLeadingPrepostion from string with pt proposition', () {
    expect(StringHelper.removeLeadingPrepostion("de aaabbbb"), "aaabbbb");
  });

  test('removeLeadingPrepostion from string with en proposition', () {
    expect(StringHelper.removeLeadingPrepostion("of aaabbbb"), "aaabbbb");
  });

  test('breakTextIntoParagraph null string', () {
    expect(StringHelper.breakTextIntoParagraph(null, 4), []);
  });

  test('breakTextIntoParagraph empty string', () {
    expect(StringHelper.breakTextIntoParagraph("", 4), []);
  });

  test('breakTextIntoParagraph small string', () {
    expect(StringHelper.breakTextIntoParagraph("abc", 4), ["abc"]);
  });

  test('breakTextIntoParagraph equal string to max line size', () {
    expect(StringHelper.breakTextIntoParagraph("abcd", 4), ["abcd"]);
  });

  test('breakTextIntoParagraph equal string to max line size', () {
    expect(StringHelper.breakTextIntoParagraph("abcd", 4), ["abcd"]);
  });

  test('breakTextIntoParagraph big string with dash', () {
    expect(StringHelper.breakTextIntoParagraph("abc abc abcde", 6),
        ["abc a-", "bc ab-", "cde"]);
  });

  test('breakTextIntoParagraph big string without dash', () {
    expect(StringHelper.breakTextIntoParagraph("abcde abcd", 6),
        ["abcde ", "abcd"]);
  });

  test('breakTextIntoParagraph big string without dash', () {
    expect(StringHelper.breakTextIntoParagraph("abcdef abcd", 6),
        ["abcdef", " abcd"]);
  });
}
