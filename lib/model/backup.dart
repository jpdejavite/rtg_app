enum BackupType { drive, none }
enum BackupStatus { error, pending, done }

class Backup {
  Backup({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.lastestBackupAt,
    this.lastestBackupStatus,
    this.type,
    this.error,
  });

  String id;
  int createdAt;
  int updatedAt;
  int lastestBackupAt;
  BackupStatus lastestBackupStatus;
  BackupType type;
  String error;

  bool hasId() {
    return this.id != null && this.id != "" && this.id != "0";
  }

  factory Backup.fromRecord(int id, Map<String, Object> record) {
    return Backup(
      id: id.toString(),
      createdAt: record["createdAt"],
      updatedAt: record["updatedAt"],
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
      'lastestBackupAt': this.lastestBackupAt,
      'lastestBackupStatus': this.lastestBackupStatus.index,
      'type': this.type.index,
      'error': this.error,
    };
  }
}
