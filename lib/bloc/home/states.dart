import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/backup.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitState extends HomeState {}

class BackupHasError extends HomeState {
  final Backup backup;
  BackupHasError({this.backup});
  @override
  List<Object> get props => [backup];
}

class BackupNotConfigured extends HomeState {}

class BackupOk extends HomeState {}

class AllDataDeleted extends HomeState {}
