import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/settings/events.dart';
import 'package:rtg_app/bloc/settings/settings_bloc.dart';
import 'package:rtg_app/bloc/settings/states.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

class MockBackupRepository extends Mock implements BackupRepository {}

class MockRecipesRepository extends Mock implements RecipesRepository {}

void main() {
  SettingsBloc settingsBloc;
  MockBackupRepository backupRepository;
  RecipesRepository recipesRepository;
  DateTime customTime = DateTime.parse("1969-07-20 20:18:04");

  setUp(() {
    backupRepository = MockBackupRepository();
    recipesRepository = MockRecipesRepository();
    settingsBloc = SettingsBloc(
        backupRepository: backupRepository,
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
