import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/model/database_data_summary.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsInitState extends SettingsState {}

class BackupLoaded extends SettingsState {
  final Backup backup;
  final String accountName;
  BackupLoaded({this.backup, this.accountName});
  @override
  List<Object> get props => [backup, accountName];
}

class DoingDriveBackup extends BackupLoaded {
  DoingDriveBackup({backup, accountName})
      : super(backup: backup, accountName: accountName);
}

class ConfigureDriveBackupError extends BackupLoaded {
  final Error error;
  ConfigureDriveBackupError({backup, accountName, this.error})
      : super(backup: backup, accountName: accountName);
  @override
  List<Object> get props => [backup, accountName, error];
}

class DriveBackupDone extends BackupLoaded {
  DriveBackupDone({backup, accountName})
      : super(backup: backup, accountName: accountName);
}

class LocalBackupDone extends BackupLoaded {
  final String filePath;
  LocalBackupDone({this.filePath, backup}) : super(backup: backup);
}

class ChooseDriveBackup extends BackupLoaded {
  final DatabaseSummary localSummary;
  final DatabaseSummary remoteSummary;
  ChooseDriveBackup(
      {backup, accountName, this.localSummary, this.remoteSummary})
      : super(backup: backup, accountName: accountName);
  @override
  List<Object> get props => [backup, accountName, localSummary, remoteSummary];
}
