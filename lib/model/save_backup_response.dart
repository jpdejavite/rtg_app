import 'backup.dart';

class SaveBackupResponse {
  final error;
  final Backup backup;

  SaveBackupResponse({this.error, this.backup});
}
