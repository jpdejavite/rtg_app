import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:rtg_app/api/google_api.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/repository/backup_repository.dart';

import 'events.dart';
import 'states.dart';

class SettingsBloc extends Bloc<SettingsEvents, SettingsState> {
  final BackupRepository backupRepository;
  final GoogleApi googleApi;
  SettingsBloc({
    @required this.backupRepository,
    @required this.googleApi,
  }) : super(SettingsInitState());
  @override
  Stream<SettingsState> mapEventToState(SettingsEvents event) async* {
    if (event is GetBackupEvent) {
      Backup backup = await backupRepository.getBackup();
      if (backup.type == BackupType.drive) {
        String accountName = googleApi.getAccountName();
        yield BackupLoaded(backup: backup, accountName: accountName);
      } else {
        yield BackupLoaded(backup: backup);
      }
    } else if (event is ConfigureDriveBackupEvent) {
      Error e = await googleApi.signIn();
      if (e == null) {
        Backup backup = await backupRepository.getBackup();
        backup.type = BackupType.drive;
        backup.updatedAt = DateTime.now().millisecondsSinceEpoch;
        String accountName = googleApi.getAccountName();
        await backupRepository.save(backup: backup);
        yield BackupLoaded(backup: backup, accountName: accountName);
        await doGoogleDriveBackup();
      } else {
        print('error:$e');
      }
    } else if (event is DoDriveBackupEvent) {
      await doGoogleDriveBackup();
    }
  }

  Future<void> doGoogleDriveBackup() async {
    drive.File file = await googleApi.getBackupOnDrive();
    if (file == null) {
      await googleApi.doBackupOnDrive();
    }
    print('file found ${file.name}');
  }
}
