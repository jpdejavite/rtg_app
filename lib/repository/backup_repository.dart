import 'package:rtg_app/dao/backup_dao.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/model/save_backup_response.dart';

class BackupRepository {
  final backupDao = BackupDao();

  Future<Backup> getBackup() => backupDao.getBackup();

  Future<SaveBackupResponse> save({Backup backup}) =>
      backupDao.save(backup: backup);

  Future deleteAll() => backupDao.deleteAll();

  Future<String> getBackupDbFilePath() => backupDao.getBackupDbFilePath();
}
