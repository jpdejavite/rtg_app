import 'dart:async';
import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/model/save_backup_response.dart';
import 'package:sembast/sembast.dart';

class BackupDao {
  final dbProvider = SembastDatabaseProvider.dbProvider;

  Future<Backup> getBackup() async {
    var store = intMapStoreFactory.store('backups');
    var db = await dbProvider.database;

    var records = await store.find(db);
    if (records.length < 1) {
      Backup backup = Backup(
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        lastestBackupStatus: BackupStatus.pending,
        type: BackupType.none,
      );
      await db.transaction((txn) async {
        int id = await store.add(txn, backup.toRecord());
        backup.id = id.toString();
      });
      return backup;
    }

    var record = records[0];
    Backup backup = Backup.fromRecord(record.key, record.value);
    return backup;
  }

  Future<SaveBackupResponse> save({Backup backup}) async {
    try {
      var store = intMapStoreFactory.store('backups');
      var db = await dbProvider.database;
      var record = store.record(int.parse(backup.id));
      await record.update(db, backup.toRecord());

      return SaveBackupResponse(backup: backup);
    } catch (e) {
      return SaveBackupResponse(error: e);
    }
  }
}
