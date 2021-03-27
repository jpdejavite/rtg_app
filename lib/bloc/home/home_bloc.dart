import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/repository/backup_repository.dart';

import 'events.dart';
import 'states.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  final BackupRepository backupRepository;
  HomeBloc({this.backupRepository}) : super(HomeInitState());
  @override
  Stream<HomeState> mapEventToState(HomeEvents event) async* {
    if (event is GetBackupEvent) {
      yield LoadingBackup();
      yield BackupLoaded(backup: await backupRepository.getBackup());
    }
  }
}
