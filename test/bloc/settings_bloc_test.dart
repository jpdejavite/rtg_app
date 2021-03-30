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
import 'package:rtg_app/repository/backup_repository.dart';

class MockBackupRepository extends Mock implements BackupRepository {}

class MockGoogleApi extends Mock implements GoogleApi {}

void main() {
  SettingsBloc settingsBloc;
  MockBackupRepository backupRepository;
  MockGoogleApi googleApi;
  DateTime customTime = DateTime.parse("1969-07-20 20:18:04");

  setUp(() {
    backupRepository = MockBackupRepository();
    googleApi = MockGoogleApi();
    settingsBloc =
        SettingsBloc(backupRepository: backupRepository, googleApi: googleApi);
    CustomDateTime.customTime = customTime;
  });

  tearDown(() {
    settingsBloc?.close();
    CustomDateTime.customTime = null;
  });

  test('initial state is correct', () {
    expect(settingsBloc.state, SettingsInitState());
  });

  test('get backup from type none', () {
    Backup backup = Backup(type: BackupType.none);

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
}
