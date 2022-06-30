class StringHelper {
  static String removeLeadingPrepostion(String text) {
    return text.replaceFirst(RegExp(r'(de )|(of )'), '').trim();
  }

  static List<String> breakTextIntoParagraph(String text, int maxLineSize) {
    if (text == null || text == "") {
      return [];
    }

    List<String> paragraph = [];
    while (maxLineSize < text.length) {
      String newParagrapahLine = text.substring(0, maxLineSize);
      String remainingText = text.substring(maxLineSize);
      if (!RegExp(r'\s$').hasMatch(newParagrapahLine) &&
          !RegExp(r'^\s').hasMatch(remainingText)) {
        text = newParagrapahLine[newParagrapahLine.length - 1] + remainingText;
        paragraph.add(
            newParagrapahLine.substring(0, newParagrapahLine.length - 1) + "-");
      } else {
        text = remainingText;
        paragraph.add(newParagrapahLine);
      }
    }

    paragraph.add(text);
    return paragraph;
  }
}
