import 'dart:async';
import 'dart:io';
import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/model/save_backup_response.dart';
import 'package:sembast/sembast.dart';

class BackupDao {
  final dbProvider = SembastDatabaseProvider.dbProvider;
  final String recordKey = 'backup';

  Future<Backup> getBackup() async {
    var store = StoreRef.main();
    var db = await dbProvider.database;

    var record = await store.record(recordKey).get(db);
    if (record == null) {
      Backup backup = Backup(
        createdAt: CustomDateTime.current.millisecondsSinceEpoch,
        updatedAt: CustomDateTime.current.millisecondsSinceEpoch,
        lastestBackupStatus: BackupStatus.pending,
        type: BackupType.none,
      );
      await store.record(recordKey).put(db, backup.toRecord());
      return backup;
    }

    Backup backup = Backup.fromRecord(record);
    return backup;
  }

  Future deleteAll() async {
    var db = await dbProvider.database;
    await StoreRef.main().record(recordKey).delete(db);
  }

  Future<SaveBackupResponse> save({Backup backup}) async {
    try {
      var store = StoreRef.main();
      var db = await dbProvider.database;

      await store.record(recordKey).put(db, backup.toRecord());

      return SaveBackupResponse(backup: backup);
    } catch (e) {
      return SaveBackupResponse(error: e);
    }
  }

  Future<Backup> getDatabaseDataSummary() async {
    var store = StoreRef.main();
    var db = await dbProvider.database;

    var record = await store.record(recordKey).get(db);
    if (record == null) {
      Backup backup = Backup(
        createdAt: CustomDateTime.current.millisecondsSinceEpoch,
        updatedAt: CustomDateTime.current.millisecondsSinceEpoch,
        lastestBackupStatus: BackupStatus.pending,
        type: BackupType.none,
      );
      await store.record(recordKey).put(db, backup.toRecord());
      return backup;
    }

    Backup backup = Backup.fromRecord(record);
    return backup;
  }

  Future<String> getBackupDbFilePath() async {
    File file = new File(await dbProvider.getDatabaseFilePath());
    File copiedFile =
        await file.copy(await dbProvider.getDatabaseBackupFilePath());
    return copiedFile.path;
  }
}
