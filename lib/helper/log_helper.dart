import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class LogHelper {
  static File backupFile;
  static String backupFileName = 'backup.log';

  static Future<void> log(String message) async {
    try {
      await getBackupLogFile();
      await backupFile.writeAsString(
          '${DateTime.now().toIso8601String()} $message\n',
          mode: FileMode.writeOnlyAppend);
    } catch (e) {
      print('error at log $e');
    }
  }

  static Future printAll() async {
    await getBackupLogFile();
    print('${DateTime.now().toIso8601String()} backupg logs:');
    String logsContent = await backupFile.readAsString();
    if (logsContent != null) {
      print(logsContent.length > 300
          ? logsContent.substring(logsContent.length - 300)
          : logsContent);
    }
  }

  static Future<void> getBackupLogFile() async {
    if (backupFile != null) return backupFile;
    final appDocDir = await getApplicationDocumentsDirectory();
    await appDocDir.create(recursive: true);
    String filePath = p.join(appDocDir.path, backupFileName);

    backupFile = await new File(filePath).create(recursive: true);
  }
}
