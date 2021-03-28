import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/backup.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsInitState extends SettingsState {}

class BackupLoaded extends SettingsState {
  final Backup backup;
  final String accountName;
  BackupLoaded({this.backup, this.accountName});
}
