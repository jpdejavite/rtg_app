import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/backup.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitState extends HomeState {}

class LoadingBackup extends HomeState {}

class BackupLoaded extends HomeState {
  final Backup backup;
  BackupLoaded({this.backup});
  @override
  List<Object> get props => [backup];
}

class BackupLoadError extends HomeState {
  final error;
  BackupLoadError({this.error});
}
