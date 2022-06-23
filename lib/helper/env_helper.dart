import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvHelper {
  static bool isShareBackupFileEnabled() {
    String disableShareBackupFileFlag = dotenv.get('DISABLE_SHARE_BACKUP_FILE');
    if (disableShareBackupFileFlag == null) {
      return true;
    }

    return disableShareBackupFileFlag != "true";
  }
}
