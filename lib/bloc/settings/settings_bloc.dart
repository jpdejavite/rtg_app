import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:path/path.dart' as p;

import '../../errors/errors.dart';
import 'events.dart';
import 'states.dart';

class SettingsBloc extends Bloc<SettingsEvents, SettingsState> {
  final BackupRepository backupRepository;
  final RecipesRepository recipesRepository;
  SettingsBloc({
    @required this.backupRepository,
    @required this.recipesRepository,
  }) : super(SettingsInitState());
  @override
  Stream<SettingsState> mapEventToState(SettingsEvents event) async* {
    if (event is GetBackupEvent) {
      yield await getBackupEvent(event);
      return;
    }

    if (event is ConfigureLocalBackupEvent) {
      await configureLocalBackup();
    }

    if (event is DoLocalBackupEvent || event is ConfigureLocalBackupEvent) {
      yield await doLocalBackup();
      return;
    }

    if (event is ImportLocalBackupEvent) {
      yield await importLocalBackup(event.filePath);
      return;
    }
  }

  Future<BackupLoaded> getBackupEvent(SettingsEvents event) async {
    Backup backup = await backupRepository.getBackup();
    return BackupLoaded(backup: backup);
  }

  Future<void> configureLocalBackup() async {
    Backup backup = await backupRepository.getBackup();
    backup.type = BackupType.local;
    backup.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
    backup.error = null;
    await backupRepository.save(backup: backup);
  }

  Future<SettingsState> doLocalBackup() async {
    Backup backup = await backupRepository.getBackup();
    String filePath = await backupRepository.getBackupDbFilePath();

    backup.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
    backup.lastestBackupAt = CustomDateTime.current.millisecondsSinceEpoch;
    backup.lastestBackupStatus = BackupStatus.done;
    backup.error = null;
    await backupRepository.save(backup: backup);

    return LocalBackupDone(backup: backup, filePath: filePath);
  }

  Future<SettingsState> importLocalBackup(String backupFilePath) async {
    Backup backup = await backupRepository.getBackup();

    final extension = p.extension(backupFilePath);
    if (extension != ".db") {
      return ImportBackupDone(error: InvalidBackupFile(), backup: backup);
    }

    String filePath = await backupRepository.getDbFilePath();
    try {
      await moveFile(backupFilePath, filePath);
    } catch (e) {
      return ImportBackupDone(
          error: GenericError(e.toString()), backup: backup);
    }

    backup.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
    backup.lastestBackupAt = CustomDateTime.current.millisecondsSinceEpoch;
    backup.lastestBackupStatus = BackupStatus.done;
    backup.error = null;
    await backupRepository.save(backup: backup);

    return ImportBackupDone(backup: backup);
  }

  Future<File> moveFile(String sourceFilePath, String newPath) async {
    File sourceFile = File(sourceFilePath);
    try {
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }
}
