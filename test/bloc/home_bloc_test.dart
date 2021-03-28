import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/home/events.dart';
import 'package:rtg_app/bloc/home/home_bloc.dart';
import 'package:rtg_app/bloc/home/states.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

class MockBackupRepository extends Mock implements BackupRepository {}

class MockRecipesRepository extends Mock implements RecipesRepository {}

void main() {
  HomeBloc homeBloc;
  MockBackupRepository backupRepository;
  MockRecipesRepository recipesRepository;

  setUp(() {
    backupRepository = MockBackupRepository();
    recipesRepository = MockRecipesRepository();
    homeBloc = HomeBloc(
        backupRepository: backupRepository,
        recipesRepository: recipesRepository);
  });

  tearDown(() {
    homeBloc?.close();
  });

  test('initial state is correct', () {
    expect(homeBloc.state, HomeInitState());
  });

  test('backup has error', () {
    Backup backup = Backup(lastestBackupStatus: BackupStatus.error);

    final expectedResponse = [
      BackupHasError(backup: backup),
    ];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 0)));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, BackupHasError(backup: backup));
    });

    homeBloc.add(GetHomeDataEvent());
  });

  test('backup not configured', () {
    Backup backup = Backup(type: BackupType.none);

    final expectedResponse = [
      BackupNotConfigured(),
    ];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 1)));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, BackupNotConfigured());
    });

    homeBloc.add(GetHomeDataEvent());
  });

  test('backup ok', () {
    Backup backup = Backup(type: BackupType.drive);

    final expectedResponse = [BackupOk()];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 1)));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, BackupOk());
    });

    homeBloc.add(GetHomeDataEvent());
  });
}
