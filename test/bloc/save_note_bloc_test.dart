import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/save_note/events.dart';
import 'package:rtg_app/bloc/save_note/save_note_bloc.dart';
import 'package:rtg_app/bloc/save_note/states.dart';
import 'package:rtg_app/model/note.dart';
import 'package:rtg_app/repository/note_repository.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  SaveNoteBloc saveNoteBloc;
  MockNoteRepository noteRepository;

  setUp(() {
    noteRepository = MockNoteRepository();
    saveNoteBloc = SaveNoteBloc(noteRepository: noteRepository);
  });

  tearDown(() {
    saveNoteBloc?.close();
  });

  test('initial state is correct', () {
    expect(saveNoteBloc.state, SaveNoteInitState());
  });

  test('get note', () {
    Note note = Note(description: 'desc');

    final expectedResponse = [
      NoteLoaded(note: note),
    ];

    when(noteRepository.getNote()).thenAnswer((_) => Future.value(note));

    expectLater(
      saveNoteBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveNoteBloc.state, NoteLoaded(note: note));
    });

    saveNoteBloc.add(GetNoteEvent());
  });

  test('save note', () {
    Note note = Note(description: 'desc');
    String newDesc = 'new-desc';
    Note newNote = Note(description: newDesc);

    final expectedResponse = [
      NoteSaved(),
    ];

    when(noteRepository.getNote()).thenAnswer((_) => Future.value(note));
    when(noteRepository.save(note: newNote))
        .thenAnswer((_) => Future.value(null));

    expectLater(
      saveNoteBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveNoteBloc.state, NoteSaved());
    });

    saveNoteBloc.add(SaveNoteEvent(newDesc));
  });
}
