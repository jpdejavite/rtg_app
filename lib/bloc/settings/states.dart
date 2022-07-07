import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/backup.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsInitState extends SettingsState {}

class BackupLoaded extends SettingsState {
  final Backup backup;
  BackupLoaded({this.backup});
  @override
  List<Object> get props => [backup];
}

class LocalBackupDone extends BackupLoaded {
  final String filePath;
  LocalBackupDone({this.filePath, backup}) : super(backup: backup);
}

class ImportBackupDone extends BackupLoaded {
  final Error error;
  ImportBackupDone({this.error, backup}) : super(backup: backup);
}
