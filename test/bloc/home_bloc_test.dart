import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/home/events.dart';
import 'package:rtg_app/bloc/home/home_bloc.dart';
import 'package:rtg_app/bloc/home/states.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/repository/backup_repository.dart';

class MockBackupRepository extends Mock implements BackupRepository {}

void main() {
  HomeBloc homeBloc;
  MockBackupRepository backupRepository;

  setUp(() {
    backupRepository = MockBackupRepository();
    homeBloc = HomeBloc(backupRepository: backupRepository);
  });

  tearDown(() {
    homeBloc?.close();
  });

  test('initial state is correct', () {
    expect(homeBloc.state, HomeInitState());
  });

  test('fetch recipes', () {
    Backup backup = Backup(id: "123");

    final expectedResponse = [
      LoadingBackup(),
      BackupLoaded(backup: backup),
    ];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, BackupLoaded(backup: backup));
    });

    homeBloc.add(GetBackupEvent());
  });
}
