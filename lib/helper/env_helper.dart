import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvHelper {
  static bool isShareBackupFileEnabled() {
    String disableShareBackupFileFlag = dotenv.get('DISABLE_SHARE_BACKUP_FILE');
    if (disableShareBackupFileFlag == null) {
      return true;
    }

    return disableShareBackupFileFlag != "true";
  }

  static bool isShareRecipeAsImageEnabled() {
    String disableShareRecipeAsImageFlag =
        dotenv.get('DISABLE_SHARE_RECIPE_AS_IMAGE');
    if (disableShareRecipeAsImageFlag == null) {
      return true;
    }

    return disableShareRecipeAsImageFlag != "true";
  }

  static bool isShareRecipeAsPdfEnabled() {
    String disableShareRecipeAsPdfFlag =
        dotenv.get('DISABLE_SHARE_RECIPE_AS_PDF');
    if (disableShareRecipeAsPdfFlag == null) {
      return true;
    }

    return disableShareRecipeAsPdfFlag != "true";
  }
}
