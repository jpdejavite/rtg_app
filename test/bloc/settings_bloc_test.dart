import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:googleapis/drive/v3.dart' as drive;

import 'package:mockito/mockito.dart';
import 'package:rtg_app/api/google_api.dart';
import 'package:rtg_app/bloc/settings/events.dart';
import 'package:rtg_app/bloc/settings/settings_bloc.dart';
import 'package:rtg_app/bloc/settings/states.dart';
import 'package:rtg_app/errors/errors.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/database_data_summary.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

class MockBackupRepository extends Mock implements BackupRepository {}

class MockRecipesRepository extends Mock implements RecipesRepository {}

class MockGoogleApi extends Mock implements GoogleApi {}

void main() {
  SettingsBloc settingsBloc;
  MockBackupRepository backupRepository;
  RecipesRepository recipesRepository;
  MockGoogleApi googleApi;
  DateTime customTime = DateTime.parse("1969-07-20 20:18:04");

  setUp(() {
    backupRepository = MockBackupRepository();
    recipesRepository = MockRecipesRepository();
    googleApi = MockGoogleApi();
    settingsBloc = SettingsBloc(
        backupRepository: backupRepository,
        googleApi: googleApi,
        recipesRepository: recipesRepository);
    CustomDateTime.customTime = customTime;
  });

  tearDown(() {
    settingsBloc?.close();
    CustomDateTime.customTime = null;
  });

  test('initial state is correct', () {
    expect(settingsBloc.state, SettingsInitState());
  });

  test('get backup from type local', () {
    Backup backup = Backup(type: BackupType.local);

    final expectedResponse = [
      BackupLoaded(backup: backup),
    ];

    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));

    expectLater(
      settingsBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(settingsBloc.state, BackupLoaded(backup: backup));
    });

    settingsBloc.add(GetBackupEvent());
  });

  test('get backup from drive', () {
    Backup backup = Backup(type: BackupType.drive);
    String accountName = 'account-name';

    final expectedResponse = [
      BackupLoaded(backup: backup, accountName: accountName),
    ];

    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(googleApi.getAccountName()).thenReturn(accountName);

    expectLater(
      settingsBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(settingsBloc.state,
          BackupLoaded(backup: backup, accountName: accountName));
    });

    settingsBloc.add(GetBackupEvent());
  });

  test('configure backup in drive with error', () {
    Backup backup = Backup(type: BackupType.drive);
    String accountName = 'account-name';
    Error e = NotFoundError();

    final expectedResponse = [
      ConfigureDriveBackupError(
          backup: backup, accountName: accountName, error: e),
    ];

    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(googleApi.signIn()).thenAnswer((_) => Future.value(e));
    when(googleApi.getAccountName()).thenReturn(accountName);

    expectLater(
      settingsBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(
          settingsBloc.state,
          ConfigureDriveBackupError(
              backup: backup, accountName: accountName, error: e));
    });

    settingsBloc.add(ConfigureDriveBackupEvent());
  });

  test('configure backup in drive new file', () {
    Backup backup = Backup(type: BackupType.none);
    String accountName = 'account-name';
    String fileId = 'file-id';
    drive.File driveFile = drive.File();
    driveFile.id = fileId;

    final expectedResponse = [
      DoingDriveBackup(backup: backup, accountName: accountName),
      DriveBackupDone(backup: backup, accountName: accountName),
    ];

    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(backupRepository.save(backup: backup))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.signIn()).thenAnswer((_) => Future.value(null));
    when(googleApi.getAccountName()).thenReturn(accountName);
    when(googleApi.getBackupOnDrive()).thenAnswer((_) => Future.value(null));
    when(googleApi.doBackupOnDrive())
        .thenAnswer((_) => Future.value(driveFile));

    expectLater(
      settingsBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(settingsBloc.state is DriveBackupDone, true);
      expect((settingsBloc.state as DriveBackupDone).backup.type,
          BackupType.drive);
      expect((settingsBloc.state as DriveBackupDone).backup.updatedAt,
          customTime.millisecondsSinceEpoch);
      expect((settingsBloc.state as DriveBackupDone).backup.lastestBackupAt,
          customTime.millisecondsSinceEpoch);
      expect((settingsBloc.state as DriveBackupDone).backup.lastestBackupStatus,
          BackupStatus.done);
      expect((settingsBloc.state as DriveBackupDone).backup.fileId, fileId);
      expect((settingsBloc.state as DriveBackupDone).backup.error, null);
    });

    settingsBloc.add(ConfigureDriveBackupEvent());
  });

  test('do backup in drive with error', () {
    Backup backup = Backup(type: BackupType.drive);
    String accountName = 'account-name';
    String fileId = 'file-id';
    drive.File driveFile = drive.File();
    driveFile.id = fileId;
    Error e = GenericError("my generic error");

    final expectedResponse = [
      DoingDriveBackup(backup: backup, accountName: accountName),
      DriveBackupDone(backup: backup, accountName: accountName),
    ];

    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(backupRepository.save(backup: backup))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.getAccountName()).thenReturn(accountName);
    when(googleApi.getBackupOnDrive()).thenAnswer((_) => Future.value(null));
    when(googleApi.doBackupOnDrive()).thenAnswer((_) => throw e);

    expectLater(
      settingsBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(settingsBloc.state is DriveBackupDone, true);
      expect((settingsBloc.state as DriveBackupDone).backup.updatedAt,
          customTime.millisecondsSinceEpoch);
      expect(
          (settingsBloc.state as DriveBackupDone).backup.lastestBackupAt, null);
      expect((settingsBloc.state as DriveBackupDone).backup.lastestBackupStatus,
          BackupStatus.error);
      expect((settingsBloc.state as DriveBackupDone).backup.fileId, null);
      expect(
          (settingsBloc.state as DriveBackupDone).backup.error, e.toString());
    });

    settingsBloc.add(DoDriveBackupEvent());
  });

  test('do backup in drive with same file id', () {
    String fileId = 'file-id';
    Backup backup = Backup(type: BackupType.drive, fileId: fileId);
    String accountName = 'account-name';
    drive.File driveFile = drive.File();
    driveFile.id = fileId;
    File backupFile = File("");

    final expectedResponse = [
      DoingDriveBackup(backup: backup, accountName: accountName),
      DriveBackupDone(backup: backup, accountName: accountName),
    ];

    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(backupRepository.save(backup: backup))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.getAccountName()).thenReturn(accountName);
    when(googleApi.getBackupOnDrive())
        .thenAnswer((_) => Future.value(driveFile));
    when(googleApi.downloadBackupFromDrive(driveFile.id))
        .thenAnswer((_) => Future.value(backupFile));
    when(recipesRepository.mergeFromBackup(file: backupFile))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.updateBackupOnDrive(driveFile.id))
        .thenAnswer((_) => Future.value(null));

    expectLater(
      settingsBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(settingsBloc.state is DriveBackupDone, true);
      expect((settingsBloc.state as DriveBackupDone).backup.updatedAt,
          customTime.millisecondsSinceEpoch);
      expect((settingsBloc.state as DriveBackupDone).backup.lastestBackupAt,
          customTime.millisecondsSinceEpoch);
      expect((settingsBloc.state as DriveBackupDone).backup.lastestBackupStatus,
          BackupStatus.done);
      expect(
          (settingsBloc.state as DriveBackupDone).backup.fileId, driveFile.id);
      expect((settingsBloc.state as DriveBackupDone).backup.error, null);
    });

    settingsBloc.add(DoDriveBackupEvent());
  });

  test('do backup in drive with different file id', () {
    String fileId = 'file-id';
    Backup backup = Backup(
        type: BackupType.drive,
        fileId: fileId,
        lastestBackupStatus: BackupStatus.pending);
    String accountName = 'account-name';
    drive.File driveFile = drive.File();
    driveFile.id = 'drive-file-id';
    File backupFile = File("");
    DataSummary localRecipes = DataSummary(total: 10, lastUpdated: 1);
    DataSummary remoteRecipes = DataSummary(total: 2, lastUpdated: 2);
    DatabaseSummary localSummary = DatabaseSummary(recipes: localRecipes);
    DatabaseSummary remoteSummary = DatabaseSummary(recipes: remoteRecipes);

    final expectedResponse = [
      DoingDriveBackup(backup: backup, accountName: accountName),
      ChooseDriveBackup(
        backup: backup,
        accountName: accountName,
        localSummary: localSummary,
        remoteSummary: remoteSummary,
      ),
    ];

    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(backupRepository.save(backup: backup))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.getAccountName()).thenReturn(accountName);
    when(googleApi.getBackupOnDrive())
        .thenAnswer((_) => Future.value(driveFile));
    when(googleApi.downloadBackupFromDrive(driveFile.id))
        .thenAnswer((_) => Future.value(backupFile));
    when(recipesRepository.getSummary())
        .thenAnswer((_) => Future.value(localRecipes));
    when(recipesRepository.getSummary(file: backupFile))
        .thenAnswer((_) => Future.value(remoteRecipes));

    expectLater(
      settingsBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(settingsBloc.state is ChooseDriveBackup, true);
      expect((settingsBloc.state as ChooseDriveBackup).backup.updatedAt, null);
      expect((settingsBloc.state as ChooseDriveBackup).backup.lastestBackupAt,
          null);
      expect(
          (settingsBloc.state as ChooseDriveBackup).backup.lastestBackupStatus,
          BackupStatus.pending);
      expect((settingsBloc.state as ChooseDriveBackup).backup.fileId, fileId);
      expect((settingsBloc.state as ChooseDriveBackup).backup.error, null);
      expect(
          (settingsBloc.state as ChooseDriveBackup).localSummary, localSummary);
      expect((settingsBloc.state as ChooseDriveBackup).remoteSummary,
          remoteSummary);
    });

    settingsBloc.add(DoDriveBackupEvent());
  });

  test('drive backup choosen use local true', () {
    String fileId = 'file-id';
    Backup backup = Backup(type: BackupType.drive, fileId: fileId);
    String accountName = 'account-name';
    drive.File driveFile = drive.File();
    driveFile.id = 'drive-file-id';
    drive.File newDriveFile = drive.File();
    driveFile.id = 'new-drive-file-id';

    final expectedResponse = [
      DoingDriveBackup(backup: backup, accountName: accountName),
      DriveBackupDone(backup: backup, accountName: accountName),
    ];

    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(backupRepository.save(backup: backup))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.getAccountName()).thenReturn(accountName);
    when(googleApi.getBackupOnDrive())
        .thenAnswer((_) => Future.value(driveFile));
    when(googleApi.deleteBackupFromDrive(driveFile.id))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.doBackupOnDrive())
        .thenAnswer((_) => Future.value(newDriveFile));

    expectLater(
      settingsBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(settingsBloc.state is DriveBackupDone, true);
      expect((settingsBloc.state as DriveBackupDone).backup.updatedAt,
          customTime.millisecondsSinceEpoch);
      expect((settingsBloc.state as DriveBackupDone).backup.lastestBackupAt,
          customTime.millisecondsSinceEpoch);
      expect((settingsBloc.state as DriveBackupDone).backup.lastestBackupStatus,
          BackupStatus.done);
      expect((settingsBloc.state as DriveBackupDone).backup.fileId,
          newDriveFile.id);
      expect((settingsBloc.state as DriveBackupDone).backup.error, null);
    });

    settingsBloc.add(DriveBackupChoosenEvent(true));
  });

  test('drive backup choosen use local false', () {
    String fileId = 'file-id';
    Backup backup = Backup(type: BackupType.drive, fileId: fileId);
    String accountName = 'account-name';
    drive.File driveFile = drive.File();
    driveFile.id = 'drive-file-id';
    File backupFile = File("");

    final expectedResponse = [
      DoingDriveBackup(backup: backup, accountName: accountName),
      DriveBackupDone(backup: backup, accountName: accountName),
    ];

    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(backupRepository.save(backup: backup))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.getAccountName()).thenReturn(accountName);
    when(googleApi.getBackupOnDrive())
        .thenAnswer((_) => Future.value(driveFile));
    when(recipesRepository.deleteAll()).thenAnswer((_) => Future.value(Null));
    when(googleApi.downloadBackupFromDrive(driveFile.id))
        .thenAnswer((_) => Future.value(backupFile));
    when(recipesRepository.mergeFromBackup(file: backupFile))
        .thenAnswer((_) => Future.value(null));

    expectLater(
      settingsBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(settingsBloc.state is DriveBackupDone, true);
      expect((settingsBloc.state as DriveBackupDone).backup.updatedAt,
          customTime.millisecondsSinceEpoch);
      expect((settingsBloc.state as DriveBackupDone).backup.lastestBackupAt,
          customTime.millisecondsSinceEpoch);
      expect((settingsBloc.state as DriveBackupDone).backup.lastestBackupStatus,
          BackupStatus.done);
      expect(
          (settingsBloc.state as DriveBackupDone).backup.fileId, driveFile.id);
      expect((settingsBloc.state as DriveBackupDone).backup.error, null);
    });

    settingsBloc.add(DriveBackupChoosenEvent(false));
  });

  test('configure backup in local file', () {
    Backup backup = Backup(type: BackupType.local);
    String filePath = 'my file path';

    final expectedResponse = [
      LocalBackupDone(backup: backup, filePath: filePath),
    ];

    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(backupRepository.save(backup: backup))
        .thenAnswer((_) => Future.value(null));
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(backupRepository.getBackupDbFilePath())
        .thenAnswer((_) => Future.value(filePath));
    when(backupRepository.save(backup: backup))
        .thenAnswer((_) => Future.value(null));

    expectLater(
      settingsBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(settingsBloc.state,
          LocalBackupDone(backup: backup, filePath: filePath));
    });

    settingsBloc.add(ConfigureLocalBackupEvent());
  });
}
