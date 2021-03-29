enum BackupType { drive, none }
enum BackupStatus { error, pending, done }

class Backup {
  Backup({
    this.createdAt,
    this.updatedAt,
    this.fileId,
    this.lastestBackupAt,
    this.lastestBackupStatus,
    this.type,
    this.error,
  });

  int createdAt;
  int updatedAt;
  int lastestBackupAt;
  String fileId;
  BackupStatus lastestBackupStatus;
  BackupType type;
  String error;

  factory Backup.fromRecord(Map<String, Object> record) {
    return Backup(
      createdAt: record["createdAt"],
      updatedAt: record["updatedAt"],
      fileId: record["fileId"],
      lastestBackupAt: record["lastestBackupAt"],
      lastestBackupStatus:
          BackupStatus.values[record["lastestBackupStatus"] as int],
      type: BackupType.values[record["type"] as int],
      error: record["error"],
    );
  }

  Object toRecord() {
    return {
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'fileId': this.fileId,
      'lastestBackupAt': this.lastestBackupAt,
      'lastestBackupStatus': this.lastestBackupStatus.index,
      'type': this.type.index,
      'error': this.error,
    };
  }
}
