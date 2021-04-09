class StringHelper {
  static String removeLeadingPropostion(String text) {
    return text.replaceFirst(RegExp(r'(de )|(of )'), '').trim();
  }
}
