import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/backup.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitState extends HomeState {}

class AllDataDeleted extends HomeState {}

class ShowHomeInfo extends HomeState {
  final bool backupHasError;
  final bool backupNotConfigured;
  final bool backupOk;
  final Backup backup;
  final bool showRecipeTutorial;
  ShowHomeInfo({
    this.backupHasError,
    this.backupNotConfigured,
    this.backupOk,
    this.backup,
    this.showRecipeTutorial,
  });
  @override
  List<Object> get props => [
        backupHasError,
        backupNotConfigured,
        backupOk,
        backup,
        showRecipeTutorial,
      ];
}
