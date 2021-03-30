import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:rtg_app/api/google_api.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/database_data_summary.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

import 'events.dart';
import 'states.dart';

class SettingsBloc extends Bloc<SettingsEvents, SettingsState> {
  final BackupRepository backupRepository;
  final RecipesRepository recipesRepository;
  final GoogleApi googleApi;
  SettingsBloc({
    @required this.backupRepository,
    @required this.googleApi,
    @required this.recipesRepository,
  }) : super(SettingsInitState());
  @override
  Stream<SettingsState> mapEventToState(SettingsEvents event) async* {
    Backup backup = await backupRepository.getBackup();
    if (event is GetBackupEvent) {
      if (backup.type == BackupType.drive) {
        String accountName = googleApi.getAccountName();
        yield BackupLoaded(backup: backup, accountName: accountName);
      } else {
        yield BackupLoaded(backup: backup);
      }
      return;
    }

    if (event is ConfigureDriveBackupEvent) {
      Error e = await googleApi.signIn();
      if (e == null) {
        backup.type = BackupType.drive;
        backup.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
        backup.error = null;
        await backupRepository.save(backup: backup);
      } else {
        String accountName = googleApi.getAccountName();
        yield ConfigureDriveBackupError(
            backup: backup, accountName: accountName, error: e);
        return;
      }
    }

    if (event is DoDriveBackupEvent ||
        event is ConfigureDriveBackupEvent ||
        event is DriveBackupChoosenEvent) {
      String accountName = googleApi.getAccountName();
      yield DoingDriveBackup(backup: backup, accountName: accountName);
      try {
        drive.File file = await googleApi.getBackupOnDrive();
        if (file == null) {
          file = await googleApi.doBackupOnDrive();
        } else {
          if (backup.fileId == file.id) {
            File backupFile = await googleApi.downloadBackupFromDrive(file.id);
            await recipesRepository.mergeFromBackup(file: backupFile);
            await googleApi.updateBackupOnDrive(file.id);
          } else if (event is DriveBackupChoosenEvent) {
            if (event.useLocal) {
              await googleApi.deleteBackupFromDrive(file.id);
              file = await googleApi.doBackupOnDrive();
            } else {
              await recipesRepository.deleteAll();

              File backupFile =
                  await googleApi.downloadBackupFromDrive(file.id);
              await recipesRepository.mergeFromBackup(file: backupFile);
            }
          } else {
            File backupFile = await googleApi.downloadBackupFromDrive(file.id);
            DataSummary localRecipes = await recipesRepository.getSummary();
            DataSummary remoteRecipes =
                await recipesRepository.getSummary(file: backupFile);
            yield ChooseDriveBackup(
              backup: backup,
              accountName: accountName,
              localSummary: DatabaseSummary(recipes: localRecipes),
              remoteSummary: DatabaseSummary(recipes: remoteRecipes),
            );
            return;
          }
        }

        backup.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
        backup.lastestBackupAt = CustomDateTime.current.millisecondsSinceEpoch;
        backup.lastestBackupStatus = BackupStatus.done;
        backup.fileId = file.id;
        backup.error = null;
        await backupRepository.save(backup: backup);

        yield DriveBackupDone(backup: backup, accountName: accountName);
      } catch (e) {
        backup.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
        backup.lastestBackupStatus = BackupStatus.error;
        backup.error = e.toString();
        await backupRepository.save(backup: backup);

        yield DriveBackupDone(backup: backup, accountName: accountName);
      }
    }
  }
}
